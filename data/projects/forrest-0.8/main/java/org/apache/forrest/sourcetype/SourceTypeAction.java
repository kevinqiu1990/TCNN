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

import org.cyberneko.pull.XMLPullParser;
import org.cyberneko.pull.XMLEvent;
import org.cyberneko.pull.event.*;
import org.cyberneko.pull.parsers.Xerces2;
import org.apache.xerces.xni.parser.XMLInputSource;
import org.apache.avalon.framework.configuration.*;
import org.apache.avalon.framework.thread.ThreadSafe;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.cocoon.acting.Action;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.environment.Redirector;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceNotFoundException;

import java.io.InputStream;
import java.util.*;

/**
 * An action that assigns a "sourcetype" to a source. See the external documentation for
 * more information.
 */
public class SourceTypeAction extends AbstractLogEnabled implements Configurable, ThreadSafe, Action
{
    protected List sourceTypes = new ArrayList();
    protected static final String XSI_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance";

    public void configure(Configuration configuration) throws ConfigurationException
    {
        Configuration[] sourceTypeConfs = configuration.getChildren("sourcetype");
        for (int i = 0; i < sourceTypeConfs.length; i++)
        {
            SourceType sourceType = new SourceType();
            sourceType.configure(sourceTypeConfs[i]);
            sourceTypes.add(sourceType);
        }
    }

    public Map act(Redirector redirector, SourceResolver sourceResolver, Map objectModel, String src, Parameters parameters)
            throws Exception
    {
        if (src == null || src.equals(""))
            throw new Exception("SourceTypeAction: src attribute should be defined and non-empty.");
        Source source = sourceResolver.resolveURI(src);
        XMLPullParser parser = new Xerces2();
        if (source.exists()) {
            InputStream is = source.getInputStream();
            parser.setInputSource(new XMLInputSource(null, src, null, is, null));
        } else {
          getLogger().warn("Source '"+source+"' not found");
          return null;
        }

        // load nothing external
        parser.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
        parser.setFeature("http://xml.org/sax/features/external-general-entities", false);
        parser.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

        // note: namespace-aware parsing is by default true

        SourceInfo sourceInfo = new SourceInfo();
        // pull-parse the document until we reach the document element and put the collected information
        // into the sourceInfo object
        try
        {
            XMLEvent event;
            while ((event = parser.nextEvent()) != null)
            {
                if (event.type == XMLEvent.DOCTYPE_DECL)
                {
                    DoctypeDeclEvent doctypeDeclEvent = (DoctypeDeclEvent)event;
                    sourceInfo.setPublicId(doctypeDeclEvent.pubid);
                }
                else if (event.type == XMLEvent.PROCESSING_INSTRUCTION)
                {
                    ProcessingInstructionEvent piEvent = (ProcessingInstructionEvent)event;
                    sourceInfo.addProcessingInstruction(piEvent.target, piEvent.data != null ? piEvent.data.toString() : null);
                }
                else if (event.type == XMLEvent.ELEMENT)
                {
                    ElementEvent elementEvent = (ElementEvent)event;
                    sourceInfo.setDocumentElementLocalName(elementEvent.element.localpart);
                    sourceInfo.setDocumentElementNamespace(elementEvent.element.uri);

                    sourceInfo.setXsiSchemaLocation(elementEvent.attributes.getValue(XSI_NAMESPACE, "schemaLocation"));
                    sourceInfo.setXsiNoNamespaceSchemaLocation(elementEvent.attributes.getValue(XSI_NAMESPACE, "noNamespaceSchemaLocation"));

                    // stop parsing after the root element
                    break;
                }
            }
        }
        finally
        {
            // this will also close the inputstream
            parser.cleanup();
        }

        // Run over the SourceTypes until one is found that matches the information collected in sourceInfo
        Iterator sourceTypeIt = sourceTypes.iterator();
        while (sourceTypeIt.hasNext())
        {
            SourceType sourceType = (SourceType)sourceTypeIt.next();
            if (sourceType.matches(sourceInfo))
            {
                HashMap returnMap = new HashMap();
                returnMap.put("sourcetype", sourceType.getName());
                if (getLogger().isDebugEnabled())
                    getLogger().debug("SourceTypeAction: found sourcetype " + sourceType.getName() + " for source " + src);
                return returnMap;
            }
        }
        if (getLogger().isDebugEnabled())
            getLogger().debug("SourceTypeAction: found no sourcetype for source " + src);
        return null;
    }
}

