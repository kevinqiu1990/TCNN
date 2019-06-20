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

import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;

/**
 * A rule which checks that a processing instruction with certain data is present.
 */
public class ProcessingInstructionRule implements SourceTypeRule
{
    protected String target;
    protected String data;

    public void configure(Configuration configuration) throws ConfigurationException
    {
        target = configuration.getAttribute("target");
        data = configuration.getAttribute("data", null);
    }

    public boolean matches(SourceInfo sourceInfo)
    {
        if (sourceInfo.hasProcessingInstruction(target))
        {
            if (sourceInfo.getProcessingInstructionData(target) == null && data == null)
                return true;
            if (sourceInfo.getProcessingInstructionData(target) != null && sourceInfo.getProcessingInstructionData(target).equals(data))
                return true;
        }
        return false;
    }

}
