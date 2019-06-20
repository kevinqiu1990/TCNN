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
package org.apache.forrest.sourcetype;

import org.apache.avalon.framework.configuration.*;

import java.util.*;

/**
 * Represents a sourcetype. A sourcetype has a name and a number of rules
 * which are used to determine if a certain document is of this sourcetype.
 */
public class SourceType implements Configurable
{
    protected List rules = new ArrayList();
    protected String name;

    public void configure(Configuration configuration) throws ConfigurationException
    {
        name = configuration.getAttribute("name");

        Configuration[] ruleConfs = configuration.getChildren();
        for (int i = 0; i < ruleConfs.length; i++)
        {
            SourceTypeRule rule;
            if (ruleConfs[i].getName().equals("document-declaration"))
                rule = new DocDeclRule();
            else if (ruleConfs[i].getName().equals("processing-instruction"))
                rule = new ProcessingInstructionRule();
            else if (ruleConfs[i].getName().equals("w3c-xml-schema"))
                rule = new XmlSchemaRule();
            else if (ruleConfs[i].getName().equals("document-element"))
                rule = new DocumentElementRule();
            else
                throw new ConfigurationException("Unsupported element " + ruleConfs[i].getName() + " at "
                        + ruleConfs[i].getLocation());

            rule.configure(ruleConfs[i]);
            rules.add(rule);
        }
    }

    public boolean matches(SourceInfo sourceInfo)
    {
        Iterator rulesIt = rules.iterator();
        boolean matches = true;
        while (rulesIt.hasNext())
        {
            SourceTypeRule rule = (SourceTypeRule)rulesIt.next();
            matches = matches && rule.matches(sourceInfo);
            if (!matches)
                return false;
        }
        return matches;
    }

    public String getName()
    {
        return name;
    }
}
