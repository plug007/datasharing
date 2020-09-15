/**
* @author Vijay
* @name WPCaseRecordResource
* @description Represents a Case object in Workforce Planning external system
**/
global class WPCaseRecordResource  {
	webservice String id;
	webservice String agentid;


	/**
	* @name parse
	* @description This method deserializes this record as Json payload for callout
	* @return External Object
	**/
	public static WPCaseRecordResource parse(String json) {
      return (WPCaseRecordResource) System.JSON.deserialize(json, WPCaseRecordResource.class);
	}

}