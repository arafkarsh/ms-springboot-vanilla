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
package io.fusion.air.microservice.adapters.eventsourced.projections;
// Axon Framework
import org.axonframework.eventhandling.annotation.EventHandler;
import org.axonframework.config.ProcessingGroup;
// Spring Framework
import org.springframework.stereotype.Component;
// Custom
import io.fusion.air.microservice.adapters.eventsourced.repository.CartItemViewRepo;
import io.fusion.air.microservice.adapters.eventsourced.repository.CartViewRepo;
import io.fusion.air.microservice.domain.entities.cartes.CartItemView;
import io.fusion.air.microservice.domain.entities.cartes.CartView;
import io.fusion.air.microservice.domain.events.CartEvents.*;

import java.math.BigDecimal;

/**
 * ms-springboot-vanilla / CartProjection
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-11T12:56 PM
 */
@Component
@ProcessingGroup("cart-projection")
public class CartProjection {

    private final CartViewRepo cartRepo;
    private final CartItemViewRepo itemRepo;

    /**
     * Constructor based Dependency Injection
     * @param cartRepo
     * @param itemRepo
     */
    public CartProjection(CartViewRepo cartRepo, CartItemViewRepo itemRepo) {
        this.cartRepo = cartRepo;
        this.itemRepo = itemRepo;
    }

    @EventHandler
    public void on(CartCreatedEvent e) {
        cartRepo.save(new CartView(e.cartId()));
    }

    @EventHandler
    public void on(ItemAddedToCartEvent e) {
        var cv = cartRepo.findById(e.cartId()).orElseGet(() -> cartRepo.save(new CartView(e.cartId())));
        var item = itemRepo.findByCartIdAndProductId(e.cartId(), e.productId())
                .orElse(new CartItemView(e.cartId(), e.productId()));
        item.setQuantity(item.getQuantity() + e.quantity());
        itemRepo.save(item);
        cv.setTotal(cv.getTotal().add(new BigDecimal(e.quantity())));
        cartRepo.save(cv);
    }

    @EventHandler
    public void on(ItemDeletedFromCartEvent e) {
        var cv = cartRepo.getReferenceById(e.cartId());
        var item = itemRepo.findByCartIdAndProductId(e.cartId(), e.productId()).orElseThrow();
        if (item != null) {
            itemRepo.delete(item);
        }
        cartRepo.save(cv);
    }

    @EventHandler
    public void on(CartCheckedOutEvent e) {
        var cv = cartRepo.getReferenceById(e.cartId());
        cv.setCheckedOut(true);
        cartRepo.save(cv);
    }
}
