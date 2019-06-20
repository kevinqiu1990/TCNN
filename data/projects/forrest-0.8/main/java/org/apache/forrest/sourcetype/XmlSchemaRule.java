/*
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
package org.apache.forrest.sourcetype;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;

/**
 * A Rule which checks the value of the xsi:schemaLocation and xsi:noNamespaceSchemaLocation
 * attributes.
 */
public class XmlSchemaRule implements SourceTypeRule
{
    protected String schemaLocation;
    protected String noNamespaceSchemaLocation;

    public void configure(Configuration configuration) throws ConfigurationException
    {
        schemaLocation = configuration.getAttribute("schema-location", null);
        noNamespaceSchemaLocation = configuration.getAttribute("no-namespace-schema-location", null);
        if (schemaLocation == null && noNamespaceSchemaLocation == null)
            throw new ConfigurationException("Missing schema-location and/or no-namespace-schema-location attribute on w3c-xml-schema element at " + configuration.getLocation());
    }

    public boolean matches(SourceInfo sourceInfo)
    {
        if (schemaLocation != null && noNamespaceSchemaLocation != null
                && schemaLocation.equals(sourceInfo.getXsiSchemaLocation())
                && noNamespaceSchemaLocation.equals(sourceInfo.getXsiNoNamespaceSchemaLocation()))
            return true;
        else if (schemaLocation != null && noNamespaceSchemaLocation == null && schemaLocation.equals(sourceInfo.getXsiSchemaLocation()))
            return true;
        else if (schemaLocation == null && noNamespaceSchemaLocation != null && noNamespaceSchemaLocation.equals(sourceInfo.getXsiNoNamespaceSchemaLocation()))
            return true;
        else
            return false;
    }

}
