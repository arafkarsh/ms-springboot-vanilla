/**
 * (C) Copyright 2021 Araf Karsh Hamid
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
package io.fusion.air.microservice.server.service.examples;


import io.fusion.air.microservice.server.models.EchoResponseData;
import org.springframework.stereotype.Service;
import org.springframework.web.context.annotation.ApplicationScope;

/**
 * @author: Araf Karsh Hamid
 * @version:
 * @date:
 */
@Service
@ApplicationScope
public class EchoAppService {

    private EchoResponseData echoData;

    public void setEchoData(EchoResponseData data) {
        echoData = data;
    }

    public EchoResponseData getEchoData() {
        return echoData;
    }
}
