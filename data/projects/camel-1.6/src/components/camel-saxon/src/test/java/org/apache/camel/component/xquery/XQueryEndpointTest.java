/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.camel.component.xquery;

import java.util.List;

import org.apache.camel.Exchange;
import org.apache.camel.component.mock.MockEndpoint;
import org.apache.camel.spring.SpringTestSupport;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @version $Revision: 707571 $
 */
public class XQueryEndpointTest extends SpringTestSupport {

    public void testSendMessageAndHaveItTransformed() throws Exception {
        MockEndpoint endpoint = getMockEndpoint("mock:result");
        endpoint.expectedMessageCount(1);

        template.sendBody("direct:start",
            "<mail><subject>Hey</subject><body>Hello world!</body></mail>");

        assertMockEndpointsSatisfied();

        List<Exchange> list = endpoint.getReceivedExchanges();
        Exchange exchange = list.get(0);
        String xml = exchange.getIn().getBody(String.class);
        assertNotNull("The transformed XML should not be null", xml);
        assertEquals("transformed", "<transformed subject=\"Hey\"><mail><subject>Hey</subject>"
            + "<body>Hello world!</body></mail></transformed>", xml);

        TestBean bean = getMandatoryBean(TestBean.class, "testBean");
        assertEquals("bean.subject", "Hey", bean.getSubject());
    }

    protected int getExpectedRouteCount() {
        return 0;
    }

    protected ClassPathXmlApplicationContext createApplicationContext() {
        return new ClassPathXmlApplicationContext("org/apache/camel/component/xquery/camelContext.xml");
    }
}
