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
 * Created on Feb 11, 2004
 */
package org.apache.forrest.forrestbot.webapp.form;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;


public class BaseDynaActionForm extends DynaActionForm {
	private static Logger log = Logger.getLogger(BaseDynaActionForm.class);
	
	protected boolean isEmptyString(Object o) {
		return o == null || 
			o.getClass() != String.class || 
			((String) o).trim().equals("");
	}

	protected ActionMessages checkRequiredFields(String [] fields) {
		ActionMessages errors = new ActionMessages();
		for (int i = 0; i < fields.length; i++)
		if (isEmptyString(get(fields[i]))) {
			log.debug(fields[i] + " is empty string");
			errors.add(fields[i], new ActionError("error.required", fields[i]));
		}

		return errors;
	}
}
