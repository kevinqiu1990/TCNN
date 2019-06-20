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
package org.apache.forrest.log;

import org.apache.avalon.framework.context.Context;
import org.apache.avalon.framework.context.ContextException;
import org.apache.avalon.framework.context.DefaultContext;
import org.apache.cocoon.util.log.CocoonTargetFactory;
import org.apache.forrest.conf.ForrestConfUtils;
/**
 * CocoonTargetFactory that uses the project build dir for normal Forrest processing.
 *
 * <p>The syntax of "format" is the same as in <code>CocoonTargetFactory</code>.</p>
 */
public class ForrestLogTargetFactory
    extends CocoonTargetFactory {
        
    /**
     * Get the Context object
     */
    public void contextualize( Context context )
        throws ContextException
    {
        Context currentContext = context;
        
        try {
            String projectHome = ForrestConfUtils.getProjectHome();

            if(!projectHome.startsWith(ForrestConfUtils.defaultHome)){
                DefaultContext newContext = new DefaultContext(context);
                newContext.put("context-root",projectHome + "/build/webapp");
                currentContext = newContext;
            }
        } catch (Exception e) {
            throw new ContextException("Error getting forrest.home java property.",e);
        }
        super.contextualize( currentContext );
    }
}
