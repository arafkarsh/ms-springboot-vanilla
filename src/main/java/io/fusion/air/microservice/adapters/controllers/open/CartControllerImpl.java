/**
 * (C) Copyright 2023 Araf Karsh Hamid
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
package io.fusion.air.microservice.adapters.controllers.open;
// Custom
import io.fusion.air.microservice.adapters.logging.MetricsCounter;
import io.fusion.air.microservice.adapters.logging.MetricsPath;
import io.fusion.air.microservice.adapters.security.jwt.AuthorizationRequired;
import io.fusion.air.microservice.domain.entities.order.CartEntity;
import io.fusion.air.microservice.domain.exceptions.AbstractServiceException;
import io.fusion.air.microservice.domain.models.core.StandardResponse;
import io.fusion.air.microservice.domain.models.order.CartItem;
import io.fusion.air.microservice.domain.ports.services.CartService;
import io.fusion.air.microservice.server.controllers.AbstractController;
// Swagger - Open API
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
// Spring
import org.slf4j.Logger;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
// Java
import jakarta.validation.Valid;
import org.springframework.web.util.HtmlUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import static java.lang.invoke.MethodHandles.lookup;
import static org.slf4j.LoggerFactory.getLogger;

/**
 * CartItem Controller for the CartItem Service
 * This is to demonstrate certain concepts in Exception Handling ONLY.
 * Order, Product, CartItem all must be part of 3 different Microservices.
 *
 * @author arafkarsh
 * @version 1.0
 * 
 */
@Validated // This enables validation for method parameters
@RestController
// "/ms-vanilla/api/v1"
@RequestMapping("${service.api.path}/cart")
@MetricsPath(name = "fusion.air.cart")
@Tag(name = "Cart-CRUD API", description = "CRUD Operations for Create Cart, CartItem, Add to Cart, Update, Delete item, & Fetch Cart..")
public class CartControllerImpl extends AbstractController {

	// Set Logger -> Lookup will automatically determine the class name.
	private static final Logger log = getLogger(lookup().lookupClass());

	private String serviceName;

	// Autowired using the Constructor
	private CartService cartService;

	private static final String CART_RETRIEVED = "CartItem Retrieved. Items =  ";

	/**
	 * Autowired using the Constructor
	 * @param cartSvc
	 */
	public CartControllerImpl(CartService cartSvc) {
		cartService = cartSvc;
		serviceName = super.name();
	}

	/**
	 * GET Method Call to ALL CARTS
	 *
	 * @return
	 */
	@Operation(summary = "Get The Carts")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "CartItem Retrieved!",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "400",
					description = "Invalid CartItem ID",
					content = @Content)
	})
	@GetMapping("/all")
	@MetricsCounter(endpoint = "/all", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> fetchCarts() throws AbstractServiceException {
		log.debug("| {} |Request to Get CartItem For the Customers ", serviceName);
		List<CartEntity> cart = cartService.findAll();
		StandardResponse stdResponse = createSuccessResponse(CART_RETRIEVED+cart.size());
		stdResponse.setPayload(cart);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * GET Method Call to Get CartItem for the Customer
	 * 
	 * @return
	 */
    @Operation(summary = "Get The CartItem for the Customer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
            description = "CartItem Retrieved!",
            content = {@Content(mediaType = "application/json")}),
            @ApiResponse(responseCode = "400",
            description = "Invalid CartItem ID",
            content = @Content)
    })
	@GetMapping("/customer/{customerId}")
	@MetricsCounter(endpoint = "/customer", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> fetchCart(@PathVariable("customerId") String customerId) throws AbstractServiceException {

		String safeCustomerId = HtmlUtils.htmlEscape(customerId);
		log.debug("| {} |Request to Get CartItem For the Customer {} ", serviceName, safeCustomerId);
		List<CartEntity> cart = cartService.findByCustomerId(safeCustomerId);
		StandardResponse stdResponse = createSuccessResponse(CART_RETRIEVED+cart.size());
		stdResponse.setPayload(cart);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * GET Method Call to Get CartItem for the Customer for the Price Greater Than
	 *
	 * @param customerId
	 * @return
	 * @throws Exception
	 */
	@Operation(summary = "Get The CartItem For Items Price Greater Than")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "CartItem Retrieved!",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "400",
					description = "Invalid CartItem ID",
					content = @Content)
	})
	@GetMapping("/customer/{customerId}/price/{price}")
	@MetricsCounter(endpoint = "/customer/price", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> fetchCartForItems(@PathVariable("customerId") String customerId,
															  @PathVariable("price") BigDecimal price) throws AbstractServiceException {
		String safeCustomerId = HtmlUtils.htmlEscape(customerId);
		log.debug("| {} |Request to Get CartItem For the Customer {} ",serviceName ,safeCustomerId);
		List<CartEntity> cart = cartService.fetchProductsByPriceGreaterThan(safeCustomerId, price);
		StandardResponse stdResponse = createSuccessResponse(CART_RETRIEVED+cart.size());
		stdResponse.setPayload(cart);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * Add CartItem Item to CartItem
	 */
	@Operation(summary = "Add Item to CartItem")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "Add the CartItem Item",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "404",
					description = "Unable to Add the CartItem Item",
					content = @Content)
	})
	@PostMapping("/add")
	@MetricsCounter(endpoint = "/add", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> addToCart(@Valid @RequestBody CartItem cartItem) {
		String safeProductName = HtmlUtils.htmlEscape(cartItem.productName());
		log.debug("| {} |Request to Add CartItem Item... {} ", serviceName, safeProductName);
		CartEntity cartItemEntity = cartService.save(cartItem);
		StandardResponse stdResponse = createSuccessResponse("CartItem Item Added!");
		stdResponse.setPayload(cartItemEntity);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * De-Activate the CartItem Item
	 */
	@Operation(summary = "De-Activate CartItem Item")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "CartItem Item De-Activated",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "400",
					description = "Unable to De-Activate the CartItem item",
					content = @Content)
	})
	@PutMapping("/deactivate/customer/{customerId}/cartItem/{cartId}")
	@MetricsCounter(endpoint = "/deactivate/customer/cartItem", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> deActivateCartItem(@PathVariable("customerId") String customerId,
									@PathVariable("cartId") UUID cartId) {
		String safeCustomerId = HtmlUtils.htmlEscape(customerId);
		log.debug("| {} |Request to De-Activate the CartItem item...{}  ", serviceName, cartId);
		CartEntity product = cartService.deActivateCartItem(safeCustomerId, cartId);
		StandardResponse stdResponse = createSuccessResponse("CartItem Item De-Activated");
		stdResponse.setPayload(product);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * Activate the CartItem Item
	 */
	@Operation(summary = "Activate CartItem Item")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "CartItem Item Activated",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "400",
					description = "Unable to Activate the CartItem item",
					content = @Content)
	})
	@PutMapping("/activate/customer/{customerId}/cartItem/{cartId}")
	@MetricsCounter(endpoint = "/activate/customer/cartItem", tags = {"layer", "ws", "public", "yes"})
	public ResponseEntity<StandardResponse> activateCartItem(@PathVariable("customerId") String customerId,
															   @PathVariable("cartId") UUID cartId) {
		String safeCustomerId = HtmlUtils.htmlEscape(customerId);
		log.debug("| {} |Request to Activate the CartItem item...{}  ",serviceName, cartId);
		CartEntity product = cartService.activateCartItem(safeCustomerId, cartId);
		StandardResponse stdResponse = createSuccessResponse("CartItem Item Activated");
		stdResponse.setPayload(product);
		return ResponseEntity.ok(stdResponse);
	}

	/**
	 * Delete the CartItem Item
	 */
	@AuthorizationRequired(role = "User")
	@Operation(summary = "Delete CartItem Item", security = { @SecurityRequirement(name = "bearer-key") })
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200",
					description = "CartItem Item Deleted",
					content = {@Content(mediaType = "application/json")}),
			@ApiResponse(responseCode = "400",
					description = "Unable to Delete the CartItem item",
					content = @Content)
	})
	@DeleteMapping("/delete/customer/{customerId}/cartItem/{cartId}")
	@MetricsCounter(endpoint = "/delete/customer/cartItem", tags = {"layer", "ws", "public", "no"})
	public ResponseEntity<StandardResponse> deleteCartItem(@PathVariable("customerId") String customerId,
															 @PathVariable("cartId") UUID cartId) {
		String safeCustomerId = HtmlUtils.htmlEscape(customerId);
		log.debug("| {} |Request to Delete the CartItem item...  {} ",serviceName, cartId);
		cartService.deleteCartItem(safeCustomerId, cartId);
		StandardResponse stdResponse = createSuccessResponse("CartItem Item Deleted");
		return ResponseEntity.ok(stdResponse);
	}

 }