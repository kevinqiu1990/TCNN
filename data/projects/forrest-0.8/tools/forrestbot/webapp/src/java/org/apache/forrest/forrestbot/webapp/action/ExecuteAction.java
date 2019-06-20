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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.forrest.forrestbot.webapp.Constants;
import org.apache.forrest.forrestbot.webapp.util.Project;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionError;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.forrest.forrestbot.webapp.util.Executor;

public final class ExecuteAction extends BaseAction {
	private static Logger log = Logger.getLogger(ExecuteAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		super.execute(mapping, form, request, response);
		
		ActionErrors errors = new ActionErrors();

		String project = (String) PropertyUtils.getSimpleProperty(form, "project");
		String build = (String) PropertyUtils.getSimpleProperty(form, "build");
		String deploy = (String) PropertyUtils.getSimpleProperty(form, "deploy");

		request.setAttribute("project", project);

		if (!checkAuthorized(request, response))
			return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);

		if (!Project.exists(project)) {
			log.warn("project doesn't exist: " + project);
			errors.add("execute", new ActionError("error.project.notfound", project));
			saveErrors(request, errors);
			return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);
		}
		
		Project p = new Project();
		p.asDTO().setName(project);
		p.loadData();
		p.loadSecurity((String) request.getSession(true).getAttribute("username"));
		if (p.asDTO().getStatus() == Constants.STATUS_RUNNING) {
			log.warn("can't execute " + project + " while still running");
			errors.add("execute", new ActionError("error.project.stillrunning", project));
			saveErrors(request, errors);
			return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);
		}

		if (build != null && !build.equals("")) {
			if (p.asDTO().isBuildable()) {
				try {
					Executor.build(project);
				} catch (Exception e) {
					log.warn("couldn't build " + project, e);
					errors.add("execute", new ActionError("error.build", project));
				}
			} else {
				errors.add("execute", new ActionError("error.authorization"));
			}
		} else if (deploy != null && !deploy.equals("")) {
			if (p.asDTO().isDeployable()) {
				try {
					Executor.deploy(project);
				} catch (Exception e) {
					log.warn("couldn't deploy " + project, e);
					errors.add("execute", new ActionError("error.deploy", project));
				}
			} else {
				errors.add("execute", new ActionError("error.authorization"));
			}
		}
		saveErrors(request, errors);
		return mapping.findForward(Constants.FORWARD_NAME_SUCCESS);

	}
}
