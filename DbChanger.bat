:: Name: DBChanger
:: Author: Nathaniel Faries
:: Purpose: Provide an easy way to switch DBs pointed to by the local version of forms.
:: Revisions: Initial version - 17/11/2017

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0

:: DB to use
SET db=%1
SET server=%2 ::if this is empty, assume no change to server

:: Paths to the config files. Hardcoded for now
SET webConfig=src/E-Forms/Web.config
SET webConfigTemplate=src/E-Forms/Web.template.config
SET appConfig=src/RoutingEngineServiceLib/App.config
SET debugConfig=src/RoutingEngineServiceHost/RoutingEngineServiceHost.exe.debug.config


