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

import java.io.IOException;
import java.util.Map;

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.configuration.NamespacedSAXConfigurationHandler;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.cocoon.components.treeprocessor.InvokeContext;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolver;
import org.apache.cocoon.components.treeprocessor.variables.VariableResolverFactory;
import org.apache.cocoon.sitemap.PatternException;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.SourceUtil;
import org.apache.excalibur.source.SourceResolver;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.xml.sax.SAXParser;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 * locationmap mount statement.
 */
public class MountNode extends AbstractNode {

    // the resolvable location source
    private SourceResolver m_srcResolver;
    private VariableResolver m_varResolver;
    private String m_src;
    private SourceValidity m_srcVal;
    private LocationMap m_lm;


    public MountNode(final ServiceManager manager) {
        super(manager);
    }

    public void build(final Configuration configuration) throws ConfigurationException {
        try
        {
        	m_varResolver = VariableResolverFactory.getResolver(
        	    configuration.getAttribute("src"), super.m_manager);
        }
        catch (PatternException e) {
        	throw new ConfigurationException("unable to resolve mounts 'src' attribute");
        }
    }

    //TODO:  Look at re-use with locationmapmodule code.
    private LocationMap getLocationMap() throws Exception {
        Source source = null;
        try {
            try {
            	m_srcResolver = (SourceResolver) m_manager.lookup(SourceResolver.ROLE);
            }
            catch (ServiceException e) {
            	throw new ConfigurationException("building mount node");
            }
            source = m_srcResolver.resolveURI(m_src);
            if (m_lm == null) {
                synchronized (this) {
                    if (m_lm == null) {
                        if (getLogger().isDebugEnabled()) {
                            getLogger().debug("loading mounted location map at " + m_src);
                        }
                        m_srcVal = source.getValidity();
                        m_lm = new LocationMap(m_manager);
                        m_lm.enableLogging(getLogger());
                        m_lm.build(loadConfiguration(source));
                    }
                }
            }
            else {
                SourceValidity valid = source.getValidity();
                if (m_srcVal != null && m_srcVal.isValid(valid) != 1) {
                    synchronized (this) {
                        if (m_srcVal != null && m_srcVal.isValid(valid) != 1) {
                            if (getLogger().isDebugEnabled()) {
                                getLogger().debug("reloading mounted location map at " + m_src);
                            }
                            m_srcVal = valid;
                            m_lm.dispose();
                            m_lm = new LocationMap(m_manager);
                            m_lm.enableLogging(getLogger());
                            m_lm.build(loadConfiguration(source));
                        }
                    }
                }
            }
        }
        finally {
            if (source != null) {
                m_srcResolver.release(source);
            }
        }
        return m_lm;
    }

    //TODO:  Look at re-use with locationmapmodule code.
    private Configuration loadConfiguration(Source source) throws ConfigurationException {
        Configuration configuration = null;
        SAXParser parser = null;
        try {
            parser = (SAXParser) m_manager.lookup(SAXParser.ROLE);
            NamespacedSAXConfigurationHandler handler =
                new NamespacedSAXConfigurationHandler();
            parser.parse(new InputSource(source.getInputStream()),handler);
            configuration = handler.getConfiguration();
        }
        catch (IOException e) {
            throw new ConfigurationException("Unable to build LocationMap.",e);
        }
        catch (SAXException e) {
            throw new ConfigurationException("Unable to build LocationMap.",e);
        }
        catch (ServiceException e) {
            throw new ConfigurationException("Unable to build LocationMap.",e);
        }
        finally {
            if (parser != null) {
                m_manager.release(parser);
            }
        }
        return configuration;
    }

    /**
     * use mounted locationmap to locate hint
     */
    public String locate(Map om, InvokeContext context) throws Exception {
       try {
    	    Map anchor = context.getMapByAnchor(LocationMap.ANCHOR_NAME );
   	    String hint = (String)anchor.get(LocationMap.HINT_KEY);

            //TODO: Put this in a better place, closer to instantiation;
            //      m_src needs to be properly set prior to getLocMap call
            m_src = m_varResolver.resolve(context,om);

            return getLocationMap().locate(hint,om);
        }
        catch (ConfigurationException e) {
            throw e;
        }
        catch (Exception e) {
            getLogger().error("Failure processing LocationMap.",e);
        }
        return null;

    }

}
