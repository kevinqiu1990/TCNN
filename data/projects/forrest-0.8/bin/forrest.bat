@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

if "%OS%"=="Windows_NT" @setlocal
if "%OS%"=="WINNT" @setlocal

rem ----- use the location of this script to infer $FORREST_HOME -------
if NOT "%OS%"=="Windows_NT" set DEFAULT_FORREST_HOME=..
if "%OS%"=="Windows_NT" set DEFAULT_FORREST_HOME=%~dp0\..
if "%OS%"=="WINNT" set DEFAULT_FORREST_HOME=%~dp0\..
if "%FORREST_HOME%"=="" set FORREST_HOME=%DEFAULT_FORREST_HOME%

rem ----- set the current working dir as the PROJECT_HOME variable  ----
if NOT "%OS%"=="Windows_NT" call "%FORREST_HOME%\bin\setpwdvar98.bat"
if "%OS%"=="Windows_NT" call "%FORREST_HOME%\bin\setpwdvar.bat"
if "%OS%"=="WINNT" call "%FORREST_HOME%\bin\setpwdvar.bat"
set PROJECT_HOME=%PWD%

rem ----- set the ant file to use --------------------------------------
set ANTFILE=%FORREST_HOME%\main\forrest.build.xml

rem ----- Save old ANT_HOME --------------------------------------------
set OLD_ANT_HOME=%ANT_HOME%
set ANT_HOME=%FORREST_HOME%\tools\ant

rem ----- Save and set CLASSPATH --------------------------------------------
set OLD_CLASSPATH=%CLASSPATH%
set CLASSPATH=
cd /d "%FORREST_HOME%\lib\endorsed\"
for %%i in ("*.jar") do call "%FORREST_HOME%\bin\appendcp.bat" "%FORREST_HOME%\lib\endorsed\%%i"
cd /d %PWD%

echo.
echo Apache Forrest.  Run 'forrest -projecthelp' to list options
echo.
rem ----- call ant.. ---------------------------------------------------
echo.
call "%ANT_HOME%\bin\forrestant" -buildfile "%ANTFILE%" -Dbasedir="%PROJECT_HOME%" -emacs -logger org.apache.tools.ant.NoBannerLogger %1 %2 %3 %4 %5 %6 %7 %8 %9

rem ---- Restore old ANT_HOME
set ANT_HOME=%OLD_ANT_HOME%
set CLASSPATH=%OLD_CLASSPATH%
