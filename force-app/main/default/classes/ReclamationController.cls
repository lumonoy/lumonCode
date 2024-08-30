/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 12-11-2023
 * @last modified by  : Henk Reynders
**/
public class ReclamationController {	
    public static String prepareOrder(Id recordId){
        String errorMessage;
        String objectName = DynamicObjectUtils.getObjectType(recordId);
        String queryCondition;
        Opportunity reclamation = new Opportunity();
        if(objectName == 'Opportunity' || objectName == 'Case'){
            reclamation = [SELECT Id,Case__c,AccountId,Account.BillingCity,Account.BillingCountry,
                                 Account.BillingCountryCode,Account.BillingPostalCode, Account.BillingState,
                                 Account.BillingStateCode,Account.BillingStreet,SyncedQuoteId,Order__c,
                                 ContractId,Preliminary_Contract_Needed__c,Order_type__c,Pricebook2Id,Name
                                 FROM Opportunity 
                                 WHERE Id = :recordId 
                                 OR Case__c =: recordId
                                 LIMIT 1];
        }
        if(String.IsNotBlank(reclamation.Id)){
            Id reclamationId = reclamation.Id;
            Id accountId = reclamation.AccountId;
            Id quoteId = reclamation.SyncedQuoteId;
            Id contractId = reclamation.ContractId;
            Id pricebookId = reclamation.Pricebook2Id;
            Id caseId = reclamation.Case__c;
            String reclamationName = reclamation.Name;
            String billingCity = reclamation.Account.BillingCity;
            String billingCountry = reclamation.Account.BillingCountry;
            String billingCountryCode = reclamation.Account.BillingCountryCode;
            String billingPostalCode = reclamation.Account.BillingPostalCode;
            String billingState = reclamation.Account.BillingState;
            String billingStateCode = reclamation.Account.BillingStateCode;
            String billingStreet = reclamation.Account.BillingStreet;
            String orderType = reclamation.Order_type__c;
            Opportunity reclamationToUpdate = new Opportunity();
            if (orderType == 'Reclamation'){
                reclamationToUpdate.Id = reclamationId;
                if (String.IsBlank(contractId)){
                    //Create Contract for Reclamation  
                    Try {                           
                        Contract c = new Contract(
                            AccountId = accountId,
                            BillingCity = billingCity,
                            BillingCountry = billingCountry,
                            BillingCountryCode = billingCountryCode,
                            BillingPostalCode = billingPostalCode,
                            BillingState = billingState,
                            BillingStateCode = billingStateCode,
                            BillingStreet = billingStreet,
                            Contract_type__c = 'Final Contract',
                            Opportunity__c = reclamationId,
                            Quote__c = quoteId,                           
                            Signing_status__c = 'Sent', //Simulate Signing
                            StartDate = system.today(),
                            Status = 'Draft' //Do not Activate Yet
                        ); 
                        insert c;
                        contractId = c.Id;
                        reclamationToUpdate.contractId =contractId;
                    } catch (Exception e) {
                        errorMessage = ('Error in Contract Creation: '+e.getMessage());
                    }
                }
                Id orderId = [SELECT Id,OpportunityId FROM Order WHERE OpportunityId = : reclamationId LIMIT 1]?.Id;
            	if (String.IsBlank(orderId)){
                    //Create Contract for Reclamation  
                    Try {
                    	Order o = new Order(
                            AccountId = accountId,
                            Pricebook2Id = pricebookId,
                            Name = reclamationName,
                            OpportunityId = reclamationId,
                            QuoteId = quoteId,
                            EffectiveDate = system.today(),
                            Status = 'Draft', // Just create a draft Order
                            BillingCity = billingCity,
                            BillingCountry = billingCountry,
                            BillingCountryCode = billingCountryCode,
                            BillingPostalCode = billingPostalCode,
                            BillingState = billingState,
                            BillingStateCode = billingStateCode,
                            BillingStreet = billingStreet,
                            ContractId = contractId
                    	);
            		insert o;
                    orderId = o.Id;
                    reclamationToUpdate.Order__c =orderId;
                    } catch (Exception e) {
                        errorMessage = ('Error in Order Creation: '+e.getMessage());
                    }
                }
                // Update Reclamation Opportunity
                try{
                    if (contractId != reclamationToUpdate.Id || orderId != reclamationToUpdate.Order__c){
                        update reclamationToUpdate;
                    } 
                } catch (Exception e) {
                    errorMessage = 'Error in opportunity update' + e.getMessage();
                }
            /*
            // Update Case 
            try{
                Case cUpdate = new Case();
                cUpdate.Order__c = o.Id;
                cUpdate.Id = oppRecord.Case__c;
                update cUpdate;
            }catch (Exception e) {
                errorMessage = 'Error in case update' + e.getMessage();
            }
            // Update Configuration Plan 
            try{
               Configuration__c configuration = [SELECT Id from Configuration__c where Case__c = :caseId limit 1];
                Configuration__c configUpdate = new Configuration__c();
                configUpdate.Order__c = o.Id;
                configUpdate.Id = configuration.Id;
                update configUpdate;
            }catch (Exception e) {
                errorMessage = 'Error in configuration update' + e.getMessage();
            }  */  
            }
        }
        if (String.isNotBlank(errorMessage)) {
            return errorMessage;
        } else {
            return 'Success';
        }
   }
                
}