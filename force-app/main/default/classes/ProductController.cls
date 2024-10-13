/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 10-09-2024
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
                                            ProductCategory__c, 
                                            ProductType__c,
                                            ProductItem__c,
                                            // SalesTori/MainTori CTI
                                            ProductGroup__c,  
                                            ProductModel__c,
                                            CostCategory__c, 
                                            CostType__c, 
                                            // AX Code
                                            SalesCode__c,
                                            Installation__c, 
                                            isReclamation__c, 
                                            ReclamationCode__c,                                          
                                            // Salesforce Product Flags
                                            ProductVendor__c,
                                            Configurator__c, 
                                            isSovelia__c, 
                                            isVisual__c, 
                                            isAdditionalCost__c,
                                            isExtraSales__c,
                                            isService__c, 
                                            isSparePart__c,
                                            isManualProcessing__c, 
                                            OrderBatchSize__c, 
                                            isSpecial__c 
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
        List<Product2> groupedProducts = ([SELECT  Id 
                                    FROM Product2 
                                    WHERE ProductGroup__c IN:productGroups
                                    AND IsActive = true
                                    ]);
        List<Id> groupedProductIds = new List<Id>(new Map<Id, Product2>(groupedProducts).keySet()); 
        List<Product2> products = getProducts(groupedProductIds);
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