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
 * Created on Mar 9, 2004
 */
package org.apache.forrest.forrestbot.webapp.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.forrest.forrestbot.webapp.Config;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;

// based on class from http://www.javaworld.com/javaworld/jw-12-2000/jw-1229-traps.html
class StreamGobbler extends Thread {
	private InputStream is;
	private Priority type;
	private Logger log;
	private boolean debug;


	StreamGobbler(InputStream is, Priority type) {
		this.is = is;
		this.type = type;
		log = Logger.getLogger(Executor.class + " " + type.toString());
		debug = Boolean.valueOf(Config.getProperty("debug-exec")).booleanValue();
	}

	// we have to read from the buffer whether we're going to debug or not; on some systems things will freeze up if the output isn't read
	public void run() {
        BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(is));
			String line = null;
			while ((line = br.readLine()) != null) {
				if (debug)
					log.log(type, line);
			}
		} catch (IOException ioe) {
			log.error("error reading from process", ioe);
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException ioe2) {
					log.error("couldn't cleanup after process IO exception", ioe2);
				}
			}
		}
	}
}

class ExecutorThread extends Thread {
	private Process proc;
	private Logger log;

	public ExecutorThread(String id, Process p) {
		super(id);
		proc = p;
		log = Logger.getLogger(Executor.class);
	}

	public void run() {
        StreamGobbler errorGobbler = new StreamGobbler(proc.getErrorStream(), Priority.ERROR);
        errorGobbler.start();
		StreamGobbler outputGobbler = new StreamGobbler(proc.getInputStream(), Priority.DEBUG);
		outputGobbler.start();
		
		try {
			proc.getInputStream().close();
			proc.getErrorStream().close();
			proc.getOutputStream().close();
		} catch (IOException ioe) {
			log.error("couldn't close process's input/output streams", ioe);
		}
	}

}

public class Executor {
	private static Logger log = Logger.getLogger(Executor.class);

	private static void run(String target, String project) throws IOException {
		String command = Config.getProperty("forrest-exec") 
		 + " -Dforrest.jvmargs=-Djava.awt.headless=true -f " + project + ".xml " + target;
		File workingDir = new File(Config.getProperty("config-dir"));

		Runtime rt = Runtime.getRuntime();
		Process proc = rt.exec(command, null, workingDir);
		ExecutorThread execThread = new ExecutorThread(project, proc);
		log.info("Executing command: " + command + " in " + workingDir);
		execThread.start();
		// don't wait for it to finish
	}

	public static void build(String project) throws IOException {
		run(Config.getProperty("targets.build"), project);

	}

	public static void deploy(String project) throws IOException {
		run(Config.getProperty("targets.deploy"), project);
	}

}
