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
package org.apache.forrest.locationmap.source.impl;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.Map;

import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.context.Context;
import org.apache.avalon.framework.context.ContextException;
import org.apache.avalon.framework.context.Contextualizable;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.avalon.framework.service.Serviceable;
import org.apache.avalon.framework.thread.ThreadSafe;
import org.apache.cocoon.components.ContextHelper;
import org.apache.cocoon.components.modules.input.InputModule;
import org.apache.excalibur.source.SourceResolver;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceException;
import org.apache.excalibur.source.SourceFactory;

public class LocationmapSourceFactory extends AbstractLogEnabled implements
        Serviceable, SourceFactory, ThreadSafe, Contextualizable {

    protected ServiceManager m_manager;
    private Context context;
    public static final String LM_PREFIX = "lm";
    public static final String LM_SOURCE_SCHEME =LM_PREFIX+ ":";

    public Source getSource(String location, Map parameters)
            throws IOException, MalformedURLException {
        Map objectModel = ContextHelper.getObjectModel( this.context );
        if (this.getLogger().isDebugEnabled()) {
            this.getLogger().debug("Processing " + location);
        }

        int protocolEnd = location.indexOf("://");
        if (protocolEnd == -1) {
            throw new MalformedURLException("URI does not contain '://' : "
                    + location);
        }
        String documentName = location.substring(protocolEnd + 3, location
                .length());
        String lmLocation = "";
        Source lmSource = null;
        SourceResolver resolver = null;
        ServiceSelector selector = null;
        InputModule inputModule = null;
        try {
            selector = (ServiceSelector) m_manager.lookup(InputModule.ROLE
                    + "Selector");
            inputModule = (InputModule) selector.select(LM_PREFIX);
            resolver = (SourceResolver) m_manager.lookup(SourceResolver.ROLE);
            lmLocation = (String) inputModule.getAttribute(documentName, null,
                    objectModel);
            if (lmLocation==null)
                throw new SourceException("Could not resolve locationmap location.");
            lmSource = resolver.resolveURI(lmLocation);
        } catch (ServiceException se) {
            throw new SourceException("InputModule is not available.", se);
        } catch (ConfigurationException e) {
            throw new SourceException("SourceResolver is not available.", e);
        } finally {
            if (inputModule != null)
                selector.release(inputModule);
            m_manager.release(resolver);
        }
        return lmSource;
    }
    /**
     * Contextualizable, get the object model
     */
    public void contextualize( Context context ) throws ContextException {
        this.context = context;
    }
    public void release(Source source) {
        // not necessary here
    }

    public void service(ServiceManager manager) throws ServiceException {
        this.m_manager = manager;
    }

}
