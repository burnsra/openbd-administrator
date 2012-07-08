<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com
	This file is part of the Open BlueDragon Administrator.
	The Open BlueDragon Administrator is free software: you can redistribute
	it and/or modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.
	The Open BlueDragon Administrator is distributed in the hope that it will
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.
	You should have received a copy of the GNU General Public License
	along with the Open BlueDragon Administrator.  If not, see
	<http://www.gnu.org/licenses/>.
	--->
<cfsilent>
	<cfscript>
		contextPath = getPageContext().getRequest().getContextPath();

		if (contextPath == "/") {
		    contextPath = "";
		}

		theSection = ListGetAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME, "/") - 1, "/");
		thePage = ListLast(CGI.SCRIPT_NAME, "/");
	</cfscript>
	<cfsetting showdebugoutput="false" />
</cfsilent>
<cfoutput>
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<title>Open BlueDragon Administrator</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
			<meta http-equiv="X-UA-Compatible" content="IE-edge">
			<link rel="shortcut icon" href="#contextPath#/bluedragon/administrator/images/favicon.ico" />
			<link rel="stylesheet" href="#contextPath#/bluedragon/administrator/css/bootstrap.min.css" type="text/css" />
      <style type="text/css">
        body {
          padding-top: 60px;
          padding-bottom: 40px;
        }
      </style>
			<!--- <script src="#contextPath#/bluedragon/administrator/js/jquery-1.6.4.min.js" type="text/javascript"></script> --->
			<!--- if scheduled tasks page include date picker --->
			<!--- <cfif thePage == "scheduledtasks.cfm">
				<link rel="stylesheet" type="text/css" href="#contextPath#/bluedragon/administrator/css/smoothness/jquery-ui-1.8.16.custom.css" />
				<script src="#contextPath#/bluedragon/administrator/js/jquery-ui-1.8.16.custom.min.js" type="text/javascript"></script> <script type="text/javascript">
					$(function() {
					  $("##startdate").datepicker();
					  $("##enddate").datepicker();
					});
				</script>
			</cfif> --->
		</head>
		<body>
			<div class="navbar navbar-fixed-top">
				<div class="navbar-inner">
					<div class="container">
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</a>
						<a class="brand" href="#contextPath#/bluedragon/administrator/index.cfm">
							<!--- <img src="#contextPath#/bluedragon/administrator/images/sd_openBD_32.png" border="0" /> --->
							BlueDragon
						</a>
						<div class="nav-collapse">
							<ul class="nav">
								<li class="<cfif theSection == "administrator" && thePage == "index.cfm">active</cfif>">
								  <a href="#contextPath#/bluedragon/administrator/index.cfm">Home</a>
								</li>
								<li class="dropdown<cfif theSection == 'settings'> active</cfif>">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">Server
										<b class="caret"></b>
                  </a>
									<ul class="dropdown-menu">
										<li class="<cfif theSection == "settings" && thePage == "security.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/security.cfm">Security</a>
                    </li>
                    <li class="<cfif theSection == "settings" && ListFind("systeminfo.cfm,jvmproperties.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/systeminfo.cfm">System Info</a>
                    </li>
                    <li class="<cfif theSection == "settings" && thePage == "index.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/index.cfm">Settings</a>
                    </li>
                    <li class="<cfif theSection == "settings" && ListFind("caching.cfm,filecachedetails.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/caching.cfm">Caching</a>
                    </li>
                    <li class="<cfif theSection == "settings" && thePage == "variables.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/variables.cfm">Variables</a>
                    </li>
                    <li class="<cfif theSection == "settings" && thePage == "mappings.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/mappings.cfm">Mappings</a>
                    </li>
                    <li class="<cfif theSection == "settings" && thePage == "mail.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/mail.cfm">Mail</a>
                    </li>
                    <li class="<cfif theSection == "settings" && thePage == "fonts.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/settings/fonts.cfm">Fonts</a>
                    </li>
									</ul>
								</li>
                <li class="dropdown<cfif theSection == 'datasources'> active</cfif>">
                  <a href="##" class="dropdown-toggle" data-toggle="dropdown">Data &amp; Services
                    <b class="caret"></b>
                  </a>
                  <ul class="dropdown-menu">
                    <li class="<cfif theSection == "datasources" && ListFind("index.cfm,h2-embedded.cfm,sqlserver-jtds.cfm,sqlserver2005-ms.cfm,mysql5.cfm,oracle.cfm,other.cfm,postgresql.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/datasources/index.cfm">Datasources</a>
                    </li>
                    <li class="<cfif theSection == "datasources" && thePage == "scheduledtasks.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/datasources/scheduledtasks.cfm">Scheduled Tasks</a>
                    </li>
                    <li class="<cfif theSection == "datasources" && ListFind("collections.cfm,collectionindex.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/datasources/collections.cfm">Search Collections</a>
                    </li>
                    <li class="<cfif theSection == "datasources" && thePage == "webservices.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/datasources/webservices.cfm">Web Services</a>
                    </li>
                  </ul>
                </li>
                <li class="dropdown<cfif theSection == 'debugging'> active</cfif>">
                  <a href="##" class="dropdown-toggle" data-toggle="dropdown">Debugging &amp; Logging
                    <b class="caret"></b>
                  </a>
                  <ul class="dropdown-menu">
                    <li class="<cfif theSection == "debugging" && thePage == "index.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/debugging/index.cfm">Debug Settings</a>
                    </li>
                    <li class="<cfif theSection == "debugging" && thePage == "ipaddresses.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/debugging/ipaddresses.cfm">Debug IP Addresses</a>
                    </li>
                    <li class="<cfif theSection == "debugging" && ListFind("logs.cfm,viewlogfile.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/debugging/logs.cfm">Log Files</a>
                    </li>
                    <li class="<cfif theSection == "debugging" && ListFind("runtimeerrors.cfm,viewrtelog.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/debugging/runtimeerrors.cfm">Runtime Error Logs</a>
                    </li>
                  </ul>
                </li>
                <li class="dropdown<cfif theSection == 'extensions'> active</cfif>">
                  <a href="##" class="dropdown-toggle" data-toggle="dropdown">Extensions
                    <b class="caret"></b>
                  </a>
                  <ul class="dropdown-menu">
                    <li class="<cfif theSection == "extensions" && thePage == "customtagpaths.cfm">active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/extensions/customtagpaths.cfm">Custom Tag Paths</a>
                    </li>
                    <li class="<cfif theSection == "extensions" && ListFind("cfxtags.cfm,javacfx.cfm,cppcfx.cfm", thePage) != 0>active</cfif>">
                      <a href="#contextPath#/bluedragon/administrator/extensions/cfxtags.cfm">CFX Tags</a>
                    </li>
                  </ul>
                </li>
							</ul>
							<ul class="nav pull-right">
								<li class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">Other Links
										<b class="caret"></b>
                  </a>
									<ul class="dropdown-menu">
										<li>
                      <a href="http://www.openbd.org/manual" target="_blank">OpenBD Manual</a>
                    </li>
                    <li>
                      <a href="http://www.openbd.org/manual/?/engine_bluedragonxml" target="_blank">OpenBD Configuration Reference</a>
                    </li>
                    <li>
                      <a href="http://groups.google.com/group/openbd" target="_blank">OpenBD Google Group</a>
                    </li>
                    <li>
                      <a href="http://www.openbd.org" target="_blank">OpenBD Web Site</a>
                    </li>
                    <li>
                      <a href="http://wiki.openbd.org" target="_blank">OpenBD Wiki</a>
                    </li>
                    <li>
                      <a href="http://openbdcookbook.org" target="_blank">OpenBD Cookbook</a>
                    </li>
                    <li>
                      <a href="http://groups.google.com/group/cfml-conventional-wisdom" target="_blank">CFML Conventional Wisdom</a>
                    </li>
                    <li>
                      <a href="http://code.google.com/p/openbluedragon-admin-app/" target="_blank">OpenBD Admin Console Project</a>
                    </li>
									</ul>
								</li>
                <li class="divider-vertical"></li>
                <li>
                  <a href="#contextPath#/bluedragon/administrator/_loginController.cfm?action=logout"">Logout</a>
                </li>
							</ul>
						</div>
						<!--/.nav-collapse -->
					</div>
				</div>
			</div>
			<div class="container">
			  #Replace(request.content, "${contextPath}", contextPath, "ALL")#
        <hr />
				<footer>
					<div class="pull-left">
						Copyright &copy; 2008 - #Year(Now())#
						<a href="http://www.openbd.org" target="_blank">Open BlueDragon Project</a>
					</div>
					<div class="pull-right">
						Version #Application.adminConsoleVersion# - #Application.adminConsoleBuildDate#
					</div>
				</footer>
      </div>
      <script src="#contextPath#/bluedragon/administrator/js/jquery-1.7.2.min.js" type="text/javascript"></script>
			<script src="#contextPath#/bluedragon/administrator/js/bootstrap.min.js" type="text/javascript"></script>
		</body>
	</html>
</cfoutput>
