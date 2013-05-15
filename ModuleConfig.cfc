component {
	
	// Module Properties
	this.title 				= "Business Logic Scanner";
	this.author 			= "Brad Wood";
	this.webURL 			= "http://www.codersrevolution.com";
	this.description 		= "I scan your handlers and views to make sure you don't have any business logic in them.";
	this.version			= "1";
	this.viewParentLookup 	= true;
	this.layoutParentLookup = true;
	this.entryPoint			= "businessLogicScanner";
	
	function configure(){
		
		// SES Routes
		routes = [
			"config/routes.cfm"
		];
		
		// Binder
		binder.map("businessLogicService@businessLogicScanner").to("#moduleMapping#.model.businessLogicService");
	}
	
}