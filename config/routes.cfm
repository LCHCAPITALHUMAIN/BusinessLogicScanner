<cfscript>
	addRoute(pattern="/", handler="main",action="index");
	
	addRoute(pattern="/:handler/:action?");
</cfscript>