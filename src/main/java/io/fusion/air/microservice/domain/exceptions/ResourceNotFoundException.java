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
package io.fusion.air.microservice.domain.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * @author: Araf Karsh Hamid
 * @version:
 * @date:
 */
@ResponseStatus(value = HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends ResourceException {

    /**
     * ResourceNotFound Exception
     * @param msg
     */
    public ResourceNotFoundException(String msg) {
        super(msg);
    }


    /**
     * ResourceNotFound Exception
     * @param msg
     * @param e
     */
    public ResourceNotFoundException(String msg, Throwable e) {
        super(msg, HttpStatus.NOT_FOUND, e);
    }
}
