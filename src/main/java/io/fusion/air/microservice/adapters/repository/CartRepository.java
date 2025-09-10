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
package io.fusion.air.microservice.adapters.repository;

import io.fusion.air.microservice.domain.entities.order.CartEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Example
 * CartItem Repository Impl
 *
 * @author arafkarsh
 */

@Repository
public interface CartRepository extends JpaRepository<CartEntity, UUID> {

    /**
     * Find By Item ID
     * @param itemId
     * @return
     */
    public Optional<CartEntity> findByuuidAndCustomerId(UUID itemId, String customerId);

    /**
     * Find CartItem by Customer ID
     * @param customerId
     * @return
     */
    public List<CartEntity> findByCustomerId(String customerId);


    /**
     * Search for the Item By Price Greater Than or Equal To
     * @param price
     * @return
     */
    @Query("SELECT cartes FROM CartEntity cartes WHERE cartes.customerId = :customerId AND cartes.price >= :price ")
    public List<CartEntity> fetchProductsByPriceGreaterThan(
            @Param("customerId") String customerId, @Param("price") BigDecimal price);

    /**
     * Returns Active Products Only
     * @return
     */
    @Query("SELECT cartes FROM CartEntity cartes WHERE cartes.customerId = :customerId AND cartes.isActive = true")
    public List<CartEntity> fetchActiveItems(@Param("customerId") String customerId);

    /**
     * Search for the Item By the Item Names Like 'name'
     * @param name
     * @return
     */
    public List<CartEntity> findByCustomerIdAndProductNameContains(String customerId, String name);

}
