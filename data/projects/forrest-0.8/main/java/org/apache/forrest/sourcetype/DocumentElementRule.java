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
 * A Rule which checks the local name and namespace of the document element.
 */
public class DocumentElementRule implements SourceTypeRule
{
    protected String localName;
    protected String namespace;

    public void configure(Configuration configuration) throws ConfigurationException
    {
        localName = configuration.getAttribute("local-name", null);
        namespace = configuration.getAttribute("namespace", null);
        if (localName == null && namespace == null)
            throw new ConfigurationException("Missing local-name and/or namespace attribute on document-element element at " + configuration.getLocation());
    }

    public boolean matches(SourceInfo sourceInfo)
    {
        if (localName != null && namespace != null
                && localName.equals(sourceInfo.getDocumentElementLocalName())
                && namespace.equals(sourceInfo.getDocumentElementNamespace()))
            return true;
        else if (localName != null && localName.equals(sourceInfo.getDocumentElementLocalName()))
            return true;
        else if (namespace != null && namespace.equals(sourceInfo.getDocumentElementNamespace()))
            return true;
        else
            return false;
    }

}
