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

package org.apache.forrest.locationmap;

import java.util.Iterator;
import java.util.Map;

import org.apache.avalon.framework.activity.Disposable;
import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.logger.LogEnabled;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;

import org.apache.cocoon.components.modules.input.InputModule;

public abstract class AbstractWrappingModule extends AbstractLogEnabled
    implements InputModule, Configurable, Serviceable, Disposable {

    InputModule child;        
    ServiceManager manager;     
        
    public void service(ServiceManager manager) throws ServiceException {
        this.manager = manager;
    }
    
    public void configure(Configuration config) throws ConfigurationException {
        
        Configuration childConf = config.getChild("component-instance");
        String childClassName = childConf.getAttribute("class");
        getLogger().debug("Loading wrapped class:"+childClassName);
        
        try{
            child = (InputModule) Class.forName(childClassName).newInstance();
            getLogger().debug("Wrapped class instantiated:"+child);
            
            if(child instanceof LogEnabled){
                ((LogEnabled)child).enableLogging( getLogger() );
                getLogger().debug("Wrapped class LogEnabled");
            }   
            
            if(child instanceof Serviceable){
                ((Serviceable)child).service( manager );
                getLogger().debug("Wrapped class Serviced");
            }   
    
            if(child instanceof Configurable){
                ((Configurable)child).configure(config.getChild("component-instance"));
                getLogger().debug("Wrapped class Configured");
            }  
                
        }catch(Exception e){
           throw new ConfigurationException
                  ("Cannot instatiate the wrapped Module of class:"+childClassName, e);
        }     
     }
    
    public Object getAttribute(String name, Configuration modeConf, Map objectModel)
        throws ConfigurationException {
        return child.getAttribute(name, modeConf, objectModel);
    }

    public Iterator getAttributeNames(Configuration modeConf, Map objectModel)
        throws ConfigurationException {
        return child.getAttributeNames(modeConf, objectModel);
    }

    public Object[] getAttributeValues(String name, Configuration modeConf, Map objectModel)
        throws ConfigurationException {
        return child.getAttributeValues(name, modeConf, objectModel);
    }
  
    public void dispose() {
        if(child instanceof Disposable){
            ((Disposable)child).dispose();
        }   
    }
    
}
