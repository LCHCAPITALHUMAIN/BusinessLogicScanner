component singleton {
	property name="appMapping" inject="coldbox:setting:appMapping";
	property name="viewsconvention" inject="coldbox:fwsetting:viewsconvention";
	property name="ViewsExternalLocation" inject="coldbox:setting:ViewsExternalLocation";
	property name="handlersconvention" inject="coldbox:fwsetting:handlersconvention";
	property name="handlersExternalLocation" inject="coldbox:setting:HandlersExternalLocationPath";
	property name="ModuleService" inject="coldbox:ModuleService";
	property name="QueryHelper" inject="coldbox:plugin:QueryHelper";
		
	function init() {
		// I had to break up some of these strings to avoid Railo parsing errors.
		badThingsRegex = ["<" & "cfquery","new query\(","createObject\(""component""\, ""query""\)"];
	}
		
	function onDIComplete() {
		loadedModules = ModuleService.getModuleRegistry();
	}

	array function scan()  {
		local.badApples = scanFiles(collectViews(),'cfm');
		local.badApples.addAll(scanFiles(collectHandlers(),'cfc'));
		arraySort(local.badApples,"text");
		return local.badApples;
	}

	query function collectViews()  {
		// Local app views
		local.qryFiles = directoryList("\" & appMapping & "\" & viewsconvention,true,'query');
		
		// External Views
		if(len(trim(ViewsExternalLocation))) {
			local.qryExternal = directoryList(ViewsExternalLocation,true,'query');
			local.qryFiles = QueryHelper.doQueryAppend(local.qryExternal,local.qryFiles);			
		}
		
		// Module Views
		for(local.key in loadedModules) {
			local.moduleViewFolder = loadedModules[local.key].PhysicalPath & "\" & key & "\views";
			local.qryExternal = directoryList(local.moduleViewFolder,true,'query');
			local.qryFiles = QueryHelper.doQueryAppend(local.qryExternal,local.qryFiles);
		}
		return local.qryFiles;
	}

	query function collectHandlers()  {
		// Local app handlers
		local.qryFiles = directoryList("\" & appMapping & "\" & handlersconvention,true,'query');
		
		// External handlers
		if(len(trim(handlersExternalLocation))) {
			local.qryExternal = directoryList(handlersExternalLocation,true,'query');
			local.qryFiles = QueryHelper.doQueryAppend(local.qryExternal,local.qryFiles);			
		}
		
		// Module handlers
		for(local.key in loadedModules) {
			local.moduleHandlerFolder = loadedModules[local.key].PhysicalPath & "\" & key & "\handlers";
			local.qryExternal = directoryList(local.moduleHandlerFolder,true,'query');
			local.qryFiles = QueryHelper.doQueryAppend(local.qryExternal,local.qryFiles);
		}
		return local.qryFiles;
	}

	array function scanFiles(qryFiles,ext) {
	
		local.badApples = [];
		
		// Search through all the files of the appropriate type
		for(var i=1; i<=arguments.qryFiles.recordCount; i++) {
		
			if(arguments.qryFiles['type'][i] == 'File' && listFindNoCase(ext,listLast(arguments.qryFiles['name'][i],'.'))) {
				local.fullPath = arguments.qryFiles['directory'][i]&'\'&arguments.qryFiles['name'][i];
				// Read the file's contents so we can introspect it
				local.file = fileRead(fullPath);
			
				// Search for each of our "bad" regexes
				for(local.regex in badThingsRegex) {
					local.results = reFindNoCase(local.regex,local.file);
					// If we match one, add this file to the "bad" array and break to the next file.
					if(local.results) {
						arrayAppend(local.badApples,local.fullPath);
						break;					
					}
				}
			}
		}
		return local.badApples;

	}
	
	
}