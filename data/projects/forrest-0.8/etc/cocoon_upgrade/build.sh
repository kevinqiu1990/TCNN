#!/bin/sh
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

help()
{
  cat <<HELP
*********************************************************
This script should help you to update cocoon for forrest.
*********************************************************
NOTE: 
Please read README.txt *before* using this script. 
###################################################
It is divided in multiple steps because you need to control the outcome of the script manually. Read the README.txt

Usage:
./build.sh -h -> shows this help
./build.sh 0 -> execute the first step of this script
HELP
  exit 0
}
error()
{
cat<<ERROR
error: 
Please use ./build.sh -h to see the help. You have to provide the step you want to execute. Like ./build.sh -s 0
ERROR
}
svnDialog()
{
  cd  $FORREST_HOME/lib
  cat<<CONTROL
***************    
svn st - Output
***************
CONTROL
  svn st
  cat<<CONTROL
*****************************    
Please check the above output. 
******************************
Verify that there are not two versions of libraries within the same directory. If you see "?" that means you need to resolve by hand. Start with:

cd $FORREST_HOME/lib;svn st

#################################
Follow README.txt for next steps
#################################

CONTROL
}
step=
[ -z "$1" ] && help
[ "$1" = "-h" ] && help
step=$1

cd $FORREST_HOME/etc/cocoon_upgrade
if [ -z $step ]; then
	echo no step
  error
else
  echo Trying to execute step $step
  if [ "$step" = "0" ]; then
    ant copy-core-libs
    ant copy-endorsed-libs
    ant copy-optional-libs
    svnDialog
  elif [ "$step" = "1" ]; then
     cd $COCOON_HOME;svn info|grep Revision|awk '{print "echo svn.revision=-r"$2" > $FORREST_HOME/etc/cocoon_upgrade/revision.properties"}'|sh
     cd $FORREST_HOME/etc/cocoon_upgrade/
     ant build-cocoon
     ln -s $COCOON_HOME/build/cocoon/ $COCOON_HOME/build/cocoon-2.2.0-dev
     svnDialog
  else
    echo step $step not found
    error
  fi
fi

