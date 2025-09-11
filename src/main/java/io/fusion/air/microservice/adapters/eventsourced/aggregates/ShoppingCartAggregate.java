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
package io.fusion.air.microservice.adapters.eventsourced.aggregates;
// Axon
import org.axonframework.commandhandling.annotation.CommandHandler;
import org.axonframework.modelling.command.*;
import org.axonframework.spring.stereotype.Aggregate;
import org.axonframework.eventsourcing.EventSourcingHandler;
import static org.axonframework.modelling.command.AggregateLifecycle.apply;
import org.axonframework.modelling.command.AggregateCreationPolicy;
// Java
import java.util.*;
// Custom
import io.fusion.air.microservice.domain.commands.CartCommands.*;
import io.fusion.air.microservice.domain.events.CartEvents.*;

/**
 * ms-springboot-vanilla / ShoppingCartAggregate
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-11T10:20 AM
 */
@Aggregate(snapshotTriggerDefinition = "cartSnapshotTrigger")
public class ShoppingCartAggregate {

    @AggregateIdentifier
    private String cartId;
    private final Map<String, Integer> items = new HashMap<>();
    private boolean checkedOut;

    // Mandatory no-arg constructor for Axon
    protected ShoppingCartAggregate() {}

    @CommandHandler
    @CreationPolicy(AggregateCreationPolicy.ALWAYS)             // behaves like a constructor handler
    public void handle(CreateCartCommand cmd) {
        if (cmd.cartId() == null || cmd.cartId().isBlank()) {
            throw new IllegalArgumentException("cartId required");
        }
        apply(new CartCreatedEvent(cmd.cartId()));
    }

    @CommandHandler
    public void handle(AddToCartCommand cmd) {
        ensureNotCheckedOut();
        if (cmd.quantity() <= 0) throw new IllegalArgumentException("quantity must be > 0");
        apply(new ItemAddedToCartEvent(cartId, cmd.productId(), cmd.quantity()));
    }

    @CommandHandler
    public void handle(UpdateCartItemCommand cmd) {
        ensureNotCheckedOut();
        int existing = items.getOrDefault(cmd.productId(), 0);
        if (cmd.quantity() <= 0 || cmd.quantity() > existing) throw new IllegalArgumentException("bad quantity");
        apply(new ItemUpdatedInCartEvent(cartId, cmd.productId(), cmd.quantity()));
    }

    @CommandHandler
    public void handle(DeleteCartItemCommand cmd) {
        ensureNotCheckedOut();
        apply(new ItemDeletedFromCartEvent(cartId, cmd.productId()));
    }

    @CommandHandler
    public void handle(CheckoutCommand cmd) {
        ensureNotCheckedOut();
        if (items.isEmpty()) throw new IllegalStateException("cannot checkout an empty cart");
        apply(new CartCheckedOutEvent(cartId, null));
    }

    private void ensureNotCheckedOut() {
        if (checkedOut) throw new IllegalStateException("cart already checked out");
    }

    /* --- Event sourcing handlers mutate in-memory state --- */

    @EventSourcingHandler
    public void on(CartCreatedEvent e) { this.cartId = e.cartId(); }

    @EventSourcingHandler
    public void on(ItemAddedToCartEvent e) { items.merge(e.productId(), e.quantity(), Integer::sum); }

    @EventSourcingHandler
    public void on(ItemDeletedFromCartEvent e) {
        items.remove(e.productId());
    }

    @EventSourcingHandler
    public void on(CartCheckedOutEvent e) { this.checkedOut = true; }
}
