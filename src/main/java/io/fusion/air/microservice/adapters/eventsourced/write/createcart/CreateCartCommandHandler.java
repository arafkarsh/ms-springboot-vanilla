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
package io.fusion.air.microservice.adapters.eventsourced.write.createcart;

import org.axonframework.commandhandling.annotation.CommandHandler;
import org.axonframework.eventhandling.gateway.EventAppender;
import org.axonframework.eventsourcing.annotation.reflection.EntityCreator;
import org.axonframework.eventsourcing.EventSourcingHandler;
import org.axonframework.eventsourcing.annotation.EventSourcedEntity;
import org.axonframework.modelling.annotation.InjectEntity;
// Custom
import io.fusion.air.microservice.domain.commands.CreateCartCommand;
import io.fusion.air.microservice.domain.events.CartEvents;
import org.springframework.stereotype.Component;

/**
 * ms-springboot-vanilla / CreateCartCommandHandler
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-14T10:56 PM
 */
@Component
public class CreateCartCommandHandler {
    // The @EventSourcedEntity annotation indicates that this class' state is derived from the
    // events published with the given tag key (cartId in this case). We’ve already annotated
    // cartId property in the CourseCreated event class with @EventTag, so the event will be
    // applied while loading the entity if the courseId value matches.
    // Pay attention that State per feature/slice approach gives us a high level of encapsulation,
    // because we can keep it package-private. The cohesion is also higher, because you don’t care
    // about the unrelated topics for the current process. It reduces the cognitive load on a
    // developer—you only need to comprehend the state needed for that particular slice.
    @EventSourcedEntity(tagKey = "cartId")
    static class State {
        boolean created;

        // The @EntityCreator annotation indicates to Axon Framework that this method should
        // be called when the entity is created. It’s the place when you can set up the initial state.
        @EntityCreator
        private State() {
            this.created = false;
        }
        // The @EventSourcingHandler annotation indicates to Axon Framework that this method
        // should be called while rehydrating the state of the entity. Axon Framework will use the
        // type of the annotated method argument to link this method to the specific type of event.
        // Furthermore, the event type is used to query the Event Store just for those types.
        @EventSourcingHandler
        void evolve(CartEvents.CartCreatedEvent e) {
            this.created = true;
        }
    }

    // The @CommandHandler annotation indicates to Axon Framework that this method should be
    // called when a command of the given type is dispatched. Axon Framework will use the type
    // of the annotated method argument to link this method to the specific type of command.
    // Furthermore, the command type is used to route the command to the correct instance of the
    // entity. The entity instance is loaded from the Event Store using the identifier of the
    // command (cartId in this case).
    @CommandHandler
    void handle(CreateCartCommand cmd,
                @InjectEntity(idProperty = "cartId") State state,
                EventAppender events) {
        // The @InjectEntity annotation indicates to Axon Framework to inject the entity with the
        // given identifier property which needs to be present in the processed command. In this
        // case, we want to inject the State entity with the cartId property.
        if (state.created) {
            return; // idempotent
        }
        events.append(new CartEvents.CartCreatedEvent(cmd.cartId()));
    }
}
