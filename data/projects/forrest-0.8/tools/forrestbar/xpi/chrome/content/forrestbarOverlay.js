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

var dispatcherCall=false;

function setDispatcherCall(xBoolean) {
  dispatcherCall=(xBoolean)?true:false;
}

function startforrestbar()
{
  //alert("function init");
  if(document.getElementById("forrestbar").getAttribute("hidden") == "false")
  {
    removeEventListener ("load",startforrestbar, true); // Keep the event from firing a hundred more times.
  }
  setLocalHostMenuItemLabel();
}

function setLocalHostMenuItemLabel()
{
  document.getElementById("forrest.run.menuitem").label="Local Forrest (" + getLocalWebServer() + ")";
}

addEventListener("load", startforrestbar, true); // Run the startup function when the window loads

function navigate(url) {
  window._content.document.location.href = url;
}


/**************************/

function search(searchID)
{
  searchDev('aims', searchID);
}

function searchDev(engine, searchID)
{
  var searchItem = document.getElementById(searchID);
  if (engine == 'aims') {
    navigate('http://marc.theaimsgroup.com/?l=forrest-dev&w=2&r=1&q=b&s=' + searchItem.value);
  } else if (engine == 'gmane') {
    navigate('http://search.gmane.org/?group=gmane.text.xml.forrest.devel&sort=date&query=' + searchItem.value);
  } else {
    navigate('http://www.mail-archive.com/cgi-bin/htsearch?method=and&format=short&config=dev_forrest_apache_org&restrict=&exclude=&words=' + searchItem.value);
  }
}

function searchUser(engine, searchID)
{
  var searchItem = document.getElementById(searchID);
  if (engine == 'gmane') {
    navigate('http://search.gmane.org/?group=gmane.text.xml.forrest.user&sort=date&query=' + searchItem.value);
  } else {
    navigate('http://www.mail-archive.com/cgi-bin/htsearch?method=and&format=short&config=user_forrest_apache_org&restrict=&exclude=&words=' + searchItem.value);
  }
}

function searchCommits(engine, searchID)
{
  var searchItem = document.getElementById(searchID);
  if (engine == 'gmane') {
    navigate('http://search.gmane.org/?group=gmane.text.xml.forrest.cvs&sort=date&query=' + searchItem.value);
  } else {
    navigate('http://www.mail-archive.com/cgi-bin/htsearch?method=and&format=short&config=svn_forrest_apache_org&restrict=&exclude=&words=' + searchItem.value);
  }
}

function searchIssue(searchID)
{
  var searchItem = document.getElementById(searchID);
  navigate('http://issues.apache.org/jira/secure/QuickSearch.jspa?pid=12310000&searchString=' + searchItem.value);
}

function searchSite(searchID)
{
  var searchItem = document.getElementById(searchID);
  navigate('http://www.google.com/search?sitesearch=forrest.apache.org&q=' + searchItem.value +'&Search=Search');
}

function searchSVN(searchID)
{
  var searchedRev = document.getElementById(searchID);
  navigate('http://svn.apache.org/viewvc?view=rev&revision=' + searchedRev.value );
}

function contract(subUrl,searchID)
{
  if( isLocalUrlOrWarnMe() )
  {
    var searchItem = document.getElementById(searchID);
    navigate(getLocalWebServerUrl() + subUrl + searchItem.value);
  }
}

function navProject(searchID) {
  var searchItem = document.getElementById(searchID);
  navigate(searchItem.selectedItem.value);
}

function viewXML(xmltype)
{
  var href = gBrowser.currentURI.spec;
  if( isLocalUrlOrWarnMe() )
  {
    (dispatcherCall)?navigate(getLocalWebServerUrl()+xmltype+href.substring(getLocalWebServerUrl().length, href.lastIndexOf('.') )):navigate(href.substring(0, href.lastIndexOf('.') ) + xmltype);
  }
}

function isLocalUrl ()
{
  var href = gBrowser.currentURI.spec;

  return( (typeof(href) != 'undefined') &&
          (href.substr) &&
          (startsWith(href, getLocalWebServerUrl() ))
        );
}

function isLocalUrlOrWarnMe()
{
  var isIt = isLocalUrl();
  if( ! isIt )
  {
    alert("This action is only available on Local Forrest (jetty) site...");
  }
  return isIt;
}

function startsWith(st, pref)
{
  return( (pref.length > 0) && (st.substring(0, pref.length) == pref) );
}

/* ----------- */
/* Forrest Run */
/* ----------- */
function navigateForrestRun() {
  navigate( getLocalWebServerUrl() );
}

function getLocalWebServer() {
  var localhost= getForrestRunHost() + ":" + getForrestRunPort() ;
  return localhost;
}

function getLocalWebServerUrl() {
  var Url= "http://" + getLocalWebServer() + "/" ;
  return Url;
}

/* ----------------- */
/* Options functions */
/* ----------------- */

/* Getting preferences */
function getForrestRunHost()
{
  var prefservice = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
  var prefs = prefservice.getBranch("");

  var forrestHost = null;
  if (prefs.getPrefType("forrestbar.run.host") == prefs.PREF_STRING)
  {
    forrestHost = prefs.getCharPref("forrestbar.run.host");
  }
  if ((forrestHost == null) || (forrestHost.length = 0))
  {
     forrestHost='localhost';
  }
  return forrestHost;
}

function getForrestRunPort()
{
  var prefservice = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService);
  var prefs = prefservice.getBranch("");

  var forrestPort = null;
  if (prefs.getPrefType("forrestbar.run.port") == prefs.PREF_STRING)
  {
    forrestPort = prefs.getCharPref("forrestbar.run.port");
  }
  if ((forrestPort == null) || (forrestPort.length = 0))
  {
     forrestPort='8888';
  }
  return forrestPort;
}

/* Initialising Options Panel */
function initForrestBarOptions()
{
  document.getElementById('forrestbar.run.host').value = getForrestRunHost();
  document.getElementById('forrestbar.run.port').value = getForrestRunPort();
}

/* recording Options in prefs */
function setForrestBarOptions()
{
  var prefService = Components.classes["@mozilla.org/preferences-service;1"]
                    .getService(Components.interfaces.nsIPrefService);
  var prefs = prefService.getBranch("");

  var oldHost=getForrestRunHost();
  var oldPort=getForrestRunPort();
  var newHost=document.getElementById('forrestbar.run.host').value;
  var newPort=document.getElementById('forrestbar.run.port').value;
  var change=false;

  if( oldHost != newHost )
  {
    change=true;
    prefs.setCharPref("forrestbar.run.host", newHost);
  }
  if( oldPort != newPort )
  {
    change=true;
    prefs.setCharPref("forrestbar.run.port", newPort);
  }
  if( change )
    alert("Warning! the label of the Local Forrest item will be refreshed at the next start of your browser...");

  window.close();
}

