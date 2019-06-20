/*
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements.  See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License.  You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
/*
 * Created on Oct 21, 2003
 */
package org.apache.forrest.forrestbot.webapp;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

public class Constants {

	private static Logger log = Logger.getLogger(Constants.class);
	
    // FORWARD NAMES
    public static final String FORWARD_NAME_SUCCESS = "Success";
    public static final String FORWARD_NAME_FAILURE = "Failure";
	public static final String FORWARD_NAME_AUTHORIZED = "Authorized";

	// string tokens
	public static final String BUILD_SUCCESS_STRING = "Forrest render Succeeded";

    // status values
	public static final int STATUS_UNKNOWN = 0;
	public static final int STATUS_FAILED = 1;
	public static final int STATUS_SUCCESS = 2;
	public static final int STATUS_RUNNING = 3;

	
	/**
	 * Creates a map of our constants so it can be passed to struts JSPs
	 * only objects, not static stuff can be accessed in a JSP expression
	 * 
	 * http://www.mail-archive.com/taglibs-user@jakarta.apache.org/msg05024.html
	 */
	private static Map constantsMap;
	public static Map getConstantFieldsAsMap()
	  throws IllegalAccessException {
	  	
		if (constantsMap != null)
			return constantsMap;
	  	
	  	log.debug("building constants map");
		Field[] allFields = Constants.class.getDeclaredFields();
		int numFields = allFields.length;
		Map propMap = new HashMap(numFields);
		for (int i = 0; i < numFields; i++) {
			Field f = allFields[i];
			int mods = f.getModifiers();
			if (Modifier.isPublic(mods) &&
				Modifier.isStatic(mods) &&
				Modifier.isFinal(mods)) {
				String name = f.getName();
				Object value = f.get(null);
				propMap.put(name, value);
			}
		}
		constantsMap = Collections.unmodifiableMap(propMap);
		return constantsMap;
	}
}
