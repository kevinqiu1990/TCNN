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
package org.apache.forrest.conf;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import org.apache.commons.lang.StringUtils;

/**
 * Class for accessing properties in a properties file roughly compatible with
 * Ant property files, where ${name} is replaced with the value of the property
 * if declared beforehand.
 */
public class AntProperties extends Properties
{

    public AntProperties() {
        super();
    }

    public AntProperties(Properties arg0) {
        super(arg0);
        putAllProperties(arg0);
    }

    public synchronized void load(InputStream arg0) throws IOException {
        super.load(arg0);

        BufferedReader in = null;
        try {

            in = new BufferedReader(new InputStreamReader(arg0));

            String currentLine, name, value;
            int splitIndex;

            while ((currentLine = in.readLine()) != null) {
                // # == comment
                if (!currentLine.startsWith("#")
                                && !(currentLine.trim().length() == 0)) {
                    splitIndex = currentLine.indexOf('=');
                    name = currentLine.substring(0, splitIndex).trim();
                    value = currentLine.substring(splitIndex + 1).trim();
                    this.put(name, value);
                }
            }
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {}
            }
        }
    }

    public synchronized Object put(Object name, Object value) {
        //if the property is already there don't overwrite, as in Ant
        //properties defined first take precedence
        if (!super.containsKey(name)) {
            Enumeration names = super.propertyNames();
            while (names.hasMoreElements()) {
                String currentName = (String) names.nextElement();
                String valueToSearchFor = "${" + currentName + "}";
                String valueToReplaceWith = (String) super.get(currentName);
                value = StringUtils.replace(value.toString(), valueToSearchFor,
                                valueToReplaceWith);
            }
            return super.put(name, value);
        }

        return null;
    }

    public synchronized void putAllProperties(Map arg0) {
        Iterator i = arg0.entrySet().iterator();
        while (i.hasNext()) {
            Map.Entry me = (Map.Entry)i.next();
            this.put(me.getKey(), me.getValue());
        }
    }

    public synchronized Object setProperty(String name, String value) {
        return this.put(name, value);
    }

    public String filter(String stringToFilter) {

        StringBuffer resultStringBuffer = new StringBuffer();

        StringTokenizer st = new StringTokenizer(stringToFilter, "@", true);

        STATE state;

        if (stringToFilter.startsWith("@")) {
            state = new STATE(STATE.START_TOKEN);
        } else {
            state = new STATE(STATE.STRING_NOT_TO_FILTER);
        }

        for (String currentToken; st.hasMoreTokens(); state.increment()) {

            currentToken = st.nextToken();

            if (state.isStringToFilter()) {
                resultStringBuffer.append(getProperty(currentToken, "@"
                                + currentToken + "@"));
            } else if (state.isStringNOTToFilter()) {
                resultStringBuffer.append(currentToken);
            }
        }

        return resultStringBuffer.toString();
    }

    private static class STATE
    {

        final static int STRING_NOT_TO_FILTER = 0;
        final static int START_TOKEN          = 1;
        final static int STRING_TO_FILTER     = 2;
        final static int END_TOKEN            = 3;

        private int      currentState;

        STATE(int startState) {
            this.currentState = startState;
        }

        void increment() {
            currentState++;
            if (currentState > 3) {
                currentState = 0;
            }

        }

        boolean isStringToFilter() {
            return (currentState == STRING_TO_FILTER);
        }

        boolean isStringNOTToFilter() {
            return (currentState == STRING_NOT_TO_FILTER);
        }
    }

}
