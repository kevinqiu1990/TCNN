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
import org.apache.forrest.locationmap.lm.LocationMap;
import org.apache.cocoon.matching.AbstractWildcardMatcher;

/**
 * Match a LocationMap hint - the part after the module name (module_name:<b>hint</b>) - 
 * against a wildcard pattern.
 */
public class WildcardLocationMapHintMatcher extends AbstractWildcardMatcher {

    protected String getMatchString(Map objectModel, Parameters parameters) {
        return parameters.getParameter(LocationMap.HINT_PARAM,"");
    }

}
