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


XXE Forrest Config
==================

NOTE: This is not a particular endorsement of XXE over other xml editors.
      It is just that we provide this tool to take advantage of XXE.

XMLmind XML Editor is a validating XML editor featuring a word processor-like
view. We support the Forrest plugin for XXE only, please direct all XXE-related
questions to XXE support or mailing lists.


Requirements:
=============
* XXE 3.0p1+ (version 1.3 of the tool works with XXE version 2.5p3 - 3.0)
* Forrest 0.5+


Upgrading
=========
* Delete the 'forrest' directory from the XXE application config directory (e.g. D:\Program Files\XMLmind_XML_Editor\config)
  OR
  Delete the 'forrest' directory from your user XXE config directory:
    * *nix-es: ~/.xxe/addon/
    * Windows: %SystemDrive%\Documents and Settings\user\Application Data\XMLmind\XMLeditor\
  depending on where you installed the previous version of the tool
* Install normally


Installing
==========

* Extract into the XXE application config directory (e.g. D:\Program Files\XMLmind_XML_Editor\config)
  OR
* Extract into your XXE user directory (e.g. ~/.xxe/addon/config) (only for version 1.3+ of this config)
  For version 1.3+ of this tool, this is the recommended installation location, as it permits upgrading XXE without having to reinstall the tool
  NOTE: This location is new for XXE 2.10, and is not tested with earlier releases!


Developer Instructions
======================
To build the configuration:
* set the FORREST_HOME environment variable
* run 'ant' in this directory

To work directly with the SVN version, check out
http://svn.apache.org/repos/asf/forrest/trunk/tools/xxe/ into the 'forrest'
folder in the XXE 'addon' folder. Run the build there to copy the DTDs


History
=======

1.4:
----
- Updated the tool to work with XXE 3.0p1 (FOR-779).
  NOTE: This change is backwards INCOMPATIBLE, therefore the tool now requires XXE 3.0p1+
- Added XXE-provided default rendering of tables

1.3:
----
- Fixed a bug that prevented this config to work with XXE 3.x (FOR-720)
- Fixed a bug that prevented correct loading of the common css stylesheet (FOR-581)
- Changed icon references to be installation independent (FOR-581)
- Added a Forrest menu, with more robust table manipulation, and for v2 docs some link traversals (both taken from the XXE XHTML config)
- Added more entries to the Table button (menu) in the Forrest toolbar, replicating the entries in the Forrest menu
- Added a History section to the README and documentation

References
==========
XMLmind XML Editor
    http://www.xmlmind.com/xmleditor/
Apache Forrest
    http://forrest.apache.org/
Instructions for other Forrest XML Editors
    http://forrest.apache.org/docs/catalog.html
XXE Custom Configuration Info
    http://www.xmlmind.com/xmleditor/_distrib/doc/configure/index.html