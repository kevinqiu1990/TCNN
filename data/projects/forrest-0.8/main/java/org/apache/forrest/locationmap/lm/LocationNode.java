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
package org.apache.forrest.locationmap.lm;

import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolver;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolverFactory;
import org.apache.cocoon.sitemap.PatternException;

/**
 * locationmap leaf statement identifying a location.
 * 
 * <p>
 *  The <code>&lt;location&gt;</code> element has one
 *  required attribute <code>src</code> that contains the
 *  location string.
 * </p>
 */
public class LocationNode extends AbstractNode {

    private final LocatorNode m_ln;

    // the resolvable location source
    private VariableResolver m_src;

    public LocationNode(final LocatorNode ln, final ServiceManager manager) {
        super(manager);
        m_ln = ln;
    }

    public void build(final Configuration configuration) throws ConfigurationException {
        try {
            m_src = VariableResolverFactory.getResolver(
            		configuration.getAttribute("src"), super.m_manager);
        } catch (PatternException e) {
            final String message = "Illegal pattern syntax at for location attribute 'src'" +
            		" at " + configuration.getLocation();
            throw new ConfigurationException(message,e);
        }
    }
    
    /**
     * Resolve the location string against the InvokeContext.
     */
    public String locate(Map om, InvokeContext context) throws Exception {
        return m_src.resolve(context, om);
    }

}
