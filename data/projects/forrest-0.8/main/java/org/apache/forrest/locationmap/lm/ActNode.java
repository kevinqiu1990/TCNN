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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.ServiceSelector;
import org.apache.cocoon.acting.Action;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolver;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolverFactory;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.sitemap.PatternException;
import org.apache.cocoon.environment.SourceResolver;


/**
 * Locationmap select statement.
 */
public final class ActNode extends AbstractNode {
    
    // the containing LocatorNode
    private final LocatorNode m_ln;
    
    // the action that does the work
    private Action m_action;
    
    // the type of action for this node
    private String m_type;
    
    // the src of action for this node
    private String m_src;
    
    private VariableResolver m_varResolver;
    
    // the locations to test against
    private AbstractNode[] m_nodes;

    private SourceResolver resolver;
    
    
    public ActNode(LocatorNode ln, ServiceManager manager) {
        super(manager);
        m_ln = ln;
    }
    
    public void build(Configuration configuration) throws ConfigurationException {
        
        super.build(configuration);
        
        // get the selector
        m_type = configuration.getAttribute("type",m_ln.getDefaultAction());
        String src=configuration.getAttribute("src","");
        try
        {
                m_varResolver = VariableResolverFactory.getResolver(
                    src, super.m_manager);
        }
        catch (PatternException e) {
            throw new ConfigurationException("unable to resolve action 'src' attribute");
        }
//        try {
//            m_src = VariableResolverFactory.getResolver(
//                    configuration.getAttribute("src"), super.m_manager);
//        } catch (PatternException e) {
//            final String message = "Illegal pattern syntax at for location attribute 'src'" +
//                    " at " + configuration.getLocation();
//            throw new ConfigurationException(message,e);
//        }
        try {
            final ServiceSelector selectors = (ServiceSelector) super.m_manager.lookup(Action.ROLE + "Selector");
            m_action = (Action) selectors.select(m_type);
        } catch (ServiceException e) {
            final String message = "Unable to get Selector of type " + m_type;
            throw new ConfigurationException(message,e);
        }
        
        // build the child nodes
        final Configuration[] children = configuration.getChildren();
        final List nodes = new ArrayList(children.length);
        for (int i = 0; i < children.length; i++) {
            AbstractNode node = null;
            String name = children[i].getName();
            if (name.equals("location")) {
                node = new LocationNode(m_ln, super.m_manager);
            } 
            else if (name.equals("match")) {
                node = new MatchNode(m_ln, super.m_manager);
            }
            else if (name.equals("select")) {
                node = new SelectNode(m_ln, super.m_manager);
            }
            else if (name.equals("act")) {
                node = new ActNode(m_ln, super.m_manager);
            }
            else if (!name.equals("parameter")) {
                final String message = "Unknown select node child:" + name;
                throw new ConfigurationException(message);
            }
            if (node != null) {
                node.enableLogging(getLogger());
                node.build(children[i]);
                nodes.add(node);
            }
        }
        m_nodes = (AbstractNode[]) nodes.toArray(new AbstractNode[nodes.size()]);
    }
    public void service(ServiceManager manager) throws ServiceException {
        //FIXME: Determine whether this is really necessary anymore.
        this.resolver = (SourceResolver) manager.lookup(SourceResolver.ROLE);
    }
    /* (non-Javadoc)
     * @see org.apache.forrest.locationmap.lm.AbstractNode#locate(java.util.Map, org.apache.cocoon.components.treeprocessor.InvokeContext)
     */
    public String locate(Map objectModel, InvokeContext context) throws Exception {
        this.resolver = (SourceResolver)m_manager.lookup(SourceResolver.ROLE);
        Parameters parameters = resolveParameters(context,objectModel);
        Redirector redirector = context.getRedirector();
        m_src = m_varResolver.resolve(context,objectModel);
        
        Map substitutions = m_action.act(redirector, resolver, objectModel, m_src, parameters);
        if (substitutions != null) {
            if (getLogger().isDebugEnabled()) {
             //   getLogger().debug("matched: " + m_pattern);
            }
            context.pushMap(null,substitutions);
            for (int i = 0; i < m_nodes.length; i++) {
                String location = m_nodes[i].locate(objectModel,context);
                if (location != null) {
                    return location;
                }
            }
            context.popMap();
        }
        return null;
    }
    
//    public String locate(Map om, InvokeContext context) throws Exception {
//        
//        Parameters parameters = resolveParameters(context,om);
//        for (int i = 0; i < m_nodes.length; i++) {
//            String location = m_nodes[i].locate(om,context);
//            if (m_action.act().select(location,om,parameters)) {
//                if (getLogger().isDebugEnabled()) {
//                    getLogger().debug("selected: " + location);
//                }
//                return location;
//            }
//        }
//        return null;
//    }
}