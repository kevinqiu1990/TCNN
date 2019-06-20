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
package org.apache.forrest.xni;

import org.apache.cocoon.generation.ServiceableGenerator;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.ResourceNotFoundException;
import org.apache.cocoon.components.source.SourceUtil;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.avalon.excalibur.pool.Recyclable;
import org.apache.excalibur.xml.EntityResolver;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.parameters.ParameterException;
import org.apache.xerces.xni.parser.XMLParserConfiguration;
import org.apache.xerces.xni.parser.XMLConfigurationException;
import org.apache.xerces.util.EntityResolverWrapper;
import org.apache.xerces.parsers.AbstractSAXParser;
import org.apache.excalibur.source.*;

import org.xml.sax.*;

import java.util.Map;
import java.io.IOException;


/** Class <code>org.apache.forrest.components.generator.XNIConfigurableFileGenerator</code>
 *  This class implements a Cocoon Generator that is configurable through
 *  the XNI mechanism that is built into xerces 2.x
 *  The generator is used with:
 *
    <map:generators default="">
      <map:generator name="nekodtd" src="org.apache.forrest.components.generator.XNIConfigurableFileGenerator" label="content" />
    </map:generators>
 *
 * and:
 *
   <map:match pattern="foobar">
     <map:generate type="nekodtd" src="resources/schema/dtd/{1}.dtd">
       <map:parameter name="config-class" value="org.cyberneko.dtd.DTDConfiguration" />
     </map:generate>
     <map:serialize type="xml"/>
   </map:match>
 *
 * TODO: check how some XNIConfigurableXMLReader component (Excalibur style
 *   like the JaxpParser) can be built to do this.  Then the complete
 *   parser can be recycled.
 *
 */
public class XNIConfigurableFileGenerator
extends ServiceableGenerator implements CacheableProcessingComponent, Recyclable
{

  /** Default constructor
   *
   */
  public XNIConfigurableFileGenerator()
  {
  }

  public static final String CONFIGCLASS_PARAMETER = "config-class";
  public static final String FULL_ENTITY_RESOLVER_PROPERTY_URI =
      org.apache.xerces.impl.Constants.XERCES_PROPERTY_PREFIX +
      org.apache.xerces.impl.Constants.ENTITY_RESOLVER_PROPERTY;
  /** The  source */
  private Source inputSource;

  /** The XNIConfiguredParser */
  XMLParserConfiguration parserConfig;

  /**
   * Recycle this component.
   * All instance variables are set to <code>null</code>.
   */
  public void recycle() {
    if (this.inputSource != null) {
      this.resolver.release(inputSource);
      this.inputSource = null;
    }
    super.recycle();
 }

  /**
   * Copy paste en serious cut from cocoon HTML Generator
   */
  public void setup(SourceResolver resolver, Map objectModel, String src, Parameters par)
  throws ProcessingException, SAXException, IOException {
    super.setup(resolver, objectModel, src, par);
    String parserName = null;

    try {
        this.inputSource = resolver.resolveURI(super.source);
        parserName = par.getParameter(CONFIGCLASS_PARAMETER);
        parserConfig = (XMLParserConfiguration)Class.forName(parserName).newInstance();
    } catch(ParameterException e) {
      getLogger().error("Missing parameter " + CONFIGCLASS_PARAMETER, e);
      throw new ProcessingException("XNIConfigurable.setup()",e);
    } catch(InstantiationException e) {
      getLogger().error("Can not make instance of " + parserName, e);
      throw new ProcessingException("XNIConfigurable.setup()",e);
    } catch(IllegalAccessException e) {
      getLogger().error("Can not access constructor of " + parserName, e);
      throw new ProcessingException("XNIConfigurable.setup()",e);
    } catch(ClassNotFoundException e) {
      getLogger().error("Can not find " + parserName, e);
      throw new ProcessingException("XNIConfigurable.setup()",e);
    } catch (SourceException e) {
      getLogger().error("Can not resolve " + super.source);
      throw SourceUtil.handle("Unable to resolve " + super.source, e);
    }
  }

  /**
   * Generate the unique key.
   * This key must be unique inside the space of this component.
   * This method must be invoked before the generateValidity() method.
   *
   * @return The generated key or <code>0</code> if the component
   *              is currently not cacheable.
   */
  public java.io.Serializable getKey() {
    return this.inputSource.getURI();
  }

  // For backwards-compat with old versions of Cocoon
  public java.io.Serializable generateKey() {
    return getKey();
  }

  /**
   * Generate the validity object.
   * Before this method can be invoked the generateKey() method
   * must be invoked.
   *
   * @return The generated validity object or <code>null</code> if the
   *         component is currently not cacheable.
   */
  public SourceValidity getValidity() {
    if (this.inputSource.getLastModified() != 0) {
      this.inputSource.getValidity();
    }
    return null;
  }

  // For backwards-compat with old versions of Cocoon
  public SourceValidity generateValidity() {
    return getValidity();
  }

  /**
   * Generate XML data.
   */
  public void generate()
  throws IOException, SAXException, ProcessingException {
    EntityResolver catalogResolver = null;
    final String[] extendRecognizedProperties = {FULL_ENTITY_RESOLVER_PROPERTY_URI};
    try {
      getLogger().debug("XNIConfigurable generator start generate()");

      //TODO?: Make XNIConfigurableParser an avalon component in it's own right
      //      Let the resolver and namespace stuff be configured and composed on that level.
      //  some ideas on this: (any others?)
      // - build a XNIConfigurableParser Component Interface with its ROLE
      // - add a XNIConfigurableParserSelector that can select() based on full qualified class name
      // - and release() after usage
      // the select method could do 6 next lines:
      catalogResolver = (EntityResolver)this.manager.lookup(EntityResolver.ROLE);
      parserConfig.addRecognizedProperties(extendRecognizedProperties);
      parserConfig.setProperty(FULL_ENTITY_RESOLVER_PROPERTY_URI, new EntityResolverWrapper(catalogResolver));
      final XMLReader parser = new AbstractSAXParser(parserConfig){};
      parser.setFeature("http://xml.org/sax/features/namespaces", true);
      parser.setFeature("http://xml.org/sax/features/namespace-prefixes", true);
      parser.setContentHandler(this.contentHandler);
      parser.parse(new InputSource(this.inputSource.getInputStream()));

    } catch (IOException e){
      getLogger().warn("XNIConfigurable.generate()", e);
      throw new ResourceNotFoundException("Could not get resource to process:\n["
              + "src = " + this.inputSource.getURI() + "]\n", e);
    } catch (SAXException e){
      getLogger().error("XNIConfigurable.generate()", e);
      throw e;
    } catch (XMLConfigurationException e) {
      getLogger().error( "Misconfig " + e.getType(), e);
      throw new ProcessingException("XNIConfigurable.generate()",e);
    } catch (Exception e){
      getLogger().error("Some strange thing just happened!!", e);
      throw new ProcessingException("XNIConfigurable.generate()",e);
    } finally {
      this.manager.release(catalogResolver);
    }
  }
}
