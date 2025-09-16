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
package io.fusion.air.microservice.server.setup;
// DB
import javax.sql.DataSource;
// Axon
import org.axonframework.common.jdbc.ConnectionProvider;
// import org.axonframework.common.jdbc.SpringDataSourceConnectionProvider;

import org.axonframework.common.transaction.TransactionManager;
import org.axonframework.spring.messaging.unitofwork.SpringTransactionManager;

import org.axonframework.eventsourcing.eventstore.EventStore;
// import org.axonframework.eventsourcing.eventstore.EmbeddedEventStore;
// import org.axonframework.eventsourcing.eventstore.jdbc.JdbcEventStorageEngine;

import org.axonframework.eventhandling.tokenstore.TokenStore;
import org.axonframework.eventhandling.tokenstore.jdbc.JdbcTokenStore;


// Spring
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * ms-springboot-vanilla / AxonJdbcConfig
 *
 * @author: Araf Karsh Hamid
 * @version: 0.1
 * @date: 2025-09-09T9:09 PM
 */
// @Configuration
public class AxonJdbcLegacySetup {

    // @Bean
    public TransactionManager axonTxManager(PlatformTransactionManager ptm) {
        return new SpringTransactionManager(ptm);
    }

    /**
    @Bean
    public ConnectionProvider connectionProvider(DataSource ds) {
        return new SpringDataSourceConnectionProvider(ds);
    }

    @Bean
    public JdbcEventStorageEngine storageEngine(ConnectionProvider cp,
                                                TransactionManager tm) {
        return JdbcEventStorageEngine.builder()
                .connectionProvider(cp)
                .transactionManager(tm)
                .build();
    }

    @Bean
    public EventStore eventStore(JdbcEventStorageEngine engine) {
        return EmbeddedEventStore.builder()
                .storageEngine(engine)
                .build();
    }

    @Bean
    public TokenStore tokenStore(ConnectionProvider cp, TransactionManager tm) {
        return JdbcTokenStore.builder()
                .connectionProvider(cp)
                // .transactionManager(tm)
                .build();
    }
    */
}
