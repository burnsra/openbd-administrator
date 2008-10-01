<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Administrator.

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
	<cfparam name="args.action" type="string" default="" />
	
	<!--- stick everything in form and url into a struct for easy reference --->
	<cfset args = structNew() />
	
	<cfloop collection="#url#" item="urlKey">
		<cfset args[urlKey] = url[urlKey] />
	</cfloop>
	
	<cfloop collection="#form#" item="formKey">
		<cfset args[formKey] = form[formKey] />
	</cfloop>
	
	<!--- clear out any lingering session stuff --->
	<cfscript>
		structDelete(session, "message", false);
		structDelete(session, "datasource", false);
		structDelete(session, "errorFields", false);
		structDelete(session, "datasourceStatus", false);
		structDelete(session, "searchCollection", false);
	</cfscript>
	
	<cfswitch expression="#args.action#">
		<!--- DATASOURCES --->
		<cfcase value="addDatasource">
			<cfparam name="args.dsn" type="string" default="" />

			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<cfif trim(args.dsn) is "">
				<cfset errorFields[errorFieldsIndex][1] = "dsn" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Datasource Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<!--- check to see if the datasource already exists --->
			<cfif Application.datasource.datasourceExists(args.dsn)>
				<cfset errorFields[errorFieldsIndex][1] = "dsn" />
				<cfset errorFields[errorFieldsIndex][2] = "A datasource with that name already exists" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="index.cfm" addtoken="false" />
			<cfelse>
				<!--- get the defaults for the db driver --->
				<cfset dbDriverDefaults = Application.datasource.getDriverInfo(datasourceconfigpage = args.datasourceconfigpage) />
				
				<!--- set default form values so we can use the same form for adds and edits  --->
				<cfscript>
					dsinfo = structNew();
					dsinfo.name = args.dsn;
					dsinfo.databasename = "";
					dsinfo.server = "";
					dsinfo.hoststring = "";
					dsinfo.port = dbDriverDefaults.defaultport;
					dsinfo.username = "";
					dsinfo.password = "";
					dsinfo.description = "";
					dsinfo.initstring = "";
					dsinfo.sqlselect = true;
					dsinfo.sqlinsert = true;
					dsinfo.sqlupdate = true;
					dsinfo.sqldelete = true;
					dsinfo.sqlstoredprocedures = true;
					dsinfo.perrequestconnections = false;
					dsinfo.maxconnections = 24;
					dsinfo.connectiontimeout = 120;
					dsinfo.logintimeout = 120;
					dsinfo.connectionretries = 0;
					dsinfo.drivername = dbDriverDefaults.drivername;
					dsinfo.driverdescription = dbDriverDefaults.driverdescription;
					
					datasource = arrayNew(1);
					datasource[1] = StructCopy(dsinfo);
					
					session.datasource = datasource;
				</cfscript>
				
				<cflocation url="#args.datasourceconfigpage#" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="editDatasource">
			<cfparam name="args.dsn" type="string" default="" />
			
			<cfif trim(args.dsn) is "">
				<cfset session.message = "Please select a valid datasource to edit" />
				<cflocation url="index.cfm" addtoken="false" />
			<cfelse>
				<cfset session.datasource = Application.datasource.getDatasources(args.dsn) />
				<cfset dbDriverDefaults = Application.datasource.getDriverInfo(drivername = session.datasource[1].drivername) />
				
				<cfif structKeyExists(dbDriverDefaults, "datasourceconfigpage")>
					<cflocation url="#dbDriverDefaults.datasourceconfigpage#?action=update" addtoken="false" />
				<cfelse>
					<cflocation url="other.cfm?action=update" addtoken="false" />
				</cfif>
			</cfif>
		</cfcase>

		<cfcase value="processDatasourceForm">
			<cfparam name="args.name" type="string" default="" />
			<cfparam name="args.databasename" type="string" default="" />
			<cfparam name="args.server" type="string" default="" />
			<cfparam name="args.port" type="string" default="" />
			<cfparam name="args.sqlselect" type="boolean" default="false" />
			<cfparam name="args.sqlinsert" type="boolean" default="false" />
			<cfparam name="args.sqlupdate" type="boolean" default="false" />
			<cfparam name="args.sqldelete" type="boolean" default="false" />
			<cfparam name="args.sqlstoredprocedures" type="boolean" default="false" />
			<cfparam name="args.perrequestconnections" type="boolean" default="false" />
			<cfparam name="args.datasourceAction" type="string" default="create" />
			<cfparam name="args.hoststring" type="string" default="" />
			<cfparam name="args.dbtype" type="string" default="" />
			
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<!--- validate the form data --->
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Datasource Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif args.dbtype is "">
				<cfif trim(args.databasename) is "">
					<cfset errorFields[errorFieldsIndex][1] = "databasename" />
					<cfset errorFields[errorFieldsIndex][2] = "The value of Database Name cannot be blank" />
					<cfset errorFieldsIndex = errorFieldsIndex + 1 />
				</cfif>
				
				<cfif trim(args.server) is "">
					<cfset errorFields[errorFieldsIndex][1] = "server" />
					<cfset errorFields[errorFieldsIndex][2] = "The value of Database Server cannot be blank" />
					<cfset errorFieldsIndex = errorFieldsIndex + 1 />
				</cfif>
				
				<cfif trim(args.port) is "" or not isNumeric(trim(form.port))>
					<cfset errorFields[errorFieldsIndex][1] = "port" />
					<cfset errorFields[errorFieldsIndex][2] = "The value of Server Port cannot be blank and must be numeric" />
					<cfset errorFieldsIndex = errorFieldsIndex + 1 />
				</cfif>
			</cfif>
			
			<cfif args.dbtype is "other">
				<cfif trim(args.hoststring) is "">
					<cfset errorFields[errorFieldsIndex][1] = "hoststring" />
					<cfset errorFields[errorFieldsIndex][2] = "The value of JDBC URL cannot be blank" />
					<cfset errorFieldsIndex = errorFieldsIndex + 1 />
				</cfif>
			</cfif>
			
			<cfif arrayLen(errorFields) neq 0>
				<!--- TODO: add nicer functionality so the entire form gets repopulated on error --->
				<cfset session.errorFields = errorFields />
				<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
			<cfelse>
				<cfset structDelete(session, "message", false) />
				<cfset structDelete(session, "errorFields", false)>
				<!--- No errors on the required fields so create/modify the datasource.
						If it's a create, need to check to see if the datasource already exists. --->
				<cfif args.datasourceAction is "create" and Application.datasource.datasourceExists(args.name)>
					<cfset session.message = "A datasource with that name already exists." />
					<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
				<cfelse>
					<cftry>
						<cfswitch expression="#args.dbtype#">
							<!--- known jdbc driver types --->
							<cfcase value="">
								<cfset Application.datasource.setDatasource(args.name, args.databasename, args.server, 
																				args.port, args.username, args.password, 
																				"", args.description, 
																				args.initstring, args.connectiontimeout, 
																				args.connectionretries, args.logintimeout, 
																				args.maxconnections, args.perrequestconnections, 
																				args.sqlselect, args.sqlinsert, args.sqlupdate, args.sqldelete, 
																				args.sqlstoredprocedures, args.drivername, 
																				args.datasourceAction, args.existingDatasourceName) />
							</cfcase>
							
							<!--- 'other' jdbc driver --->
							<cfcase value="other">
								<cfset Application.datasource.setDatasource(args.name, "", "", 0, args.username, 
																				args.password, args.hoststring, args.description, 
																				args.initstring, args.connectiontimeout, 
																				args.connectionretries, args.logintimeout, 
																				args.maxconnections, args.perrequestconnections, 
																				args.sqlselect, args.sqlinsert, args.sqlupdate, args.sqldelete, 
																				args.sqlstoredprocedures, args.drivername, 
																				args.datasourceAction, args.existingDatasourceName, 
																				args.verificationquery) />
							</cfcase>
						</cfswitch>
						<cfcatch type="bluedragon.adminapi.datasource">
							<cfset session.message = CFCATCH.Message />
							<cflocation url="index.cfm" addtoken="false" />
						</cfcatch>
					</cftry>
					
					<cfset session.message = "The datasource was #args.datasourceAction#d successfully." />
					<cflocation url="index.cfm" addtoken="false" />
				</cfif>
			</cfif>
		</cfcase>
		
		<cfcase value="verifyDatasource">
			<cfparam name="args.dsn" type="string" default="" />
			<cfparam name="datasources" type="array" default="#arrayNew(1)#" />
			
			<cfset session.datasourceStatus = ArrayNew(1)>
			
			<!--- is args.dsn is not "" then we're verifying a single datasource; otherwise verify all --->
			<cfif args.dsn is not "">
				<cfset datasources = Application.datasource.getDatasources(args.dsn) />
			<cfelse>
				<cfset datasources = Application.datasource.getDatasources() />
			</cfif>
			
			<cfloop index="i" from="1" to="#arrayLen(datasources)#">
				<cfset session.datasourceStatus[i].name = datasources[i].name />
				
				<cftry>
					<cfset session.datasourceStatus[i].verified = Application.datasource.verifyDatasource(datasources[i].name) />
					<cfset session.datasourceStatus[i].message = "" />
					<cfcatch type="bluedragon.adminapi.datasource">
						<cfset session.datasourceStatus[i].verified = false />
						<cfset session.datasourceStatus[i].message = CFCATCH.Message />
					</cfcatch>
				</cftry>
			</cfloop>
			
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="removeDatasource">
			<!--- make sure the datasource exists --->
			<cfif not Application.datasource.datasourceExists(args.dsn)>
				<cfset session.message = "The datasource you attempted to remove does not exist." />
				<cflocation url="index.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.datasource.deleteDatasource(args.dsn) />
					<cfcatch type="bluedragon.adminapi.datasource">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="index.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The datasource was removed successfully." />
				<cflocation url="index.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="resetDatabaseDrivers">
			<cftry>
				<cfset Application.datasource.getRegisteredDrivers(true) />
				<cfcatch type="bluedragon.adminapi.datasource">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="index.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The database drivers were reset successfully." />
			<cflocation url="index.cfm" addtoken="false" />
		</cfcase>
		
		<!--- SEARCH COLLECTIONS --->
		<cfcase value="createSearchCollection">
			<cfset errorFields = arrayNew(2) />
			<cfset errorFieldsIndex = 1 />
			
			<!--- validate the form data --->
			<cfif trim(args.name) is "">
				<cfset errorFields[errorFieldsIndex][1] = "name" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Collection Name cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.path) is "">
				<cfset errorFields[errorFieldsIndex][1] = "path" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Collection Path cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif trim(args.language) is "">
				<cfset errorFields[errorFieldsIndex][1] = "path" />
				<cfset errorFields[errorFieldsIndex][2] = "You must select a Language for the collection" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>
			
			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="collections.cfm" addtoken="false" />
			<cfelse>
				<cftry>
					<cfset Application.searchCollections.createSearchCollection(args.name, args.path, 
																				args.language, args.storebody) />
					<cfcatch type="bluedragon.adminapi.searchcollections">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="collections.cfm" addtoken="false" />
					</cfcatch>
				</cftry>
				
				<cfset session.message = "The collection was created successfully" />
				<cflocation url="collections.cfm" addtoken="false" />
			</cfif>
		</cfcase>
		
		<cfcase value="showIndexForm">
			<cftry>
				<cfset session.searchCollection = Application.searchCollections.getSearchCollection(args.name) />
				<cfcatch type="bluedragon.adminapi.searchcollections">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="collections.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cflocation url="collectionindex.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="indexSearchCollection">
			<cfset errorFields = arrayNew(2) />

			<!--- validate the form data --->
			<cfif trim(args.key) is "">
				<cfset errorFields[errorFieldsIndex][1] = "key" />
				<cfset errorFields[errorFieldsIndex][2] = "The value of Directory Path cannot be blank" />
				<cfset errorFieldsIndex = errorFieldsIndex + 1 />
			</cfif>

			<cfif arrayLen(errorFields) gt 0>
				<cfset session.errorFields = errorFields />
				<cflocation url="_controller.cfm?action=showIndexForm&name=#args.name#" addtoken="false" />
			<cfelse>
				<cftry>
					<cfif args.type is "path">
						<cfset collectionIndexStatus = Application.searchCollections.indexSearchCollection(args.collection, args.collectionAction, args.type, 
																											args.key, args.language, args.urlpath, 
																											args.extensions, args.recurse) />
					<cfelseif args.type is "website">
						<cfset collectionIndexStatus = Application.searchCollections.indexSearchCollection(args.collection, args.collectionAction, args.type, 
																											args.key, args.language) />
					</cfif>
					<cfcatch type="bluedragon.adminapi.searchcollections">
						<cfset session.message = CFCATCH.Message />
						<cflocation url="_controller.cfm?action=showIndexForm&name=#args.name#" addtoken="false" />
					</cfcatch>
				</cftry>
			</cfif>
			
			<cfset session.message = "The collection was indexed successfully: #collectionIndexStatus.inserted# documents inserted, #collectionIndexStatus.updated# documents updated, #collectionIndexStatus.deleted# documents deleted." />
			<cflocation url="collections.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="deleteSearchCollection">
			<cftry>
				<cfset Application.searchCollections.deleteSearchCollection(args.name) />
				<cfcatch type="bluedragon.adminapi.searchcollections">
					<cfset session.message = CFCATCH.Message />
					<cflocation url="collections.cfm" addtoken="false" />
				</cfcatch>
			</cftry>
			
			<cfset session.message = "The collection was deleted successfully" />
			<cflocation url="collections.cfm" addtoken="false" />
		</cfcase>
		
		<cfcase value="getCollectionStatus">
			<cfset session.searchCollectionStatus = Application.searchCollections.getCollectionStatus(args.name) />
		</cfcase>
		
		<!--- SCHEDULED TASKS --->
		<cfcase value="processScheduledTaskForm">
		</cfcase>
		
		<!--- DEFAULT CASE -- NO VALID ACTION SPECIFIED --->
		<cfdefaultcase>
			<cfset session.message = "Invalid action" />
			<cflocation url="#CGI.HTTP_REFERER#" addtoken="false" />
		</cfdefaultcase>
	</cfswitch>
</cfsilent>