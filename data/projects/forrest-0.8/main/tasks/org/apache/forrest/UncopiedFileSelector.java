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
package org.apache.forrest;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;

/**
 * Ant selector that selects files listed in an external text file.  
 * In the context of Forrest, the external text file lists "uncopied files"
 * from the Cocoon run, hence the name.
 */
public class UncopiedFileSelector extends BaseExtendSelector {

  public final static String CONFIG_KEY = "config";

  /** File listing files to copy. Typically /tmp/unprocessed-files.txt. */
  private String configFile = null;
  private boolean configRead = false;
  /** Processed list of files read from <code>configFile</code>. */
  private Set goodFiles = new HashSet();


  public UncopiedFileSelector() {
  }

  public String toString() {
    StringBuffer buf = new StringBuffer("{uncopiedfileselector config: ");
    buf.append(configFile);
    buf.append("}");
    return buf.toString();
  }

  public void setConfigFile(String conf) {
    this.configFile = conf;
  }

  /** Process the config file, creating a Set of file names */
  private void readConfig() throws BuildException {
    if (configRead) return;

    verifySettings();
    File confFile = new File(this.configFile);
    try {
      BufferedReader br = new BufferedReader(new FileReader(confFile));
      String line=null;
      while ( (line = br.readLine()) != null) {
        // Ignore odd lines.  Xalan has an annoying habit of writing XML
        // declarations in the middle of the file.
        if (! (line.charAt(0) == ' ' || line.charAt(0) == '<') ) {
          if (! goodFiles.contains(line)) {
            goodFiles.add(line);
          }
        }
      }
    } catch (FileNotFoundException e) {
      throw new BuildException("Couldn't find config file "+this.configFile);
    } catch (IOException ioe) {
      throw new BuildException("Error reading config file "+this.configFile);
    }
    configRead = true;
  }

  /**
   * When using this as a custom selector, this method will be called.
   * It translates each parameter into the appropriate setXXX() call.
   *
   * @param parameters the complete set of parameters for this selector
   */
  public void setParameters(Parameter[] parameters) {
    super.setParameters(parameters);
    if (parameters != null) {
      for (int i = 0; i < parameters.length; i++) {
        String paramname = parameters[i].getName();
        if (CONFIG_KEY.equalsIgnoreCase(paramname)) {
          setConfigFile(parameters[i].getValue());
        }
        else {
          setError("Invalid parameter " + paramname);
        }
      }
    }
  }

  /**
   * Checks to make sure all settings are kosher. In this case, it
   * means that the name attribute has been set.
   *
   */
  public void verifySettings() {
    if (configFile == null) {
      setError("The "+UncopiedFileSelector.CONFIG_KEY+" attribute is required");
    }
  }

  /**
   * The heart of the matter. This is where the selector gets to decide
   * on the inclusion of a file in a particular fileset.  Here we just check if
   * the file is listed in <code>goodFiles</code>.
   *
   * @param basedir the base directory the scan is being done from
   * @param filename is the name of the file to check
   * @param file is a java.io.File object the selector can use
   * @return whether the file should be selected or not
   */
  public boolean isSelected(File basedir, String filename, File file) {
    validate();
    readConfig();
    return goodFiles.contains(filename);
  }
}
