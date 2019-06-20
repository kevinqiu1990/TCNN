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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolver;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolverFactory;
import org.apache.cocoon.sitemap.PatternException;

/**
 * Base class for LocationMap nodes. Defines the contract between the
 * LocationMap and its nodes.
 */
public abstract class AbstractNode extends AbstractLogEnabled {
    
    
    protected final ServiceManager m_manager;
    
    // optional parameters defined by the node's configuration
    private Map m_parameters;
    
    
    public AbstractNode(final ServiceManager manager) {
        m_manager = manager;
    }
    
    public void build(final Configuration configuration) throws ConfigurationException {
        m_parameters = getParameters(configuration);
    }
    
    /**
     * Create a Map of resolvable parameters.
     * 
     * @param configuration  the configuration to build parameters from.
     * @return  a Map of parameters wrapped in VariableResolver objects,
     * <code>null</code> if the configuration contained no parameters.
     * @throws ConfigurationException
     */
    private final Map getParameters(final Configuration configuration) 
        throws ConfigurationException {
        
        final Configuration[] children = configuration.getChildren("parameter");
        if (children.length == 0) {
            return null;
        }
        final Map parameters = new HashMap();
        for (int i = 0; i < children.length; i++) {
            final String name = children[i].getAttribute("name");
            final String value = children[i].getAttribute("value");
            try {
                parameters.put(
                    VariableResolverFactory.getResolver(name, m_manager),
                    VariableResolverFactory.getResolver(value, m_manager));
            } catch(PatternException pe) {
                String msg = "Invalid pattern '" + value + "' at " 
                    + children[i].getLocation();
                throw new ConfigurationException(msg, pe);
            }
        }

        return parameters;
    }
    
    /**
     * Resolve the parameters. Also passes the LocationMap special
     * variables into the Parameters object.
     * 
     * @param context  InvokeContext used during resolution.
     * @param om  object model used during resolution.
     * @return  the resolved parameters or null if this node contains no parameters.
     * @throws PatternException
     */
    protected final Parameters resolveParameters(
        final InvokeContext context, 
        final Map om) throws PatternException {
        
        Parameters parameters = null;
        if (m_parameters != null) {
            parameters = VariableResolver.buildParameters(m_parameters,context,om);
        }
        else {
            parameters = new Parameters();
        }
        // also pass the anchor map as parameters directly into the components
        Map anchorMap = context.getMapByAnchor(LocationMap.ANCHOR_NAME);
        Iterator entries = anchorMap.entrySet().iterator();
        while (entries.hasNext()) {
            Map.Entry entry = (Map.Entry) entries.next();
            parameters.setParameter(
                "#"+LocationMap.ANCHOR_NAME+":"+entry.getKey(),
                entry.getValue().toString());
        }
        return parameters;
    }
    
    public abstract String locate(Map objectModel, InvokeContext context) throws Exception;
        
}
