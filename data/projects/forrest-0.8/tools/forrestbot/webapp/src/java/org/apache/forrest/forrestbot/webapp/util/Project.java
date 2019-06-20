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
 * Created on Feb 10, 2004
 */
package org.apache.forrest.forrestbot.webapp.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;

import org.apache.forrest.forrestbot.webapp.Constants;
import org.apache.forrest.forrestbot.webapp.Config;
import org.apache.forrest.forrestbot.webapp.dto.ProjectDTO;
import org.apache.log4j.Logger;

import com.opensymphony.user.Group;
import com.opensymphony.user.UserManager;

public class Project {
	protected ProjectDTO dto;
	private static Logger log = Logger.getLogger(Project.class);

	private String logfile = null;

	public Project() {
		this(new ProjectDTO());
	}
	public Project(ProjectDTO dto) {
		this.dto = dto;
	}
	public ProjectDTO asDTO() {
		return dto;
	}

	public void loadData() {
		dto.setLastBuilt(getLastBuilt());
		dto.setUrl(getUrl());
		dto.setLogUrl(getLogUrl());
		dto.setStatus(getStatus());
		dto.setLogged(isLogged());
	}

	public void loadSecurity(String user) {
		dto.setBuildable(isBuildable(user));
		dto.setDeployable(isDeployable(user));
	}

	private boolean isBuildable(String user) {
		UserManager userManager = UserManager.getInstance();
		try {
			for (Iterator i = userManager.getGroups().iterator(); i.hasNext();) {
				Group g = (Group) i.next();
				if (g.containsUser(dto.getName()) && g.containsUser(user))
					return true;
			}
		} catch (Exception e) {
			log.warn("error while checking if " + user + " has access to build " + dto.getName(), e);
		}
		
		return false;
	}

	private boolean isDeployable(String user) {
		// for now we don't need to seperate deployable and buildable security
		return isBuildable(user);
	}

	private boolean isLogged() {
		return new File(getLogFile()).isFile();
	}
	
	private String getLogFile() {
		if (logfile == null) {
			logfile = Config.getProperty("logs-dir") + "/" + dto.getName() + ".log";
		}
		return logfile;
	}

	private Date getLastBuilt() {
		File f = new File(getLogFile());
		long lm = f.lastModified();
		if (lm == 0)
			return null;
		else
			return new Date(lm);
	}

	private String getUrl() {
		return Config.getProperty("build-url") + "/" + dto.getName() + "/";
	}

	private String getLogUrl() {
		return Config.getProperty("logs-url") + "/" + dto.getName() + ".log";
	}

	private int getStatus() {
		RandomAccessFile f;
		try {
			f = new RandomAccessFile(getLogFile(), "r");
		} catch (FileNotFoundException e) {
			log.debug("couldn't find log file for: " + getLogFile());
			return Constants.STATUS_UNKNOWN;
		}

		byte[] checkSuccess = new byte[Constants.BUILD_SUCCESS_STRING.length()];
        // try for 2-byte eol
		try {
			f.seek((int) f.length() - checkSuccess.length - 2);
			f.read(checkSuccess, 0, checkSuccess.length);
		} catch (IOException e1) {
			log.debug("couldn't find seek in log file: " + f.toString());
			return Constants.STATUS_UNKNOWN;
		}
		if (Constants.BUILD_SUCCESS_STRING.equals(new String(checkSuccess)))
			return Constants.STATUS_SUCCESS;
        // try for 1-byte eol
		try {
			f.seek((int) f.length() - checkSuccess.length - 1);
			f.read(checkSuccess, 0, checkSuccess.length);
		} catch (IOException e1) {
			log.debug("couldn't find seek in log file: " + f.toString());
			return Constants.STATUS_UNKNOWN;
		}
		if (Constants.BUILD_SUCCESS_STRING.equals(new String(checkSuccess)))
			return Constants.STATUS_SUCCESS;
        
        
        // if date is in last minute, consider it still running
		if (getLastBuilt().getTime() > (new Date()).getTime() - 60 * 1000)
			return Constants.STATUS_RUNNING;
        
        // default
		return Constants.STATUS_FAILED;
	}

	/**
	 * @return Collection of type ProjectDTO
	 */
	public static Collection getAllProjects() {

		/* based on config files */
		ArrayList sites = new ArrayList();
		File f = new File(Config.getProperty("config-dir"));
		File[] possibleSites = f.listFiles();
		for (int i = 0; i < possibleSites.length; i++) {
			if (possibleSites[i].isFile()) {
				String name = possibleSites[i].getName();
				if (name.endsWith(".xml")) {
					ProjectDTO projectDTO = new ProjectDTO();
					projectDTO.setName(name.substring(0, name.length() - 4));
					(new Project(projectDTO)).loadData();
					sites.add(projectDTO);
				}
			}
		}
		Collections.sort(sites);
		return sites;
	}


	public static boolean exists(String project) {
		Collection c = getAllProjects();
		for (Iterator i = c.iterator(); i.hasNext();) {
			if (((ProjectDTO)i.next()).getName().equals(project)) {
				return true;
			}
		}
		return false;
	}
}
