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
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolver;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolverFactory;
import org.apache.cocoon.sitemap.PatternException;
import org.apache.excalibur.source.SourceUtil;


/**
 * Top level locate statement containing 
 * <code>MatchNode</code>s and <code>SelectNode</code>s.
 * 
 * <p>
 * A locator defines a common location context for its
 * contained location statements. Location strings resolved within
 * the context of a given locator will be prefixed with the
 * locator's base location. This base location is specified
 * using the <code>base</code> attribute on the <code>&lt;locator&gt;</code>
 * element and defaults to <code>.</code>.
 * </p>
 */
public final class LocatorNode extends AbstractNode {
    
    // the containing LocationMap
    private final LocationMap m_lm;
    
    // location base resolver
    private VariableResolver m_baseLocation;
    
    // the contained Match- and SelectNodes
    private AbstractNode[] m_nodes;

    public LocatorNode(final LocationMap lm, final ServiceManager manager) {
        super(manager);
        m_lm = lm;
    }
    
    public void build(final Configuration configuration) throws ConfigurationException {
    	
    	super.build(configuration);

        // get the base attribute
        String base = configuration.getAttribute("base", null);
        if (base != null) {
            try {
                m_baseLocation = VariableResolverFactory.getResolver(base, super.m_manager);
            } catch (PatternException e) {
                final String message = "Illegal pattern syntax for locator attribute 'base'" +
                		" at " + configuration.getLocation();
                throw new ConfigurationException(message);
            }
        }
        
        // get the child nodes
        final Configuration[] children = configuration.getChildren();
        final List nodes = new ArrayList(children.length);
        for (int i = 0; i < children.length; i++) {
            AbstractNode node = null;
            if (children[i].getName().equals("match")) {
                node = new MatchNode(this, super.m_manager);
            }
            else if (children[i].getName().equals("select")) {
                node = new SelectNode(this, super.m_manager);
            }
            else if (children[i].getName().equals("act")) {
                node = new ActNode(this, super.m_manager);
            }
            else {
                final String message = "Illegal locator node child: " 
                    + children[i].getName();
                throw new ConfigurationException(message);
            }
            node.enableLogging(getLogger());
            node.build(children[i]);
            nodes.add(node);
        }
        m_nodes = (AbstractNode[]) nodes.toArray(new AbstractNode[nodes.size()]);
    }
    
    /**
     * Loop over the list of match and select nodes and call their
     * respective <code>locate()</code> methods returning the first
     * non-null result.
     */
    public String locate(Map om, InvokeContext context) throws Exception {

        // resolve the base location
    	String base = null;
    	if (m_baseLocation != null) {
    		base = m_baseLocation.resolve(context, om);
        	if (base != null && base.charAt(base.length()-1) != '/') {
        		base = base + "/";
        	}
    	}

      if (m_nodes != null) {
        for (int i = 0; i < m_nodes.length; i++) {
            String location = m_nodes[i].locate(om, context);
            if (location != null) {
                if (base != null && base.length() != 0)  {
                	if (location.charAt(0) != '/' && SourceUtil.indexOfSchemeColon(location) == -1) {
                        location = base + location;
                	}
                }
                if (getLogger().isDebugEnabled()) {
                    getLogger().debug("located: " + location);
                }
                return location;
            }
        }
      }
        return null;
    }
    
    String getDefaultMatcher() {
        return m_lm.getDefaultMatcher();
    }
    
    String getDefaultSelector() {
        return m_lm.getDefaultSelector();
    }

    String getDefaultAction() {
        return  m_lm.getDefaultAction();
    }
    
}
