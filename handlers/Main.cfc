component{
	property name="businessLogicService" inject="businessLogicService@businessLogicScanner";
	
	function index(event,rc,prc){
		prc.results = businessLogicService.scan();
	}	
	
}
