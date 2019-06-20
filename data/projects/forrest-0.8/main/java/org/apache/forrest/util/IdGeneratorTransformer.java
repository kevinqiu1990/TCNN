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
package org.apache.forrest.util;

import java.io.IOException;
import java.io.Serializable;
import java.net.URLEncoder;
import java.util.Map;

import org.apache.avalon.framework.activity.Disposable;
import org.apache.avalon.framework.configuration.Configurable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.cocoon.transformation.AbstractDOMTransformer;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.util.HashUtil;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.apache.excalibur.xml.xpath.XPathProcessor;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * A Transformer for adding a URL-encoded 'id' attribute to a node, whose value
 * is determined by the string value of another node.
 *
 * <p>
 * For example, if we were parsing XML like:
 * <pre>
 * &lt;section>
 *   &lt;title>Blah blah</title>
 *   ....
 * &lt;/section>
 * </pre>
 * We could add an 'id' attribute to the 'section' element with a transformer
 * configured as follows:
 * <pre>
 * &lt;map:transformer name="idgen"
 *      src="org.apache.cocoon.transformation.IdGeneratorTransformer">
 *   &lt;element>/document/body//*[local-name() = 'section']&lt;/element>
 *   &lt;id>title/text()&lt;/id>
 * &lt;/map:transformer>
 * </pre>
 * The 'element' parameter is an XPath expression identifying candidates for
 * having an id added.
 * The 'id' parameter is an XPath relative to each found 'element', and
 * specifies a string to use as the id attribute value.  The value will be URL
 * encoded in the id attribute.  If an id with the specified value already
 * exists, the new id will be made unique with XPath's
 * <code>generate-id()</code> function.
 * <p>
 * By default, the added attribute is called <code>id</code>.  This can be
 * altered by specifying an <code>id-attr</code> parameter:
 * <pre>
 *   &lt;id-attr>ID&lt;/id-attr>
 * </pre>
 * If the specified attribute is already present on the node, it will not be
 * rewritten.
 */
public class IdGeneratorTransformer
    extends AbstractDOMTransformer
    implements CacheableProcessingComponent, Configurable, Disposable
{

    /** XPath Processor */
    private XPathProcessor processor = null;

    protected String elementXPath = null;
    protected String idXPath = null;
    protected String idAttr = null;

    public void configure(Configuration configuration) throws ConfigurationException {
        getLogger().info("## || Configuring IdGeneratorTransformer with "+configuration);
        this.elementXPath = configuration.getChild("element").getValue(null);
        this.idXPath = configuration.getChild("id").getValue(null);
        this.idAttr = configuration.getChild("id-attr").getValue("id");
        if (elementXPath == null) {
            throw new ConfigurationException(
                    "## The IdGenerator 'element' parameter must be specified. For example, "+
                    "<element>/document/body//*[local-name() = 'section']</element>");
        }
        if (idXPath == null) {
            throw new ConfigurationException(
                    "## The IdGenerator 'id' parameter must be specified. For example,"+
                    "<id>title/text()</id>");
        }
    }

    public void setup(SourceResolver resolver, Map objectModel,
            String source, Parameters parameters)
        throws ProcessingException, SAXException, IOException
    {
        super.setup(resolver, objectModel, source, parameters);
        /*
         If you prefer dynamic configuration, use this instead of
         configure(), and remember to clear the fields in recycle()

        this.elementXPath = (String)parameters.getParameter("element", null);
        if (this.elementXPath == null) {
            throw new ProcessingException(
                    "The IdGenerator 'element' parameter must be specified. For example, "+
                    "<map:parameter name=\"element\" value=\"/document/body//*[local-name() = 'section']\"/>");
        }
        this.idXPath = (String)parameters.getParameter("id", null);
        if (idXPath == null) {
            throw new ProcessingException(
                    "The IdGenerator 'id' parameter must be specified. For example,"+
                    "<map:parameter name=\"id\" value=\"title/text()\"/>");
        }
        this.idAttr = (String)parameters.getParameter("id-attr", "id");
        */
    }

    public void service(ServiceManager manager) throws ServiceException {
        super.service(manager);
        try {
            this.processor = (XPathProcessor)this.manager.lookup(XPathProcessor.ROLE);
        } catch (Exception e) {
            getLogger().error("cannot obtain XPathProcessor", e);
        }
    }

    /** Implementation of a template method declared in AbstractDOMTransformer.
     * @param doc DOM of XML received by the transformer
     * @return A pared-down DOM.
     */
    protected Document transform(Document doc) {
        getLogger().debug("## Transforming with element='"+elementXPath+"', id='"+idXPath+"'");
        Document newDoc = null;
        try {
            newDoc = addIds(doc, elementXPath, idXPath);
        } catch (SAXException se) {
            // Really ought to be able to propagate these to caller
            getLogger().error("Error when transforming XML: "+se.getMessage(), se.getException());
            throw new RuntimeException("Error transforming XML. See error log for details: "+se.getMessage()+". Nested exception: "+se.getException().getMessage());
        }
        return newDoc;
    }

    private Document addIds(Document doc, String elementXPath, String idXPath) throws SAXException {
        getLogger().debug("## Using element XPath "+elementXPath);
        NodeList sects = processor.selectNodeList(doc, elementXPath);
        getLogger().debug("## .. got "+sects.getLength()+" sections");
        for (int i=0; i<sects.getLength(); i++) {
            Element sect = (Element)sects.item(i);
            if (!sect.hasAttribute(this.idAttr)) {
                sect.normalize();
                getLogger().debug("## Using id XPath "+idXPath);
                String id = null;
                try {
                  id = processor.evaluateAsString(sect, idXPath).trim();
                } catch (Exception e) {
                    throw new SAXException("'id' XPath expression '"+idXPath+"' does not return a text node: "+e, e);
                }
                getLogger().info("## Got id "+id);
                // Use of the new version of encode method to avoid to generate URI such as :
                //	- <a href="#Quelques+r%E8gles...">Quelques règles...</a>
                // Which is not, curiously, well decoded...
                // The new methode - which allow to specify "UTF-8" gives :
                //	- <a href="#Quelques+r%C3%A8gles...">Quelques règles...</a>
                // And it works OK,
                String newId;
                try {
                  newId = URLEncoder.encode(id, "UTF-8");
                }
                catch( java.io.UnsupportedEncodingException e )
                { 
                  getLogger().error("cannot encode Id, using generate-id instead...", e);
                  newId = processor.evaluateAsString(sect, "generate-id()");
		}
       	        newId = avoidConflicts(doc, sect, this.idAttr, newId);
                // Upgrade to DOM 2 support
                //sect.setAttribute(this.idAttr, newId);
                sect.setAttributeNS(sect.getNamespaceURI(), this.idAttr, newId);
            }
        }
        return doc;
    }

    /**
     * Ensure that IDs aren't repeated in the document.  If an element with the
     * specified id is already present, <code>generate-id</code> is used to
     * distinguish the new one.
     */
    private String avoidConflicts(Document doc, Element sect, String idAttr, String newId) {
        // We rely on the URLencoding of newId to avoid ' conflicts here:
        NodeList conflicts = processor.selectNodeList(doc, "//*[@"+idAttr+"='"+newId+"']");
        int numConflicts = conflicts.getLength();
        getLogger().info("## "+numConflicts+" conflicts with "+newId);
        if (numConflicts != 0) {
            newId += "-"+processor.evaluateAsString(sect, "generate-id()");
        }
        return newId;
    }

    // Cache methods

    /**
     * Generate the unique key.
     * This key must be unique inside the space of this component.
     *
     * @return A hash of the element and id parameters, thus uniquely
     * identifying this IdGenerator amongst it's peers.
     */
    public Serializable getKey() {
        return ""+HashUtil.hash(this.elementXPath+this.idXPath);
    }

    // for backwards-compat
    public Serializable generateKey() {
      return getKey();
    }


    /**
     * Generate the validity object.
     *
     * @return An "always valid" SourceValidity object. This transformer has no
     * inputs other than the incoming SAX events.
     */
    public SourceValidity getValidity() {
        return new NOPValidity();
    }

    public SourceValidity generateValidity() {
      return getValidity();
    }


    /**
     * Recycle the component.
     */
    public void recycle() {
        super.recycle();
        // Uncomment these if we're dynamically (in the map:transform) configuring
        //this.elementXPath = null;
        //this.idXPath = null;
        // note that we don't turf our processor,
    }

    /**
     * dispose
     */
    public void dispose() {
        super.dispose();
        this.processor = null;
        this.elementXPath = null;
        this.idXPath = null;
        this.idAttr = null;
    }
}
