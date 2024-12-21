/**
 * (C) Copyright 2022 Araf Karsh Hamid
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.fusion.air.microservice.adapters.security.jwt;
// Custom
import io.fusion.air.microservice.adapters.security.core.UserRole;
import io.fusion.air.microservice.adapters.security.service.UserDetailsServiceImpl;
import io.fusion.air.microservice.domain.exceptions.*;
import io.fusion.air.microservice.security.jwt.client.JsonWebTokenValidator;
import io.fusion.air.microservice.security.jwt.core.TokenData;
import io.fusion.air.microservice.security.jwt.core.TokenDataFactory;
import static io.fusion.air.microservice.security.jwt.core.JsonWebTokenConstants.*;
// JWT
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
// Jakarta
import jakarta.servlet.http.HttpServletRequest;
// Aspect
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
// Log
import org.slf4j.Logger;
import org.slf4j.MDC;
import static java.lang.invoke.MethodHandles.lookup;
import static org.slf4j.LoggerFactory.getLogger;
// Spring
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * User Token Authorization
 *
 * @author: Araf Karsh Hamid
 * @version:
 * @date:
 */
@Component
public class UserTokenAuthorization {

    // Set Logger -> Lookup will automatically determine the class name.
    private static final Logger log = getLogger(lookup().lookupClass());

    // Autowired using the Constructor
    private final TokenDataFactory tokenFactory;

    // Autowired using the Constructor
    private final UserDetailsServiceImpl userDetailsService;

    // Autowired using the Constructor
    private final ClaimsManager claimsManager;

    /**
     * Autowired using the Constructor
     * @param userService
     * @param claims
     */
    public UserTokenAuthorization(TokenDataFactory tokenFactory, UserDetailsServiceImpl userService,
                                  ClaimsManager claims ) {
        this.tokenFactory = tokenFactory;
        this.userDetailsService = userService;
        this.claimsManager = claims;
    }

    /**
     * Validate the Request
     *
     * @param singleToken
     * @param tokenMode
     * @param joinPoint
     * @param tokenCtg
     * @return
     * @throws Throwable
     */
    public Object validateRequest(boolean singleToken, String tokenMode,
                                  ProceedingJoinPoint joinPoint, int tokenCtg) throws Throwable {
        // Get the request object
        long startTime = System.currentTimeMillis();
        ServletRequestAttributes attributes = (ServletRequestAttributes)
                RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes.getRequest();
        logTime(startTime, "Validating", request.getRequestURI(), joinPoint);
        final String token = getToken(startTime, request.getHeader(AUTH_TOKEN), joinPoint);
        TokenData tokenData = tokenFactory.createTokenData(token);
        final String user = getUser(startTime, tokenData, joinPoint);
        log.info("Step 0: User Extracted... {} ", user);
        // Validate the Token when User is NOT Null
        if (user != null) {
            // Validate Token
            UserDetails userDetails = validateToken(startTime, singleToken, user, tokenMode, tokenData, joinPoint, tokenCtg);
            // Create Authorize Token
            UsernamePasswordAuthenticationToken authorizeToken = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities());
            authorizeToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            // Set the Security Context with current user as Authorized for the request,
            // So it passes the Spring Security Configurations successfully.
            SecurityContextHolder.getContext().setAuthentication(authorizeToken);
            logTime(startTime, SUCCESS, "User Authorized for the request",  joinPoint);
        }
        // If the User == NULL then ERROR is thrown from getUser() method itself
        // Check the Tx Token if It's NOT a SINGLE_TOKEN Request
        if(!singleToken ) {
            validateAndSetClaimsFromTxToken(startTime, user, request.getHeader(TX_TOKEN), joinPoint);
        }
        return joinPoint.proceed();
    }

    /**
     * Extract the Token fromm the Authorization Header
     * ------------------------------------------------------------------------------------------------------
     * Authorization: Bearer AAA.BBB.CCC
     * ------------------------------------------------------------------------------------------------------
     *
     * @param startTime
     * @param jwToken
     * @param joinPoint
     * @return
     */
    private String getToken(long startTime, String jwToken, ProceedingJoinPoint joinPoint) {
        if (jwToken != null && jwToken.startsWith(BEARER)) {
            return jwToken.substring(7);
        }
        String msg = "Access Denied: Unable to extract token from Header!";
        logTime(startTime, ERROR, msg,  joinPoint);
        throw new JWTTokenExtractionException(msg);
    }

    /**
     * Returns the user from the Token
     *
     * @param startTime
     * @param token
     * @param joinPoint
     * @return
     */
    private String getUser(long startTime, TokenData token, ProceedingJoinPoint joinPoint) {
        String user = null;
        String msg = null;
        try {
            user = JsonWebTokenValidator.getSubjectFromToken(token);
            // Store the user info for logging
            MDC.put("user", user);
            return user;
        } catch (IllegalArgumentException e) {
            msg = "Access Denied: Unable to get Subject JWT Token Error: "+e.getMessage();
            throw new JWTTokenSubjectException(msg, e);
        } catch (ExpiredJwtException e) {
            msg = "Access Denied: JWT Token has expired Error: "+e.getMessage();
            throw new JWTTokenExpiredException(msg, e);
        } catch (NullPointerException e) {
            msg = "Access Denied: Invalid Token (Null Token) Error: "+e.getMessage();
            throw new JWTUnDefinedException(msg, e);
        } catch (Exception e) {
            msg = "Access Denied: Error Extracting User:  "+e.getMessage();
            throw new JWTUnDefinedException(msg, e);
        } finally {
            if(msg != null) {
                logTime(startTime, ERROR, msg, joinPoint);
            }
        }
    }

    /**
     * Validate Token
     * - User
     * - Expiry Time
     *
     * @param startTime
     * @param singleToken
     * @param user
     * @param tokenMode
     * @param token
     * @param joinPoint
     * @param tokenCtg
     * @return
     */
    private UserDetails validateToken(long startTime, boolean singleToken, String user, String tokenMode,
                                      TokenData token, ProceedingJoinPoint joinPoint, int tokenCtg) {
        UserDetails userDetails = userDetailsService.loadUserByUsername(user);
        String msg = null;
        try {
            // Validate the Token
            if (JsonWebTokenValidator.validateToken(userDetails.getUsername(), token)) {
                String role = JsonWebTokenValidator.getUserRoleFromToken(token);
                // Set the Claims ONLY If it's a Single Token
                Claims claims = JsonWebTokenValidator.getAllClaims(token);
                if(singleToken) {
                    claimsManager.setClaims(claims);
                    claimsManager.isClaimsInitialized();
                }
                // Validate the Token Type
                getTokenTypeFromClaims( startTime,  user,  tokenMode, claims,  tokenCtg,  joinPoint);
                // Verify that the user role name matches the role name defined by the protected resource
                verifyTheUserRole( role,  tokenMode,  joinPoint);
                return userDetails;
            } else {
                msg = "Auth-Token: Unauthorized Access: Token Validation Failed!";
                throw new AuthorizationException(msg);
            }
        } catch(AuthorizationException e) {
            throw e;
        } catch(Exception e) {
            msg = "Auth-Token: Unauthorized Access: Error: "+e.getMessage();
            throw new AuthorizationException(msg, e);
        } finally {
            // Error is Logged ONLY if msg != NULL
            if(msg != null) {
                logTime(startTime, ERROR, msg, joinPoint);
            }
        }
    }

    /**
     * Validate the Token Type
     *
     * @param startTime
     * @param user
     * @param claims
     * @param tokenCtg
     * @param joinPoint
     */
    private void getTokenTypeFromClaims(long startTime, String user, String tokenMode, Claims claims,
                                        int tokenCtg, ProceedingJoinPoint joinPoint) {
        String msg = null;
        try {
            if (claims == null) {
                msg = "Invalid Token! No Claims available! " + user;
                throw new AuthorizationException(msg);
            }
            String tokenType =  getTokenTypeFromClaims( user,  claims);
            switch(tokenCtg) {
                case CONSUMERS:
                    if (tokenMode.equals(REFRESH_TOKEN_MODE) && !tokenType.equals(AUTH_REFRESH)) {
                        msg = "Invalid Refresh Token! " + user;
                        throw new AuthorizationException(msg);
                    }
                    if ( !tokenType.equals(AUTH)) {
                        msg = "Invalid Auth Token! (" + tokenType + ")  For " + user;
                        throw new AuthorizationException(msg);
                    }
                    break;
                case INTERNAL_SERVICES:
                    if (tokenMode.equals(SECURE_PKG_MODE) && !tokenType.equals(TX_SERVICE )) {
                        msg = "Invalid Auth Token ("+tokenType+") For Internal Service! " + user;
                        throw new AuthorizationException(msg);
                    }
                    break;
                case EXTERNAL_SERVICES:
                    if (tokenMode.equals(SECURE_PKG_MODE) && !tokenType.equals(TX_EXTERNAL )) {
                        msg = "Invalid Auth Token ("+tokenType+") For External! " + user;
                        throw new AuthorizationException(msg);
                    }
                    break;
                default:
                    throw new AuthorizationException("Invalid Token Category.");
            }
        } finally {
            // Error is Logged ONLY if msg != NULL
            if(msg != null) {
                logTime(startTime, ERROR, msg, joinPoint);
            }
        }
    }

    /**
     * Verify the User Role Matches the Claim
     * @param role
     * @param tokenMode
     * @param joinPoint
     */
    private void verifyTheUserRole(String role, String tokenMode, ProceedingJoinPoint joinPoint) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();

        String annotationRole = null;
        log.info("Step 3: Role Check..... FOR Token Mode = {} ", tokenMode);
        try {
            if (tokenMode.equalsIgnoreCase(MULTI_TOKEN_MODE)) {
                AuthorizationRequired annotation =  signature.getMethod().getAnnotation(AuthorizationRequired.class);
                annotationRole = annotation.role();
            } else if(tokenMode.equalsIgnoreCase(SINGLE_TOKEN_MODE)) {
                SingleTokenAuthorizationRequired annotation =  signature.getMethod().getAnnotation(SingleTokenAuthorizationRequired.class);
                annotationRole = annotation.role();
            } else {
                // Default Role in Secure Package Mode
                annotationRole = ROLE_USER;
            }
        } catch (Exception ignored) {
            log.error("Authorization Failed: Role Not Found!");
            throw new AuthorizationException("Role Not Found!", ignored);
        }
        log.info("Step 3: User Role = {},  Claims Role = {} ", annotationRole, role);
        // If the Role in the Token is User and Required is Admin then Reject the request
        if(role.trim().equalsIgnoreCase(UserRole.USER.toString()) && annotationRole != null
                && annotationRole.equals(UserRole.ADMIN.toString())) {
            throw new AuthorizationException("Invalid User Role!");
        }
    }

    /**
     * Validate Tx Token and Set the Claims in the ClaimsManager
     *
     * @param startTime
     * @param user
     * @param joinPoint
     */
    private void validateAndSetClaimsFromTxToken(long startTime, String user,
                                                 String token, ProceedingJoinPoint joinPoint) {
        TokenData tokenData;
        if (token != null && token.startsWith("Bearer ")) {
            String txToken = token.substring(7);
            tokenData = tokenFactory.createTokenData(txToken);
        } else {
            String msg = "TX-Token: Access Denied: Unable to extract TX-Token from Header! "+user;
            logTime(startTime, ERROR, msg, joinPoint);
            throw new JWTTokenExtractionException(msg);
        }
        String msg = null;
        try {
            Claims claims = null;
            if (JsonWebTokenValidator.validateToken(user, tokenData)) {
                claims = JsonWebTokenValidator.getAllClaims(tokenData);
                String tokenType = getTokenTypeFromClaims( user,  claims);
                if (!tokenType.equals(TX_USERS)) {
                    msg = "Invalid TX Token Type ("+tokenType+") ! " + user;
                    throw new AuthorizationException(msg);
                }
                claimsManager.setClaims(claims);
                claimsManager.isClaimsInitialized();
                logTime(startTime, "SUCCESS", "TX-Token: User TX Authorized for the request",  joinPoint);
            }  else {
                msg = "TX-Token: Unauthorized Access: Token Validation Failed!";
                throw new AuthorizationException(msg);
            }
        } catch(AuthorizationException e) {
            throw e;
        } catch(Exception e) {
            msg = "TX-Token: Unauthorized Access: Error: "+e.getMessage();
            throw new AuthorizationException(msg, e);
        } finally {
            // Error is Logged ONLY if msg != NULL
            if(msg != null) {
                logTime(startTime, ERROR, msg, joinPoint);
            }
        }
    }

    /**
     * Validates Token  Type
     * @param user
     * @param claims
     * @return
     */
    private String getTokenTypeFromClaims(String user, Claims claims) {
        String tokenType;
        String msg;
        try {
            tokenType = (String) claims.get("type");
        } catch (Exception e) {
            msg = "Unable to get Token Type from Claims for user: "+user;
            throw new AuthorizationException(msg, e);
        }
        if (tokenType == null) {
            msg = "Invalid Token Type from Claims! for user: " + user;
            throw new AuthorizationException(msg);
        }
        return tokenType;
    }

    /**
     * Log Time
     * @param startTime
     * @param status
     * @param joinPoint
     */
    private void logTime(long startTime, String status, String msg, ProceedingJoinPoint joinPoint) {
        long timeTaken=System.currentTimeMillis() - startTime;
        log.info("2|JA|TIME={} ms|STATUS={}|CLASS={}|Msg={}", timeTaken, status,joinPoint, msg);
    }
 }