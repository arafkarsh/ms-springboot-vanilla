/**
 * Copyright (c) 2025 Araf Karsh Hamid
 * <p>
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * <p>
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * <p>
 * This program and the accompanying materials are dual-licensed under
 * either the terms of the Eclipse Public License v1.0 as published by
 * the Eclipse Foundation
 * <p>
 * or (per the licensee's choosing)
 * <p>
 * under the terms of the Apache 2 License version 2.0
 * as published by the Apache Software Foundation.
 */
package io.fusion.air.microservice.adapters.eventsourced.controllers;
// Custom
import io.fusion.air.microservice.adapters.logging.MetricsCounter;
import io.fusion.air.microservice.adapters.logging.MetricsPath;
import io.fusion.air.microservice.domain.exceptions.BusinessServiceException;
import io.fusion.air.microservice.domain.models.cartes.AddItemRequest;
import io.fusion.air.microservice.domain.commands.*;
// Swagger
import io.fusion.air.microservice.server.controllers.AbstractController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
// Axon Framework
import org.axonframework.commandhandling.gateway.CommandGateway;
// Spring
import org.slf4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.*;

import static java.lang.invoke.MethodHandles.lookup;
import static org.slf4j.LoggerFactory.getLogger;


/**
 * ms-springboot-vanilla / CartCommandController
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-11T4:20 PM
 */
@Validated // This enables validation for method parameters
@RestController
@RequestMapping("${service.api.path}/cart/es")
@MetricsPath(name = "fusion.air.cart.es")
@Tag(name = "Cart ES API", description = "Event Sourcing Operations for Create Cart, Add Item to Cart, Update item, Delete item...")
public class CartCommandController extends AbstractController {

    // Set Logger -> Lookup will automatically determine the class name.
    private static final Logger log = getLogger(lookup().lookupClass());

    private String serviceName;

    private final CommandGateway commandGateway;

    /**
     * Constructor based Dependency Injection
     * @param commandGateway
     */
    public CartCommandController(CommandGateway commandGateway) {
        this.commandGateway = commandGateway;
        serviceName = super.name();
    }

    /** 1) Add item to cart */
    @Operation(summary = "Add Item to The Carts")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Item added to cart!",
                    content = {@Content(mediaType = "application/json")}),
            @ApiResponse(responseCode = "400",
                    description = "Invalid Cart Item Request!",
                    content = @Content)
    })
    @PostMapping("/{cartId}/items")
    @MetricsCounter(endpoint = "/all", tags = {"layer", "ws", "public", "yes"})
    public ResponseEntity<Void> addItem(@PathVariable String cartId, @RequestBody AddItemRequest body) {
        String productId = (body != null) ? body.productId() : "Product ID Not Found";
        log.info("| {} |Command >> Add Product ID ({}) CartItem For the Card ID {} ", serviceName, productId, cartId);
        try {
            commandGateway.sendAndWait(new AddItemToCartCommand(cartId, body.productId(), body.quantity(), body.unitPrice()));
        } catch (Exception e) {
            e.printStackTrace();
            throw new BusinessServiceException(e);
        }
        log.info("| {} |Command >> Add Product ID ({}) CartItem: DONE!", serviceName, productId);
        return ResponseEntity.status(HttpStatus.ACCEPTED).build();
    }
}
