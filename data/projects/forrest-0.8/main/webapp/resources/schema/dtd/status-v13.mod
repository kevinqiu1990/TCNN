<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!-- ===================================================================

     Apache Status DTD (Version 1.3)

PURPOSE:
  This DTD was developed to be able to validate and guide the writing
  of the status.xml file. It merely includes the Changes DTD and Todo DTD,
  with some wrapper elements to cover the status.xml structure.

TYPICAL INVOCATION:

  <!DOCTYPE status PUBLIC
       "-//APACHE//DTD Status Vx.y//EN"
       "status-vxy.dtd">

  where

    x := major version
    y := minor version

==================================================================== -->

<!-- =============================================================== -->
<!-- Document Type Definition -->
<!-- =============================================================== -->
<!ELEMENT status (developers, contexts?, changes, todo)>

<!ELEMENT developers (person+)>
<!ATTLIST developers %common.att;>

<!ELEMENT contexts (context+)>
<!ELEMENT context EMPTY>
<!ATTLIST context %common-idreq.att;
                  %title.att;>

<!-- =============================================================== -->
<!-- End of DTD -->
<!-- =============================================================== -->
