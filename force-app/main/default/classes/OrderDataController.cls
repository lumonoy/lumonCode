/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-11-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class OrderDataController {
    public static String parseXML(String OrderMessageXML) {
        String orderMessageJSON;
        try {
            Dom.Document XMLdocument = new Dom.Document();
            XMLdocument.load(OrderMessageXML);
            //System.Debug('--- OrderDataController - XML: '+XMLString);   
            Map<Object, Object> xmlResponseMap = new Map<Object, Object>();
            Map<Object, Object> xmlNodeMap = new Map<Object, Object>();
            Dom.XMLNode rootElement = XMLdocument.getRootElement();
            String rootName = RootElement.getName();
            String rootType = string.ValueOf(rootElement.getNodeType());
            // Initiate first XML Node Parsing for Root Element
            System.debug('--- OrderDataController - ROOT ELEMENT '+ rootName);
            xmlNodeMap = parseXMLNode(rootElement, new Map<Object, Object>());
            // When Node Map is not Empty then add the Node
            if(!xmlNodeMap?.isEmpty()) {
                // If RootName in already in map try to add nodeMap  
                if(xmlResponseMap.containsKey(rootName)) {
                    try {
                        ((List<Object>)xmlResponseMap.get(rootName)).add(xmlNodeMap);
                    } catch(Exception e) { // if adding the Node Map Fails this is a Array and need to add to the List 
                        xmlResponseMap.put(rootName, new List<Object> { xmlResponseMap.get(rootName), xmlNodeMap });
                    }
                }
            } else { // xmlNodeMap is Empty so just add the nodeMap
                xmlResponseMap.put(rootName, xmlNodeMap);
            } 
                                       
            // Turn the Map into a JSON String
            orderMessageJSON  = JSON.serialize(xmlResponseMap);
        } catch (Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());            
        }     
        return orderMessageJSON;
    }    
    public static Map<Object, Object> parseXMLNode (Dom.XMLNode node, Map<Object, Object> parentMap) {
        // Primary function to decode XML        
        String nodeText = node.getText().trim(), nodeName = node.getName(), nodeType = String.ValueOf(node.getNodeType());
        //System.debug('--- OrderDataController - NODE '+nodeType+' '+ nodeName+'("'+nodeText+'")' );
        //            + 'has '+node.getChildElements().size()+' ChildElements and '
        //            +node.getAttributeCount()+' Attributes');  
            
        if (node.getAttributeCount() >0 ) {
            System.debug('--- OrderDataController - ' +node.getAttributeCount()+' Attributes');
            for (Integer i = 0; i<node.getAttributeCount();i++){
                System.debug('--- OrderDataController - Attribute Key: '+node.getAttributeKeyAt(i)); 
            }
        }
        if (node.getChildElements().size() >0)  {
            //System.debug('--- OrderDataController - ' +node.getChildElements().size()+' ChildElements');
            // Iterate over all child elements for a given node
            for(Dom.XmlNode child: node.getChildElements()) {
                String childText = child.getText().trim(), childName = child.getName(), childType = String.ValueOf(child.getNodeType());
                if (childName == 'group') {
                    System.Debug('--- OrderDataController - Found group => salesTori'); 
                } else if (childName == 'group1') {
                    System.Debug('--- OrderDataController - Found group1 => salesforce'); 
                }
                Object childTextvalue = String.isBlank(childText)? null:// Nothing
                        Pattern.compile('^(true|false)$').matcher(childText).find()? (Object)Boolean.valueOf(childText):// Boolean           
                        Pattern.compile('^[-+]?\\d+(\\.\\d+)?$').matcher(childText).find()? (Object)Decimal.valueOf(childText):// Decimal            
                        Pattern.compile('^\\d{4}.\\d{2}.\\d{2}$').matcher(childText).find()? (Object)Date.valueOf(childText):// Date            
                        Pattern.compile('^\\d{4}.\\d{2}.\\d{2} (\\d{2}:\\d{2}:\\d{2} ([-+]\\d{2}:\\d{2})?)?$').matcher(childText).find()? (Object)DateTime.valueOf(childText):// Time            
                        (Object)childText; //  Text to process
                // Pull out some information
                if(childTextvalue != null) {
                    System.Debug('--- OrderDataController - '+ childName+' = '+childTextValue); 
                    if(parentMap.containsKey(childName)) {
                        //System.Debug('--- OrderDataController - Existing Child '+ childName); 
                        try {
                            ((List<Object>)parentMap.get(childName)).add(childTextvalue);
                        } catch(Exception e) { // adding value failed, so convert to a list                  
                            parentMap.put(childName, new List<Object>{parentMap.get(childName), childTextvalue});    
                        }  
                    } else {
                        // Store a new value
                        //System.Debug('--- OrderDataController - New Child '+ childName); 
                        parentMap.put(childName, childTextvalue);
                    } 
                } else if(child.getNodeType() == Dom.XmlNodeType.ELEMENT) {                         
                    // Node is a Array
                    System.Debug('--- OrderDataController ------------------------------------'); 
                    System.Debug('--- OrderDataController - ELEMENT '+ childName);                
                    Map<Object, Object> tempMap = parseXMLNode(child, new Map<Object, Object>());
                    if(!tempMap.isEmpty()) {
                        // Again, create or update a list if we have a value
                        if(parentMap.containsKey(childName)) {
                            //System.Debug('--- OrderDataController - Existing Child Element'+ childName);
                            try {
                                ((List<Object>)parentMap.get(childName)).add(tempMap);
                            } catch(Exception e) {
                                parentMap.put(childName, new List<Object> { parentMap.get(childName), tempMap });
                            }    
                            parentMap.put(childName, tempMap); 
                        } else {
                            //System.Debug('--- OrderDataController - New Child Element'+ childName);
                            parentMap.put(childName, tempMap);       
                        }
                    }
                }
            }
        }
        //System.Debug('--- OrderDataController - PARENT Map'+ parentMap);
        return parentMap;
    }
    public static OrderData parseOrderMessageXML(String orderMessage) {
        OrderData orderData;
        if(Test.isRunningTest()){
            //Show Pretty Print JSON
            System.debug('--- OrderDataController - Order Message XML:' + orderMessage);   
        }  
        String OrderMessageJSON = parseXML(orderMessage);
        if(Test.isRunningTest()){
            //Show Pretty Print JSON
            System.debug('--- OrderDataController - Order Message JSON Pretty:' + JSON.serializePretty(OrderMessageJSON));   
        }  
        orderData = (OrderData) JSON.deserialize(OrderMessageJSON, OrderData.class);
        if(Test.isRunningTest()){
            //Show Pretty Print JSON
            System.debug('--- OrderDataController - Order Message Data:' + orderData);   
        }  
        return orderData;
    }
    public static OrderData parseOrderMessageJSON(String orderMessage) {
		System.JSONParser parser = System.JSON.createParser(orderMessage);
		return new OrderData(parser);
	}
    public static OrderData parseOrderMessage(String orderMessage){
        OrderData orderData;
        if (orderMessage.left(1)=='<') {
            orderData = parseOrderMessageXML(orderMessage);
        } else {
            orderData =  parseOrderMessageJSON(orderMessage);
        }
        return orderData;
    }
}