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
package io.fusion.air.microservice.domain.entities.order;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.fusion.air.microservice.domain.entities.core.AbstractBaseEntityWithUUID;
import io.fusion.air.microservice.domain.models.order.Product;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * @author: Araf Karsh Hamid
 * @version:
 * @date:
 */

@Entity
@Table(name = "products_m")
public class ProductEntity extends AbstractBaseEntityWithUUID {

    @NotBlank(message = "The Product Name is required.")
    @Size(min = 3, max = 32, message = "The length of Product Name must be 3-32 characters.")
    @Column(name = "productName")
    private String productName;

    @NotNull(message = "The Product Details is  required.")
    @Size(min = 5, max = 64, message = "The length of Product Description must be 5-64 characters.")
    @Column(name = "productDetails")
    private String productDetails;

    @NotNull(message = "The Price is required.")
    @Column(name = "price")
    private BigDecimal productPrice;

    @NotBlank(message = "The Product ZipCode is required.")
    @Column(name = "productLocationZipCode")
    @Pattern(regexp = "^\\d{5}$", flags = { Pattern.Flag.CASE_INSENSITIVE, Pattern.Flag.MULTILINE }, message = "ZIP CODE MUST BE 5 DIGITS.")
    private String productLocationZipCode;

    /**
     * Empty Product Entity
     */
    public ProductEntity() {
    }

    /**
     * Create Product from the Product DTO
     * @param product
     */
    public ProductEntity(Product product) {
        this(product.getProductName(), product.getProductDetails(),
                product.getProductPrice(), product.getProductLocationZipCode());
    }

    /**
     * Create Product Entity
     * @param pName
     * @param pDetails
     * @param pPrice
     * @param pZipCode
     */
    public ProductEntity(String pName, String pDetails, BigDecimal pPrice, String pZipCode) {
        this.productName            = pName;
        this.productDetails         = pDetails;
        this.productPrice           = pPrice;
        this.productLocationZipCode = pZipCode;
    }

    /**
     * Get Product ID
     * @return
     */
    @JsonIgnore
    public UUID getProductId() {
        return getUuid();
    }

    /**
     * Returns Product ID as String
     * @return
     */
    @JsonIgnore
    public String getProductIdAsString() {
        return getUuid().toString();
    }

    /**
     * Returns Product Name
     * @return
     */
    public String getProductName() {
        return productName;
    }

    /**
     * Returns Product Details
     * @return
     */
    public String getProductDetails() {
        return productDetails;
    }

    /**
     * Returns Product Price
     * @return
     */
    public BigDecimal getProductPrice() {
        return productPrice;
    }

    /**
     * Returns Product Zip Code
     * @return
     */
    public String getProductLocationZipCode() {
        return productLocationZipCode;
    }

    // Set Methods Provided to demonstrate the Update Part of the CRUD Operations
    // Immutable Objects are always better.
    /**
     * Set the Product Name
     * @param productName
     */
    public void setProductName(String productName) {
        this.productName = productName;
    }

    /**
     * Set the Product Details
     * @param productDetails
     */
    public void setProductDetails(String productDetails) {
        this.productDetails = productDetails;
    }

    /**
     * Set the Product Price
     * @param productPrice
     */
    public void setProductPrice(BigDecimal productPrice) {
        this.productPrice = productPrice;
    }

    /**
     * De-Activate Product
     */
    @JsonIgnore
    public void deActivateProduct() {
        deActivate();
    }

    /**
     * Activate Product
     */
    @JsonIgnore
    public void activateProduct() {
        activate();
    }

    /**
     * Return This Product ID / Name
     * @return
     */
    @Override
    public String toString() {
        return super.toString() + "|" + productName;
    }
}
