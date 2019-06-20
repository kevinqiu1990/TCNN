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
package org.apache.forrest.conf;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;
import org.apache.avalon.framework.thread.ThreadSafe;
import org.apache.cocoon.components.modules.input.AbstractJXPathModule;
import org.apache.cocoon.components.modules.input.InputModule;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;

/**
 * Input module for accessing properties in a properties file 
 * roughly compatible with Ant property files, where ${name}
 * is replaced with the value of the property 'name' if
 * declared beforehand.
 * 
 * <p>
 *  The properties file can only be configured statically and
 *  is resolved via the SourceResolver system.
 * </p>
 * 
*/
public class AntPropertiesModule extends AbstractJXPathModule 
implements InputModule, Serviceable, Configurable, ThreadSafe {
    
    private SourceResolver m_resolver;
    private Properties m_properties;
    
    public void service(ServiceManager manager) throws ServiceException {
        m_resolver = (SourceResolver) manager.lookup(SourceResolver.ROLE);
    }
    
    /**
     * Configure the location of the properties file:
     * <p>
     *  <code>&lt;file src="resource://my.properties" /&gt;</code>
     * </p>
     */
    public void configure(Configuration configuration) throws ConfigurationException {
        super.configure(configuration);
        String file = configuration.getChild("file").getAttribute("src");
        load(file);
    }
    
    protected void load(String file) throws ConfigurationException {
        Source source = null;
        InputStream in = null;
        try {
            source = m_resolver.resolveURI(file);
           
            in = source.getInputStream();
            
            m_properties = new AntProperties();
            m_properties.load(in);
 
        }
        catch (IOException e) {
            throw new ConfigurationException("Cannot load properties file " + file);
        }
        finally {
            if (source != null) {
                m_resolver.release(source);
            }
            if (in != null) {
                try {
                    in.close();
                }
                catch (IOException e) {
                }
            }
        }
    }
    
    protected Object getContextObject(Configuration modeConf, Map objectModel)
        throws ConfigurationException {
        
        return m_properties;
    }

}
