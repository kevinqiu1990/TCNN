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
package org.apache.forrest.forrestbot.webapp.action;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.forrest.forrestbot.webapp.Config;
import org.apache.forrest.forrestbot.webapp.Constants;
import org.apache.forrest.forrestbot.webapp.util.Project;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public final class ViewLogBodyAction extends BaseAction {
	private static Logger log = Logger.getLogger(ViewLogBodyAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		super.execute(mapping, form, request, response);

		ActionErrors errors = new ActionErrors();

		String refreshrate = Config.getProperty("refreshrate");
		String project = request.getParameter("project");
		String logfile = null;

		// security checks
		if (!Project.exists(project)) {
			log.warn("project doesn't exist: " + project);
			errors.add("logfile", new ActionError("error.project.notfound", project));
		}

		if (errors.isEmpty()) {
			logfile = Config.getProperty("logs-dir") + "/" + project + ".log";
			log.debug(logfile);
			File f = new File(logfile);
			if (!f.isFile()) {
				log.warn("couldn't find file: " + logfile);
				errors.add("logfile", new ActionError("error.logfile.notfound", logfile));
			}
		}
		log.debug("errors: " + errors.size());
		saveErrors(request, errors);

		response.addHeader("Refresh", refreshrate);

		//request.setAttribute("refreshrate", refreshrate);
		if (errors.isEmpty())
			request.setAttribute("logfile", logfile);
		else
			request.setAttribute("logfile", null);

		return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);

	}

}
