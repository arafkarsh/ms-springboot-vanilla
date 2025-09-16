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
package io.fusion.air.microservice.adapters.eventsourced.write.additem;

import org.axonframework.commandhandling.annotation.CommandHandler;
import org.axonframework.eventhandling.gateway.EventAppender;
import org.axonframework.eventsourcing.EventSourcingHandler;
import org.axonframework.eventsourcing.annotation.EventSourcedEntity;
import org.axonframework.eventsourcing.annotation.reflection.EntityCreator;
import org.axonframework.modelling.annotation.InjectEntity;
// Custom
import io.fusion.air.microservice.domain.commands.AddItemToCartCommand;
import io.fusion.air.microservice.domain.events.CartEvents;
import org.springframework.stereotype.Component;
// Java
import java.util.HashSet;
import java.util.Set;

/**
 * ms-springboot-vanilla / AddItemToCartCommandHandler
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-15T1:05 PM
 */
@Component
public class AddItemToCartCommandHandler {

    @EventSourcedEntity(tagKey = "cartId")
    static class State {
        boolean created;
        boolean checkedOut;
        final Set<String> items = new HashSet<>();

        @EntityCreator
        private State() {}

        @EventSourcingHandler
        private void evolve(CartEvents.CartCreatedEvent e) { created = true; }

        @EventSourcingHandler
        private void evolve(CartEvents.CartCheckedOutEvent e) { checkedOut = true; }

        @EventSourcingHandler
        private void evolve(CartEvents.ItemAddedToCartEvent e) { items.add(e.productId()); }

        @EventSourcingHandler
        private void evolve(CartEvents.ItemDeletedFromCartEvent e) { items.remove(e.productId()); }
    }

    @CommandHandler
    void handle(AddItemToCartCommand cmd,
                @InjectEntity(idProperty = "cartId") State s,
                EventAppender events) {

        if (!s.created) throw new IllegalStateException("cart not created");
        if (s.checkedOut) throw new IllegalStateException("cart already checked out");
        if (cmd.quantity() <= 0) throw new IllegalArgumentException("quantity must be > 0");

        events.append(new CartEvents.ItemAddedToCartEvent(
                cmd.cartId(),
                cmd.productId(),
                cmd.quantity()
                // unitPrice intentionally omitted (not present in event record)
        ));
    }
}
