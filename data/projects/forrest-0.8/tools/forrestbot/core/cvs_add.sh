#!/bin/bash
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

function log() {
  echo "%% $@"
}

function addfiles()
{
  log "addfiles '$@'"
  local TXTFILES
  local BINFILES
  local DIRS
  for i in $@; do
    #echo "Processing $i.."
    if [ -d "$i" ]; then
      log "Directory: $i"
      DIRS="$DIRS $i"
      continue
    fi
    local MIME=`file -bi $i 2>/dev/null`
    unset istext
    log $MIME | grep text > /dev/null && istext="yes"
    if [ "$istext" = "yes" ]; then
      log "Adding as TEXT ($MIME): $i"
      TXTFILES="$TXTFILES $i"
    else
      log "Adding as BINARY ($MIME): $i"
      BINFILES="$BINFILES $i"
    fi
  done
  [ ! -z "$TXTFILES" ] && cvs add $TXTFILES
  [ ! -z "$BINFILES" ] && cvs add -kb $BINFILES
  if [ ! -z "$DIRS" ]; then
    log "Processing dirs $DIRS"
    for d in $DIRS; do
      log "Processing dir $d"
      unset newfiles ; newfiles=`find $d -type f -not -path "*CVS*"`
      unset newdirs ; newdirs=`find $d -type d -not -name "CVS" | tr '\n' ' '`
      log "  dirs: '$newdirs'"
      log "  files: '$files'"
      cvs add $newdirs
      addfiles $newfiles
    done
  fi
  unset TXTFILES BINFILES DIRS
}

NEW_FILES=`cvs up | grep '^\?' | cut -d\  -f 2`
log "Adding new files to CVS: $NEW_FILES"
[ ! -z "$NEW_FILES" ] && addfiles $NEW_FILES
