/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 11-20-2023
 * @last modified by  : Henk Reynders
**/
public class SoveliaConfiguration { 
    //@AuraEnabled public String apartment{get;set;} // Door Nbr in Apartment
    //@AuraEnabled public String floor{get;set;} // Floor Nbr in Building
    @AuraEnabled public String id{get;set;} // Unique Sovelia Configuration Id
    //@AuraEnabled public String line{get;set;} //?
    @AuraEnabled public String name{get;set;} // Name of the Configuration
    @AuraEnabled public List<Product> products{get;set;} // Product Model aka Configurable Product
    @AuraEnabled public Integer version{get;set;} // Configuration Version
            
    public class Product {
        //@AuraEnabled public Boolean hasFeaturesBeenConfirmed{get;set;}
        //@AuraEnabled public Boolean hasMeasurementsBeenVerified{get;set;}
        @AuraEnabled public String id{get;set;} // Product Code of Product Model
        @AuraEnabled public String name{get;set;} // Name of the Product Model
        @AuraEnabled public List<PriceParameter> priceParameters{get;set;} // List of Product Items with Quantity 
        //@AuraEnabled public Integer productInspectCode{get;set;}
        //@AuraEnabled public List<ProductInspectMessageKey> productInspectMessageKeys{get;set;}
        //@AuraEnabled public Double productLength{get;set;}
        //public List<ReclaimedFeatureMessageKey> reclaimedFeatureMessageKeys{get;set;}
        @AuraEnabled public String rvn{get;set;} //ProjectNbr + Structure
    }
               
    public class PriceParameter {
        @AuraEnabled public Double Amount{get;set;}
        @AuraEnabled public Boolean LocalSupplier{get;set;}
        @AuraEnabled public String ParameterCode{get;set;}
        @AuraEnabled public String SalesCode{get;set;}
        @AuraEnabled public Integer UniqueId{get;set;}
        @AuraEnabled public String Unit{get;set;}
    }
        
    /*public class ReclaimedFeatureMessageKey {
        public String InspectMessage{get;set;}
        public String MessageKey{get;set;}
        public String SpaceSideNumber{get;set;}
    }*/
    
    /*public class ProductInspectMessageKey {
        @AuraEnabled public String InspectMessage{get;set;}
        @AuraEnabled public String MessageKey{get;set;}
        @AuraEnabled public String SpaceSideNumber{get;set;}
    } */     
    public static SoveliaConfiguration parseSoveliaConfiguration(String json) {
        SoveliaConfiguration configuration = (SoveliaConfiguration) System.JSON.deserialize(json, SoveliaConfiguration.class);
        for(SoveliaConfiguration.Product product : configuration.products) {
            if(product.name == 'Visor Blind -') {
                product.name = 'VISORBLINDSALES';
            }
        }
        return configuration;
    }
}