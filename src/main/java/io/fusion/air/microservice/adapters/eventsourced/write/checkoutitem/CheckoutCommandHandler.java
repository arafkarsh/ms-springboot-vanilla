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
package io.fusion.air.microservice.adapters.eventsourced.write.checkoutitem;

// Custom
import io.fusion.air.microservice.domain.commands.CheckoutCommand;
import io.fusion.air.microservice.domain.events.CartEvents;
// Axon Framework
import org.axonframework.commandhandling.annotation.CommandHandler;
import org.axonframework.eventhandling.gateway.EventAppender;
import org.axonframework.eventsourcing.EventSourcingHandler;
import org.axonframework.eventsourcing.annotation.EventSourcedEntity;
import org.axonframework.eventsourcing.annotation.reflection.EntityCreator;
import org.axonframework.modelling.annotation.InjectEntity;
import org.springframework.stereotype.Component;
// Java
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

/**
 * ms-springboot-vanilla / CheckoutCommandHandler
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-15T1:14 PM
 */
@Component
public class CheckoutCommandHandler {

    @EventSourcedEntity(tagKey = "cartId")
    static class State {
        boolean checkedOut;
        final Map<String, Integer> items = new HashMap<>();

        @EntityCreator
        private State() {}

        @EventSourcingHandler
        private void evolve(CartEvents.ItemAddedToCartEvent e) {
            items.merge(e.productId(), e.quantity(), Integer::sum);
        }

        @EventSourcingHandler
        private void evolve(CartEvents.ItemUpdatedInCartEvent e) {
            items.put(e.productId(), e.quantity());
        }

        @EventSourcingHandler
        private void evolve(CartEvents.ItemDeletedFromCartEvent e) {
            items.remove(e.productId());
        }

        @EventSourcingHandler
        private void evolve(CartEvents.CartCheckedOutEvent e) { checkedOut = true; }
    }

    @CommandHandler
    void handle(CheckoutCommand cmd,
                @InjectEntity(idProperty = "cartId") State s,
                EventAppender events) {

        if (s.checkedOut) throw new IllegalStateException("already checked out");
        if (s.items.isEmpty()) throw new IllegalStateException("cannot checkout an empty cart");

        events.append(new CartEvents.CartCheckedOutEvent(
                cmd.cartId(),
                Instant.now()
        ));
    }
}
