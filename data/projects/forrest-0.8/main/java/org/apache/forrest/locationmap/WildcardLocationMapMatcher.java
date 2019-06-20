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

import java.util.Map;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.avalon.framework.thread.ThreadSafe;
import org.apache.forrest.locationmap.lm.LocationMap;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.matching.AbstractWildcardMatcher;


/**
 * Match a LocationMap URI against a wildcard pattern.
 * 
 * <p>
 * The LocationMap URI is a string that is composed of 
 * the input module hint the LocationMap was called with
 * concatenated with the request URI of the current Request.
 * </p>
 * 
 * <a href="mailto:unico@hippo.nl">Unico Hommes</a>
 */
public class WildcardLocationMapMatcher extends AbstractWildcardMatcher 
    implements ThreadSafe {
    
    /**
     * Return the LocationMap hint concatenated with the request URI.
     */
    protected String getMatchString(Map objectModel, Parameters parameters) {
        
        String hint = parameters.getParameter(LocationMap.HINT_PARAM,"");
        String uri  = ObjectModelHelper.getRequest(objectModel).getSitemapURI();
        
        if (uri.charAt(0) != '/') {
            uri = "/" + uri;
        }
        if (hint.charAt(hint.length()-1) == '/') {
            hint = hint.substring(0,hint.length()-1);
        }
        if (hint.charAt(0) == '/') {
            hint = hint.substring(1);
        }
        
        return hint + uri;
    }

}
