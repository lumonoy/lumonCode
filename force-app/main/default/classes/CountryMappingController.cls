/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 04-16-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class CountryMappingController {
    @AuraEnabled(cacheable=false)
    public static Country_Mapping__mdt getCountryMappingByAlpha2(String searchString ) {
        // Populate List from SOQL query on Country_Mapping_mdt
        System.debug('--- Get Country_Mapping_mdts'); 
        Country_Mapping__mdt countryMapping = ([  SELECT Id, 
                                                        DeveloperName, 
                                                        MasterLabel, 
                                                        Language, 
                                                        NamespacePrefix, 
                                                        Label, 
                                                        QualifiedApiName, 
                                                        CountryCodeAlpha2__c, 
                                                        CountryCodeAlpha3__c,
                                                        Country_Name__c, 
                                                        CountryCode__c, 
                                                        OfficialName__c  
                                    FROM Country_Mapping__mdt 
                                    WHERE CountryCodeAlpha2__c =: searchString
                                    LIMIT 1
                                    ]);  
        System.debug('--- Country Mapping: '+countryMapping); 
        return countryMapping;  
    }
    @AuraEnabled(cacheable=false)
    public static Country_Mapping__mdt getCountryMappingByAlpha3(String searchString ) {
        // Populate List from SOQL query on Country_Mapping_mdt
        System.debug('--- Get Country_Mapping_mdts'); 
        Country_Mapping__mdt countryMapping = ([  SELECT Id, 
                                                        DeveloperName, 
                                                        MasterLabel, 
                                                        Language, 
                                                        NamespacePrefix, 
                                                        Label, 
                                                        QualifiedApiName, 
                                                        CountryCodeAlpha2__c, 
                                                        CountryCodeAlpha3__c,
                                                        Country_Name__c, 
                                                        CountryCode__c, 
                                                        OfficialName__c  
                                    FROM Country_Mapping__mdt 
                                    WHERE CountryCodeAlpha3__c =: searchString
                                    LIMIT 1
                                    ]);  
        System.debug('--- Country Mapping: '+countryMapping); 
        return countryMapping;  
    }
    @AuraEnabled(cacheable=false)
    public static Country_Mapping__mdt getCountryMappingByName(String searchString ) {
        // Populate List from SOQL query on Country_Mapping_mdt
        System.debug('--- Get Country_Mapping_mdts'); 
        Country_Mapping__mdt countryMapping = ([  SELECT Id, 
                                                        DeveloperName, 
                                                        MasterLabel, 
                                                        Language, 
                                                        NamespacePrefix, 
                                                        Label, 
                                                        QualifiedApiName, 
                                                        CountryCodeAlpha2__c, 
                                                        CountryCodeAlpha3__c,
                                                        Country_Name__c, 
                                                        CountryCode__c, 
                                                        OfficialName__c  
                                    FROM Country_Mapping__mdt 
                                    WHERE Country_Name__c =: searchString
                                    LIMIT 1
                                    ]);  
        System.debug('--- Country Mapping: '+countryMapping); 
        return countryMapping;  
    }
    @AuraEnabled(cacheable=false)
    public static Country_Mapping__mdt getCountryMappingByCode(String searchString ) {
        // Populate List from SOQL query on Country_Mapping_mdt
        System.debug('--- Get Country_Mapping_mdts'); 
        Country_Mapping__mdt countryMapping = ([  SELECT Id, 
                                                        DeveloperName, 
                                                        MasterLabel, 
                                                        Language, 
                                                        NamespacePrefix, 
                                                        Label, 
                                                        QualifiedApiName, 
                                                        CountryCodeAlpha2__c, 
                                                        CountryCodeAlpha3__c,
                                                        Country_Name__c, 
                                                        CountryCode__c, 
                                                        OfficialName__c  
                                    FROM Country_Mapping__mdt 
                                    WHERE CountryCode__c =: searchString
                                    LIMIT 1
                                    ]);  
        System.debug('--- Country Mapping: '+countryMapping); 
        return countryMapping;  
    }
}