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
import java.net.MalformedURLException;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedSet;
import java.util.StringTokenizer;
import java.util.TreeSet;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.avalon.framework.activity.Initializable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;
import org.apache.avalon.framework.thread.ThreadSafe;
import org.apache.cocoon.components.modules.input.DefaultsModule;
import org.apache.cocoon.components.modules.input.InputModule;
import org.apache.commons.lang.SystemUtils;
import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceNotFoundException;
import org.apache.excalibur.source.SourceResolver;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * Input module for accessing the base properties used in Forrest. The main
 * values are the locations of the <b>source </b> directories and of the
 * <b>forrest </b> directories. The values are gotten using the ForrestConfUtils
 * class.
 */
public class ForrestConfModule extends DefaultsModule implements InputModule,
        Initializable, ThreadSafe, Serviceable {
    private AntProperties filteringProperties;

    private String forrestHome, projectHome, contextHome;

    private SourceResolver m_resolver;

    public Object getAttribute(String name, Configuration modeConf,
            Map objectModel) throws ConfigurationException {
        String original;
        String attributeValue;

        try {
            original = super.getAttributeValues(name, modeConf, objectModel)[0]
                    .toString();
            attributeValue = this.getAttributeValues(name, modeConf,
                    objectModel)[0].toString();
        } catch (NullPointerException npe) {
            original = "(not defined in forrest.xconf)";
            attributeValue = filteringProperties.getProperty(name);
            if (attributeValue == null) {
                String error = "Unable to get attribute value for "
                        + name
                        + "\n"
                        + "Please make sure you defined "
                        + name
                        + " in either forrest.properties.xml in $PROJECT_HOME "
                        + "or in the default.forrest.properties.xml of the plugin "
                        + "that is requesting this property."
                        + "\n"
                        + "If you see this message, then most of the time you have spotted a plugin bug "
                        + "(i.e. forgot to define the plugin's default property). Please report to our mailing list.";
                throw new ConfigurationException(error);
            }
        }

        if (debugging()) {
            debug(" - Requested:" + name);
            debug(" - Unfiltered:" + original);
            debug(" - Given:" + attributeValue);
        }

        return attributeValue;
    }

    public Object[] getAttributeValues(String name, Configuration modeConf,
            Map objectModel) throws ConfigurationException {
        Object[] attributeValues = super.getAttributeValues(name, modeConf,
                objectModel);
        for (int i = 0; i < attributeValues.length; i++) {
            if (null != attributeValues[i])
                attributeValues[i] = filteringProperties
                        .filter(attributeValues[i].toString());
            else
                attributeValues[i] = filteringProperties
                        .filter(filteringProperties.getProperty(name));
        }

        return attributeValues;
    }

    public Iterator getAttributeNames(Configuration modeConf, Map objectModel)
            throws ConfigurationException {

        SortedSet matchset = new TreeSet();
        Enumeration enum1eration = filteringProperties.keys();
        while (enumeration.hasMoreElements()) {
            String key = (String) enumeration.nextElement();
            matchset.add(key);
        }
        Iterator iterator = super.getAttributeNames(modeConf, objectModel);
        while (iterator.hasNext())
            matchset.add(iterator.next());
        return matchset.iterator();
    }

    public void initialize() throws Exception {

        // add all homes important to forrest to the properties
        setHomes();

        loadSystemProperties(filteringProperties);

        // NOTE: the first values set get precedence, as in AntProperties

        String forrestPropertiesStringURI;

        try {
            // get forrest.properties and load the values
            forrestPropertiesStringURI = projectHome
                    + SystemUtils.FILE_SEPARATOR + "forrest.properties";
            filteringProperties = loadAntPropertiesFromURI(filteringProperties,
                    forrestPropertiesStringURI);
            
            // get the values from local.forrest.properties.xml
            forrestPropertiesStringURI = projectHome
                    + SystemUtils.FILE_SEPARATOR
                    + "local.forrest.properties.xml";
            filteringProperties = loadXMLPropertiesFromURI(filteringProperties,
                    forrestPropertiesStringURI);

            // get the values from project forrest.properties.xml
            forrestPropertiesStringURI = projectHome
                    + SystemUtils.FILE_SEPARATOR + "forrest.properties.xml";
            filteringProperties = loadXMLPropertiesFromURI(filteringProperties,
                    forrestPropertiesStringURI);

            // get the values from user forrest.properties.xml
            String userHome = filteringProperties.getProperty("user.home");
            if (userHome != null) {
                forrestPropertiesStringURI = userHome
                        + SystemUtils.FILE_SEPARATOR + "forrest.properties.xml";
                filteringProperties = loadXMLPropertiesFromURI(
                        filteringProperties, forrestPropertiesStringURI);
            }

            // get the values from global forrest.properties.xml
            String globalHome = filteringProperties.getProperty("global.home");
            if (globalHome != null) {
                forrestPropertiesStringURI = globalHome
                        + SystemUtils.FILE_SEPARATOR + "forrest.properties.xml";
                filteringProperties = loadXMLPropertiesFromURI(
                        filteringProperties, forrestPropertiesStringURI);
            }

            // get the values from default.forrest.properties.xml
            forrestPropertiesStringURI = contextHome
                    + SystemUtils.FILE_SEPARATOR
                    + "default.forrest.properties.xml";
            filteringProperties = loadXMLPropertiesFromURI(filteringProperties,
                    forrestPropertiesStringURI);

            // Load plugin default properties
            String strPluginList = filteringProperties
                    .getProperty("project.required.plugins");
            if (strPluginList != null) {
                StringTokenizer st = new StringTokenizer(strPluginList, ",");
                while (st.hasMoreTokens()) {
                    forrestPropertiesStringURI = ForrestConfUtils
                            .getPluginDir(st.nextToken().trim());
                    forrestPropertiesStringURI = forrestPropertiesStringURI
                            + SystemUtils.FILE_SEPARATOR
                            + "default.plugin.properties.xml";
                    filteringProperties = loadXMLPropertiesFromURI(
                            filteringProperties, forrestPropertiesStringURI);
                }
            }

            // get default-forrest.properties and load the values
            String defaultForrestPropertiesStringURI = contextHome
                    + SystemUtils.FILE_SEPARATOR + "default-forrest.properties";
            filteringProperties = loadAntPropertiesFromURI(filteringProperties,
                    defaultForrestPropertiesStringURI);
        } finally {
            ForrestConfUtils.aliasSkinProperties(filteringProperties);
            if (debugging())
                debug("Loaded project properties:" + filteringProperties);
        }
    }

    /**
     * Sets all forrest related home locations such as - forrestHome -
     * projectHome - contextHome
     * 
     * @throws Exception
     */
    private void setHomes() throws Exception {
        forrestHome = ForrestConfUtils.getForrestHome();
        projectHome = ForrestConfUtils.getProjectHome();
        contextHome = ForrestConfUtils.getContextHome();

        filteringProperties = new AntProperties();

        filteringProperties.setProperty("forrest.home", forrestHome);
        filteringProperties.setProperty("project.home", projectHome);
        filteringProperties.setProperty("context.home", contextHome);
    }

    /**
     * Load system properties
     */
    private void loadSystemProperties(AntProperties props) {
        for (Enumeration e = System.getProperties().propertyNames(); e
                .hasMoreElements();) {
            String propName = (String) e.nextElement();
            if (propName.startsWith("forrest.")
                    || propName.startsWith("project.")
                    || propName.endsWith(".home")) {
                String systemPropValue = System.getProperty(propName);
                if (systemPropValue != null) {
                    props.setProperty(propName, systemPropValue);
                }
            }
        }
    }

    /**
     * @param antPropertiesStringURI
     * @throws MalformedURLException
     * @throws IOException
     * @throws SourceNotFoundException
     */
    private AntProperties loadAntPropertiesFromURI(
            AntProperties precedingProperties, String antPropertiesStringURI)
            throws MalformedURLException, IOException, SourceNotFoundException {

        Source source = null;
        InputStream in = null;
        try {
            source = m_resolver.resolveURI(antPropertiesStringURI);
            if (debugging())
                debug("Searching for forrest.properties in" + source.getURI());
            if (source.exists()) {
                in = source.getInputStream();
                filteringProperties = new AntProperties(precedingProperties);
                filteringProperties.load(in);

                if (debugging())
                    debug("Loaded:" + antPropertiesStringURI
                            + filteringProperties.toString());
            }

        } finally {
            if (source != null) {
                m_resolver.release(source);
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                }
            }
        }

        return filteringProperties;
    }

    /**
     * @param propertiesStringURI
     * @throws IOException
     * @throws MalformedURLException
     * @throws MalformedURLException
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws SourceNotFoundException
     */
    private AntProperties loadXMLPropertiesFromURI(
            AntProperties precedingProperties, String propertiesStringURI)
            throws MalformedURLException, IOException,
            ParserConfigurationException, SAXException {

        Source source = null;
        InputStream in = null;
        try {
            source = m_resolver.resolveURI(propertiesStringURI);
            if (debugging())
                debug("Searching for forrest.properties.xml in "
                        + source.getURI());
            if (source.exists()) {

                DocumentBuilderFactory factory = DocumentBuilderFactory
                        .newInstance();
                DocumentBuilder builder = factory.newDocumentBuilder();
                Document document = builder.parse(source.getURI());

                NodeList nl = document.getElementsByTagName("property");
                if (nl != null && nl.getLength() > 0) {
                    for (int i = 0; i < nl.getLength(); i++) {
                        Element el = (Element) nl.item(i);
                        filteringProperties.setProperty(
                                el.getAttribute("name"), el
                                        .getAttribute("value"));
                    }
                }

                if (debugging())
                    debug("Loaded:" + propertiesStringURI
                            + filteringProperties.toString());
            } else if (debugging())
                debug("Unable to find " + source.getURI() + ", ignoring.");

        } finally {
            if (source != null) {
                m_resolver.release(source);
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                }
            }
        }

        return filteringProperties;
    }

    public void service(ServiceManager manager) throws ServiceException {
        m_resolver = (SourceResolver) manager.lookup(SourceResolver.ROLE);
    }

    /**
     * Rocked science
     */
    private final boolean debugging() {
        return getLogger().isDebugEnabled();
    }

    /**
     * Rocked science
     * 
     * @param debugString
     */
    private final void debug(String debugString) {
        getLogger().debug(debugString);
    }

}
