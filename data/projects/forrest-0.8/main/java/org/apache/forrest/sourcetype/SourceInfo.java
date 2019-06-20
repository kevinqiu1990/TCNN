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

import java.util.HashMap;

/**
 * Contains information about an XML file. More precisely, the publicId, the processing instructions
 * occuring before the document element, the local name and namespace of the document element, and
 * the value of the xsi:schemaLocation and xsi:noNamespaceSchemaLocation attributes. All of these
 * attributes can be null.
 *
 */
public class SourceInfo
{
    protected String publicId;
    protected String documentElementLocalName;
    protected String documentElementNamespace;
    protected String xsiSchemaLocation;
    protected String xsiNoNamespaceSchemaLocation;
    protected HashMap processingInstructions = new HashMap();

    public String getPublicId()
    {
        return publicId;
    }

    public void setPublicId(String publicId)
    {
        this.publicId = publicId;
    }

    public String getDocumentElementLocalName()
    {
        return documentElementLocalName;
    }

    public void setDocumentElementLocalName(String documentElementLocalName)
    {
        this.documentElementLocalName = documentElementLocalName;
    }

    public String getDocumentElementNamespace()
    {
        return documentElementNamespace;
    }

    public void setDocumentElementNamespace(String documentElementNamespace)
    {
        this.documentElementNamespace = documentElementNamespace;
    }

    public String getXsiSchemaLocation()
    {
        return xsiSchemaLocation;
    }

    public void setXsiSchemaLocation(String xsiSchemaLocation)
    {
        this.xsiSchemaLocation = xsiSchemaLocation;
    }

    public String getXsiNoNamespaceSchemaLocation()
    {
        return xsiNoNamespaceSchemaLocation;
    }

    public void setXsiNoNamespaceSchemaLocation(String xsiNoNamespaceSchemaLocation)
    {
        this.xsiNoNamespaceSchemaLocation = xsiNoNamespaceSchemaLocation;
    }

    public void addProcessingInstruction(String target, String data)
    {
        processingInstructions.put(target, data);
    }

    public boolean hasProcessingInstruction(String target)
    {
        return processingInstructions.containsKey(target);
    }

    public String getProcessingInstructionData(String target)
    {
        return (String)processingInstructions.get(target);
    }
}
