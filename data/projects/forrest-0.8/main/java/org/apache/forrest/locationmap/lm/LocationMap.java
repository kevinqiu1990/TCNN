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

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.avalon.framework.component.WrapperComponentManager;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.container.ContainerUtil;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.logger.Logger;
import org.apache.avalon.framework.service.DefaultServiceManager;
import org.apache.avalon.framework.service.DefaultServiceSelector;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.matching.Matcher;
import org.apache.cocoon.selection.Selector;
import org.apache.cocoon.acting.*;

/**
 * A LocationMap defines a mapping from requests to locations.
 * <p>
 * The syntax of the locationmap is similar to the way a sitemap 
 * maps requests to pipelines. In the locationmap's case 
 * Matchers and Selectors are not used to identify pipelines but
 * location strings.
 * </p>
 * <p>
 * The locationmap was conceived to:
 * <ul>
 *  <li>
 *   Provide a tool for more powerful virtual linking.
 *  </li>
 *  <li>
 *   Enable Forrest with a standard configuration override mechanism.
 *  </li>
 * </ul>
 * </p>
 */
public final class LocationMap extends AbstractLogEnabled {
    
    /** 
     * The locationmap namespace: 
     * <code>http://apache.org/forrest/locationmap/1.0</code>
     */
    public static final String URI = "http://apache.org/forrest/locationmap/1.0";
    
    /**
     * Name of the special anchor map passed into the VariableContext.
     * The value is <code>lm</code> .
     * <p>
     * This makes it possible to use special locationmap variables
     * inside the locationmap definition.
     * </p>
     * <p>
     * Special locationmap parameters are available through this anchor map.
     * For instance the hint parameter defined below can be accessed in 
     * the locationmap definition as follows: <code>{#lm:hint}</code>
     * </p>
     * All anchor map parameters are also passed implicitly into each selector
     * and matcher at run-time.
     */
    public static final String ANCHOR_NAME = "lm";
    
    /**
     * Special anchor map key holding the 'hint' or 'argument' the LocationMap was
     * called with.
     * 
     * <p>
     * The value is <code>hint</code>.
     * </p>
     */
    public static final String HINT_KEY = "hint";
    
    /**
     * The hint's parameter name.
     */
    public static final String HINT_PARAM = "#" + ANCHOR_NAME + ":" + HINT_KEY;
    
    /** Component manager containing the locationmap components */
    private LocationMapServiceManager m_manager;
    
    /** default matcher */
    private String m_defaultMatcher;
    
    /** default action */
    private String m_defaultAction;
    
    /** default selector */
    private String m_defaultSelector;
    
    /** list of LocatorNodes */
    private LocatorNode[] m_locatorNodes;

    /** list of MountNodes */
    private MountNode[] m_mountNodes;
    
    public LocationMap(ServiceManager manager) {
        m_manager = new LocationMapServiceManager(manager);
    }
    
    /**
     * Build the LocationMap by creating the components and recursively building
     * the LocatorNodes.
     */
    public void build(final Configuration configuration) throws ConfigurationException {

        // components
        final Configuration components = configuration.getChild("components");

        // mount
        final Configuration[] mountChildren = configuration.getChildren("mount");
        m_mountNodes = new MountNode[mountChildren.length];

        for (int i = 0; i < mountChildren.length; i++) {
            m_mountNodes[i] = new MountNode(m_manager);
            m_mountNodes[i].enableLogging(getLogger());
            m_mountNodes[i].build(mountChildren[i]);
        }

        // matchers
        Configuration child = components.getChild("matchers",false);
        if (child != null) {
            final DefaultServiceSelector matcherSelector = new DefaultServiceSelector();
            m_defaultMatcher = child.getAttribute("default");
            final Configuration[] matchers = child.getChildren("matcher");
            for (int i = 0; i < matchers.length; i++) {
                String name = matchers[i].getAttribute("name");
                String src  = matchers[i].getAttribute("src");
                Matcher matcher = (Matcher) createComponent(src, matchers[i]);
                matcherSelector.put(name, matcher);
            }
            matcherSelector.makeReadOnly();
            if (!matcherSelector.isSelectable(m_defaultMatcher)) {
                throw new ConfigurationException("Default matcher is not defined.");
            }
            m_manager.put(Matcher.ROLE+"Selector", matcherSelector);
        }

        // selectors
        child = components.getChild("selectors",false);
        if (child != null) {
            final DefaultServiceSelector selectorSelector = new DefaultServiceSelector();
            m_defaultSelector = child.getAttribute("default");
            final Configuration[] selectors = child.getChildren("selector");
            for (int i = 0; i < selectors.length; i++) {
                String name = selectors[i].getAttribute("name");
                String src  = selectors[i].getAttribute("src");
                Selector selector = (Selector) createComponent(src,selectors[i]);
                selectorSelector.put(name,selector);
            }
            selectorSelector.makeReadOnly();
            if (!selectorSelector.isSelectable(m_defaultSelector)) {
                throw new ConfigurationException("Default selector is not defined.");
            }
            m_manager.put(Selector.ROLE+"Selector",selectorSelector);
        }
        
        // actions
        child = components.getChild("actions",false);
        if (child != null) {
            final DefaultServiceSelector actionSelector = new DefaultServiceSelector();
            m_defaultAction = child.getAttribute("default");
            final Configuration[] actions = child.getChildren("action");
            for (int i = 0; i < actions.length; i++) {
                String name = actions[i].getAttribute("name");
                String src  = actions[i].getAttribute("src");
                Action action = (Action) createComponent(src,actions[i]);
                actionSelector.put(name,action);
            }
            actionSelector.makeReadOnly();
            if (!actionSelector.isSelectable(m_defaultAction)) {
                throw new ConfigurationException("Default action is not defined.");
            }
            m_manager.put(Action.ROLE+"Selector",actionSelector);
        }

        m_manager.makeReadOnly();

        // locators
        final Configuration[] children = configuration.getChildren("locator");
        m_locatorNodes = new LocatorNode[children.length];
        for (int i = 0; i < children.length; i++) {
            m_locatorNodes[i] = new LocatorNode(this, m_manager);
            m_locatorNodes[i].enableLogging(getLogger());
            m_locatorNodes[i].build(children[i]);
        }
    }
    
    /**
     * Creates a LocationMap component.
     * <p>
     *  supported component creation lifecycles that are:
     *  - LogEnabled
     *  - Serviceable
     *  - Configurable
     *  - Initializable
     * </p>
     */
    private Object createComponent(String src, Configuration config) throws ConfigurationException {
        Object component = null;
        try {
            component = Class.forName(src).newInstance();
            ContainerUtil.enableLogging(component,getLogger());
            ContainerUtil.service(component, m_manager);
            if (config != null) {
                ContainerUtil.configure(component, config);
            }
            ContainerUtil.initialize(component);
        } catch (Exception e) {
            throw new ConfigurationException("Couldn't create object of type " + src,e);
        }
        return component;
    }
    
    public void dispose() {
        final Iterator components = m_manager.getObjects();
        while(components.hasNext()) {
        	ContainerUtil.dispose(components.next());
        }
        m_manager = null;
        m_locatorNodes = null;
    }
    
    /**
     * Loop through the list of locator nodes invoking
     * the <code>locate()</code> method on each and return
     * the first non-null result.
     */
    public String locate(String hint, Map om) throws Exception {

        String location = null;

        final InvokeContext context = new InvokeContext();
        final Logger contextLogger = getLogger().getChildLogger("ctx");

        ContainerUtil.enableLogging(context, contextLogger);
        ContainerUtil.compose(context, new WrapperComponentManager(m_manager));
        ContainerUtil.service(context, m_manager);

        final Map anchorMap = new HashMap(2);
        anchorMap.put(HINT_KEY,hint);
        context.pushMap(ANCHOR_NAME,anchorMap);

        //mounted locations first
        if (m_mountNodes != null) {
          for (int i = 0; i < m_mountNodes.length; i++) {
            location = m_mountNodes[i].locate(om,context);
            if (location !=null) {
              ContainerUtil.dispose(context);
              return location;
            }
          }
        }
        
        if (m_locatorNodes != null) {
          for (int i = 0; i < m_locatorNodes.length; i++) {
              location = m_locatorNodes[i].locate(om,context);
              if (location != null) {
                  break;
              }
          }
        }
        
        ContainerUtil.dispose(context);
        
        if (location != null && location.startsWith("http:")) {
        	location.replaceAll(" ", "%20");
        }
        
        return location;
    }
    
    /**
     * Expose the default Matcher to LocatorNodes
     */
    String getDefaultMatcher() {
        return m_defaultMatcher;
    }
    
    /**
     * Expose the default Selector to LocatorNodes
     */
    String getDefaultSelector() {
        return m_defaultSelector;
    }
    
    /**
     * Overide DefaultComponentManager to access the list of all
     * components.
     */
    private static class LocationMapServiceManager extends DefaultServiceManager {
        
        LocationMapServiceManager(ServiceManager parent) {
            super(parent);
        }
        
        Iterator getObjects() {
            return super.getObjectMap().values().iterator();
        }

    }

    /**
     * Expose the default Action to LocatorNodes
     */
    String getDefaultAction() {
        return m_defaultAction;
    }
}
