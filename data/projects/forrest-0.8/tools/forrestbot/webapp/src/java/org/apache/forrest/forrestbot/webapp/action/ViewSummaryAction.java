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

import java.util.Collection;
import java.util.Date;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.forrest.forrestbot.webapp.Constants;
import org.apache.forrest.forrestbot.webapp.dto.ProjectDTO;
import org.apache.forrest.forrestbot.webapp.util.Project;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.opensymphony.user.EntityNotFoundException;
import com.opensymphony.user.UserManager;

public final class ViewSummaryAction extends BaseAction {
	private static Logger log = Logger.getLogger(ViewSummaryAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		super.execute(mapping, form, request, response);

		if (form != null && !PropertyUtils.getSimpleProperty(form, "submit").equals("unsubmitted")) {
			ActionErrors errors = form.validate(mapping, request);

			String username = (String) PropertyUtils.getSimpleProperty(form, "username");
			String password = (String) PropertyUtils.getSimpleProperty(form, "password");

			request.setAttribute("username", username);
			

			UserManager userManager = UserManager.getInstance();

			boolean validPassword = false;
			try {
				validPassword = userManager.getUser(username).authenticate(password);
			} catch (EntityNotFoundException e) {
				validPassword = false;
			}
			if (!validPassword) {
				log.debug("bad password");
				errors.add("password", new ActionError("error.authentication"));
				saveErrors(request, errors);
			} else {
				log.debug("authenticated");
				request.getSession(true).setAttribute("auth", Boolean.TRUE);
				request.getSession(true).setAttribute("username", username);
			}
		}

		request.setAttribute("serverTime", new Date());

		if (checkAuthorized(request, response, false)) {
			// set access for each project
			String currentUser = (String) request.getSession(true).getAttribute("username");
			Collection projects = Project.getAllProjects();
			for (Iterator i = projects.iterator(); i.hasNext();) {
				ProjectDTO projectDTO = (ProjectDTO)i.next();
				(new Project(projectDTO)).loadSecurity(currentUser);
			}
			request.setAttribute("projects", projects);
			
			return mapping.findForward(Constants.FORWARD_NAME_AUTHORIZED);
		}
		
		request.setAttribute("projects", Project.getAllProjects());
		return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);

	}
}
