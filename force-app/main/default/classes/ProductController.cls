/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 08-09-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static Product2 getProduct(Id recordId) {
        List<Product2> products = New List<Product2>(); 
        // Find Projects based on recordId
        List<Id> recordIds = new List<Id>();
        recordIds.add(recordId);
        products = getProducts(recordIds);
        return products[0];
    } 
    @AuraEnabled(cacheable=false)
    public static Product2 getProductByNumber(String productNumber) {
        // Populate List from SOQL query on Product
        Id productId = [SELECT Id, ProductCode, ProductCode__c FROM Product2 WHERE ProductCode =: productNumber OR ProductCode__c =: productNumber LIMIT 1]?.Id; 
        List<Id> productIds = new List<Id>();
        productIds.add(productId);
        Product2 product = new Product2();
        System.debug('--- ProductController - Get Product with Id '+productId); 
        List<Product2> products =  getProducts(productIds); 
        if  (products?.size()>0) {
            product = products[0];
            System.debug('--- ProductController - Product: '+product.Name); 
        }        
        return product;
    }
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProducts(List<Id> recordIds) {
        // Populate map from SOQL query on Product2
        List<Product2> products = ([SELECT  Id, 
                                            Name, 
                                            ProductCode, 
                                            Description, 
                                            IsActive, 
                                            Family, 
                                            ExternalDataSourceId, 
                                            ExternalId, 
                                            QuantityUnitOfMeasure, 
                                            // Product CTI
                                            Product_Category__c, 
                                            Product_Type__c,
                                            Product_Item__c,
                                            // SalesTori/MainTori CTI
                                            Product_Group__c,  
                                            Product_Model__c,
                                            Cost_Category__c, 
                                            Cost_Type__c, 
                                            // AX Code
                                            Sales_Code__c,
                                            Installation__c, 
                                            Reclamation__c, 
                                            Reclamation_Code__c,                                          
                                            Dimension__c, 
                                            Unique_ProductCode__c, 
                                            Unit_Of_Measure__c, 
                                            // Salesforce Product Flags
                                            Vendor__c,
                                            Configurator__c, 
                                            Sovelia__c, 
                                            Visual__c, 
                                            Additional_Cost__c,
                                            Extra_Sales__c,
                                            Service__c, 
                                            Spare_Part__c,
                                            Product_Name_EN__c, 
                                            Product_Name_ES__c, 
                                            Product_Name_FI__c,
                                            Manual_Processing__c, 
                                            Batch_Size__c, 
                                            Special__c,  
                                            Color_Options__c, 
                                            // Link from Items to Products 
                                            Parent_Product__c       
                                    FROM Product2 
                                    WHERE Id IN:recordIds
                                    AND IsActive = true
                                    ]);
        System.debug('--- ProductController - Product2 Record Count : '+products.size());
        return products;
    } 
    @AuraEnabled(cacheable=true)
    public static Map<String,List<Product2>> getProductsByGroup(List<String> productGroups) {
        // Populate map from SOQL query on Product2
        List<Product2> products = ([SELECT  Id, 
                                            Name, 
                                            ProductCode, 
                                            Description, 
                                            IsActive, 
                                            Family, 
                                            ExternalDataSourceId, 
                                            ExternalId, 
                                            QuantityUnitOfMeasure, 
                                            // Product CTI
                                            Product_Category__c, 
                                            Product_Type__c,
                                            Product_Item__c,
                                            // SalesTori/MainTori CTI
                                            Product_Group__c,  
                                            Product_Model__c,
                                            Cost_Category__c, 
                                            Cost_Type__c, 
                                            // AX Code
                                            Sales_Code__c,
                                            Installation__c, 
                                            Reclamation__c, 
                                            Reclamation_Code__c,                                          
                                            Dimension__c, 
                                            Unique_ProductCode__c, 
                                            Unit_Of_Measure__c, 
                                            // Salesforce Product Flags
                                            Vendor__c,
                                            Configurator__c, 
                                            Sovelia__c, 
                                            Visual__c, 
                                            Additional_Cost__c,
                                            Extra_Sales__c,
                                            Service__c, 
                                            Spare_Part__c,
                                            Product_Name_EN__c, 
                                            Product_Name_ES__c, 
                                            Product_Name_FI__c,
                                            Manual_Processing__c, 
                                            Batch_Size__c, 
                                            Special__c,  
                                            Color_Options__c, 
                                            // Link from Items to Products 
                                            Parent_Product__c       
                                    FROM Product2 
                                    WHERE Product_Group__c IN:productGroups
                                    AND IsActive = true
                                    ]);
        System.debug('--- ProductController - Product2 Record Count : '+products.size());
        Map<String,List<Product2>> productsByGroup = new Map<String,List<Product2>> ();
        if(products?.size()>0 ) {
            for (Product2 prod : products) {
                String prodGroup = prod.Product_Group__c;
                if(!productsByGroup.containsKey(prodGroup)) {
                    productsByGroup.put(prodGroup,new List<Product2>());
                }
                List<Product2> prods = productsByGroup.get(prodGroup);
                prods.add(prod);
                productsByGroup.put(prodGroup,prods);
            }
        }
        return productsByGroup;
    } 
}