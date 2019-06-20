             Upgrading Forrest's Cocoon
             --------------------------

This directory contains files to help upgrade Cocoon to whatever is the latest
stable version of Cocoon trunk.

Note: We are not up-to-date with the latest Cocoon trunk.
See http://forrest.apache.org/docs_0_80/upgrading_08.html#cocoon

FIXME: Latest Cocoon uses Maven, so this instructions needs to get updated.
http://cocoon.zones.apache.org/daisy/documentation/g2/756.html

Instructions for use:

try this command to install:
mvn -Dmaven.test.skip=true install


NOTE:
Make sure that you have set $COCOON_HOME like e.g.:
export COCOON_HOME=/home/me/apache/cocoon-trunk/
and do a 'build clean' there.

-------------------------
0. cd $FORREST_HOME/etc/cocoon_upgrade

1. Keep our local.*.properties files sychronised with Cocoon's.

Step 2 and 3 can be done with "./build.sh 0"
2. Copy the cocoon libraries to forrest.
   See ./build.xml where some are excluded. You might need to add/exclude others.
   Remember that things will change with Cocoon and we must keep in sync.

    ant copy-core-libs
    ant copy-endorsed-libs
    ant copy-optional-libs

3. Verify that there are not two versions of libraries within the same directory:

   cd $FORREST_HOME/lib/endorsed
   svn st
   cd $FORREST_HOME/lib/core
   svn st

4. cd $FORREST_HOME/etc/cocoon_upgrade

Steps 5 and 6 can be done with "./build.sh 1" it will create an ant property file,
so you do not need to edit the build.xml.

5. Edit build.xml and modify new revision
(FIXME: we don't need svn.revision anymore, so probably don't need ./build.sh either)
   Then build cocoon:

   ant build-cocoon

6. cd $FORREST_HOME/lib

(FIXME: we don't need this 7a anymore.)
7a. For each cocoon-{name}-{cocoon.version}-{cocoon.revision}.jar

svn mv cocoon-{name}-{cocoon.version}-{cocoon.OLDrevision}.jar 
cocoon-{name}-{cocoon.version}-{cocoon.NEWrevision}.jar
 
svn ci -m "prework for upgrade to {cocoon.NEWrevision}" 

7b.  ant copy-cocoon

8.  We need to make sure there is a license.txt file for each of the
    jars that we have in the lib/* directories.

    svn status | grep '^!' | grep 'license.txt'

    If the removed license.txt file listed above matches a jar
    that we have, then revert the deletetion by doing an

      svn revert some.jar.license.txt

    Otherwise, copy the relevant license.txt file from $COCOON_HOME/legal.

9.  Keep our Cocoon config files and sitemaps synchronised at main/webapp/WEB-INF/

10. cd $FORREST_HOME/main

11. Build a regular forrest distribution and test, test test.

    At least do a 'build test'.

    The testing should consist of doing a "forrest site", "forrest run"
    and "forrest war" against existing forrest projects and also against
    new "forrest seed" sites.

12. Now do 'svn commit' for the changed/new files in forrest/lib
    and use the Cocoon SVN revision number in your log message.

------------------------------------------------------------------------
Cleanup

* There will be a new local.blocks.properties over in your cocoon-trunk
Remove it to continue developing with Cocoon.

