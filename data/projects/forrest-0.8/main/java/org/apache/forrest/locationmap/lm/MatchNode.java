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
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.matching.Matcher;

/**
 * Locationmap match statement.
 * 
 * <p>
 * The &lt;match&gt; element has one required <code>pattern</code> attribute
 * which identifies the pattern the associated Matcher should match
 * against and one optional <code>type</code> attribute that identifies
 * the Matcher that is to do the matching.
 * </p>
 * 
 * Match statements can contain <code>&lt;match&gt;</code>,
 * <code>&lt;select&gt;</code> and <code>&lt;location&gt;</code>
 * child statements.
 * 
 * <p>
 * Match nodes can be parametrized using <code>&lt;parameter&gt;</code> child elements.
 * </p>
 */
public final class MatchNode extends AbstractNode {
    
    // the containing LocatorNode
    private final LocatorNode m_ln;
    
    // the Matcher that does the work
    private Matcher m_matcher;
    
    // the type of Matcher for this node
    private String m_type;
    
    // the pattern to match
    private String m_pattern;
    
    // the child nodes
    private AbstractNode[] m_nodes;
    
    public MatchNode(final LocatorNode ln, final ServiceManager manager) {
        super(manager);
        m_ln = ln;
    }
    
    public void build(final Configuration configuration) throws ConfigurationException {
        
        super.build(configuration);
        
        // get the matcher
        m_type = configuration.getAttribute("type",m_ln.getDefaultMatcher());
        try {
            ServiceSelector matchers = (ServiceSelector) super.m_manager.lookup(Matcher.ROLE + "Selector");
            m_matcher = (Matcher) matchers.select(m_type);
        } catch (ServiceException e) {
            final String message = "Unable to get Matcher of type " + m_type;
            throw new ConfigurationException(message,e);
        }
        
        // get the matcher pattern
        m_pattern = configuration.getAttribute("pattern");
        
        // get the child nodes
        final Configuration[] children = configuration.getChildren();
        final List nodes = new ArrayList(children.length);
        for (int i = 0; i < children.length; i++) {
            AbstractNode node = null;
            String name = children[i].getName();
            if (name.equals("location")) {
                node = new LocationNode(m_ln, super.m_manager);
            }
            else if (name.equals("match")) {
                node = new MatchNode(m_ln,super.m_manager);
            }
            else if (name.equals("select")) {
                node = new SelectNode(m_ln, super.m_manager);
            }
            else if (name.equals("act")) {
                node = new ActNode(m_ln, super.m_manager);
            }
            else if (!name.equals("parameter")) {
                final String message =
                    "Unknown match node child: " + name;
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
    
    public String locate(Map om, InvokeContext context) throws Exception {
        
        Parameters parameters = resolveParameters(context,om);
        if (getLogger().isDebugEnabled()) {
            getLogger().debug("Examining match: " + m_pattern);
        }
        Map substitutions = m_matcher.match(m_pattern,om,parameters);
        if (substitutions != null) {
            context.pushMap(null,substitutions);
            for (int i = 0; i < m_nodes.length; i++) {
                String location = m_nodes[i].locate(om,context);
                if (location != null) {
                    if (getLogger().isDebugEnabled()) {
                        getLogger().debug("got location: " + location);
                    }
                    return location;
                }
            }
            context.popMap();
        }
        
        if (getLogger().isDebugEnabled()) {
            getLogger().debug("no appropriate location, continue processing matches");
        }
        return null;
    }
    
}