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
package org.apache.forrest.sourceexists;

import java.net.MalformedURLException;
import java.util.Map;

import java.io.IOException;

import org.apache.cocoon.selection.Selector;

import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;

import org.apache.avalon.framework.logger.AbstractLogEnabled;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.thread.ThreadSafe;

import org.apache.excalibur.source.Source;
import org.apache.excalibur.source.SourceResolver;

/**
 * Selects the first of a set of Sources that exists in the context.
 * <p>
 * For example, we could define a SourceExistsSelector with:
 * <pre>
 * &lt;map:selector name="exists"
 *               logger="sitemap.selector.source-exists"
 *               src="org.apache.cocoon.selection.SourceExistsSelector" />
 * </pre>
 * And use it to build a PDF from XSL:FO or a higher-level XML format with:
 *
 * <pre>
 *  &lt;map:match pattern="**.pdf">
 *    &lt;map:select type="exists">
 *       &lt;map:when test="context/xdocs/{1}.fo">
 *          &lt;map:generate src="content/xdocs/{1}.fo" />
 *       &lt;/map:when>
 *       &lt;map:otherwise>
 *         &lt;map:generate src="content/xdocs/{1}.xml" />
 *         &lt;map:transform src="stylesheets/document-to-fo.xsl" />
 *       &lt;/map:otherwise>
 *    &lt;/map:select>
 *    &lt;map:serialize type="fo2pdf" />
 * </pre>
 */
public class SourceExistsSelector extends AbstractLogEnabled
  implements ThreadSafe, Selector, Serviceable {

    SourceResolver resolver = null;

    /**
     * Set the current <code>ComponentManager</code> instance used by this
     * <code>Composable</code>.
     */
    public void service(ServiceManager manager) throws ServiceException {
        this.resolver = (SourceResolver)manager.lookup(SourceResolver.ROLE);
    }

    /** Return true if Source 'uri' resolves and exists. */
    public boolean select(String uri, Map objectModel, Parameters parameters) {
        Source src = null;
        
        // The locationmap module will return null if there is no match for
        // the supplied hint, without the following the URI will be resolved to
        // the context root, which always exists, but does not contain a valid
        // resource.
        if (uri == null || uri == "") {
           return false; 
        }
        
        try {
            src = resolver.resolveURI(uri);
            if (src.exists()) {
                return true;
            } else {
                return false; 
            }
        } catch (MalformedURLException e) {
            getLogger().warn("Selector URL '"+uri+"' is not a valid Source URL");
            return false;
         } catch (IOException e) {
            getLogger().warn("Error reading from source '"+uri+"': "+e.getMessage());
            return false;
        } finally {
            resolver.release(src);
        }
    }
}
