/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 05-22-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class QuotingManager {
    //19.10.2023 User Interface Feedback 
    public static void sendFeedback (String key, String recordId, 
                                        String title, String message,
                                            String mode, String variant ){
        FeedbackEvent.publishFeedbackEvent(key,recordId, title, message, mode, variant);
    }
    public static void initiateNextStage (String cfgType, String cfgAction,
                                            String cfgPlanId, String recordId,
                                            String sObjectType, String visualPlanId,
                                            String cfgDocLinkId, String configJSON){
        ConfigurationEvent.publishConfigurationEvent(cfgType,cfgAction,cfgPlanId,
                                                        recordId,sObjectType,
                                                            visualPlanId,cfgDocLinkId,configJSON);
    }
    public static void executeQuotingProcess( String configType, String configAction,
                                        String configId, String recordId,
                                        String objectType, String visualPlanId,
                                        String documentId, String configJSON){
        System.debug('--- QuotingManager - Execute Pricing Process');
        // Confguration Event Variables
        String errorMessage;
        String statusMessage;
        String processingResult;
        String calculationResult;
        String reclamationResult;                                    
        String cfgType = configType; // Context Quote, Visual, Blinds, Services etc
        String cfgAction = configAction; // Configure, Quote, Price, Clone, Delete, Refresh
        String cfgRecordId = recordId; // Record from where Action is initiated
        String cfgObjectType = objectType;  // ObjectType of Record from where Action is initiated
        String cfgPlanId = configId; // Provide Id of Plan that was Updated
        String cfgVisualId = visualPlanId;// Used only when Actions are specific to a Visual Plan
        String cfgDocLinkId = documentId; // Related File that contains JSON
        String cfgJSON = configJSON;// JSON To Process
        // Feedback Event Variables
        String key = 'cpqProcess'; //Toast Message ID
        String ltngRecordId = recordId; //Eg Opportunity.Id
        String title = 'CPQ Process'; // Toast Title
        String message; //Message Body
        String mode = 'dismissable'; // dismissable, pester or sticky
        String variant = 'success'; //info , success, warning or error.
        // CPQ Custom Settings
        CPQ_Settings__c cpqSettings = CPQSettingsController.getCPQSettings();
        Boolean usePriceList =  cpqSettings.Use_Pricelist__c;
        Boolean useItemGroups =  cpqSettings.Group_Items__c;
        Boolean useEnhanced =  cpqSettings.Enhanced_Pricing__c;
        // Initiate Process
        // Stage 1 Configure: Add/Edit Configurations of one ore more Types
        if (configAction == 'Configure'){
            // Only for Visual Configuration Processing -> One Plan at a Time
            if (configType == 'Visual'){ 
                System.debug('--- QuotingManager - Process Visual Configuration!');
                // Read the Visual Pricing JSON and create or update Configuration Objects
                try{
                    statusMessage ='Processing Visual Configuration';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    processingResult = ConfigurationController.processVisualConfiguration( configId,recordId, configJSON);
                } catch (Exception e) {
                    errorMessage = 'Error in Processing Visual Configuration' + e.getMessage();
                    sendFeedback(key,recordId,title,errorMessage,mode,'error');
                }
                if (String.isNotBlank(processingResult)) {
                    initiateNextStage('Calculate','Price',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                }
            // 19.10.2023 added Only Blinds Configuration Processing -> One Plan at a Time
            } else if ((configType == 'Sovelia')|| (configType == 'Blinds')){
                try{ 
                    statusMessage ='Processing Sovelia Configuration';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    System.debug('--- QuotingManager - Process Sovelia Configuration!');
                    processingResult = ConfigurationController.processSoveliaConfiguration( configId,recordId, configJSON);
                } catch (Exception e) {
                    errorMessage = 'Error in Processing Sovelia Configuration' + e.getMessage();
                    sendFeedback(key,recordId,title,errorMessage,mode,'error');
                }
                if (String.isNotBlank(processingResult)) {
                    initiateNextStage('Calculate','Price',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                }
            } else if (configType == 'Services'){ 
                statusMessage ='Processing Services Configuration';
                sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    System.debug('--- QuotingManager - Process Services Configuration!');
            } else if (configType == 'Spares'){ 
                statusMessage ='Processing Spares Configuration';
                sendFeedback(key,recordId,title,statusMessage,mode,'info');
                System.debug('--- QuotingManager - Process Spare Part Configuration!');
            } else if ((configType == 'Configurator')){
                try{ 
                    statusMessage ='Processing Sovelia/Visual Configuration';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    System.debug('--- QuotingManager - Process Sovelia/Visaul Configuration!');
                    processingResult = ConfigurationProcessor.processConfiguration( configId,recordId, configJSON);
                } catch (Exception e) {
                    errorMessage = 'Error in Processing Sovelia/Visual Configuration' + e.getMessage();
                    sendFeedback(key,recordId,title,errorMessage,mode,'error');
                }
                if (String.isNotBlank(processingResult)) {
                    initiateNextStage('Calculate','Price',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                }
            } else { 
                System.debug('--- QuotingManager - Process Unknown Configuration!');
                // Read the Visual Pricing JSON and create or update Configuration Objects         
            }
        // Stage 2 Price: Calculate Prices for use in the Pricing Component
        } else if (configAction == 'Price'){ 
            if (configType == 'Calculate'){ 
                try{ 
                    statusMessage ='Preparing QuoteLine Items and Calculate Prices';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    System.debug('--- QuotingManager - Prepare QuoteLine Items!');
                    processingResult = PricingController.upsertQuoteLines(recordId);
                } catch (Exception e) {
                    errorMessage = 'Error in Preparing Quote Line Items' + e.getMessage();
                    sendFeedback(key,recordId,title,errorMessage,mode,'error');
                }
                if (String.isNotBlank(processingResult)) {
                    //initiateNextStage('Update','Pricing',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                    initiateNextStage('Schedule','Quote',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                }
            } 
        // Stage 3 Quote
        } else if (configAction == 'Quote'){
            if (configType == 'Schedule'){ 
                Map<String, Object> flowParams = new Map<String, Object>();
                flowParams.put('recordId',recordId);
                //create instance of Interview
                Flow.Interview.Assign_Lead_Times_SubFlow leadTimeFlow = new Flow.Interview.Assign_Lead_Times_SubFlow (flowParams);
                //Invoke start method
                leadTimeFlow .start();
                //get value from Flow
                Opportunity updatedOpportunity =(Opportunity)leadTimeFlow.getvariableValue('recOpportunityToUpdate');
                statusMessage ='Updating Lead Times';
                sendFeedback(key,recordId,title,statusMessage,mode,'info');
                system.debug('--- QuotingManager - LeadTime Updated for '+updatedOpportunity ); 
                if(cfgObjectType == 'Case' || cfgObjectType == 'Opportunity'){
                    initiateNextStage('Generate','Quote',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                }
            } else if (configType == 'Generate'){  
                try{ 
                    statusMessage ='Preparing Product Attributes';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
                    System.debug('--- QuotingManager - Prepare Product Attributes!');
                    // NEXT RELEASE ConfigurationAttributeController.getConfigurationAttributes(Id.valueOf(recordId));
                    ConfigurationDataController.populateAdditionalProductParameters(Id.valueOf(recordId)); 

                    processingResult = 'Successfully updated Product Attributes';
                } catch (Exception e) {
                    errorMessage = 'Error in Preparing Product Attributes' + e.getMessage();
                    sendFeedback(key,recordId,title,errorMessage,mode,'error');
                }
                if (String.isNotBlank(processingResult)) {
                    if(cfgObjectType == 'Case' || cfgObjectType == 'Opportunity'){
                        initiateNextStage('Prepare','Order',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                    }
                }
            } else if (configType == 'Approved'){ 
                statusMessage ='Quote Approved';
                sendFeedback(key,recordId,title,errorMessage,mode,'success');

            } else if (configType == 'Closed'){ 
                statusMessage ='Quote Closed';
                sendFeedback(key,recordId,title,errorMessage,mode,'success');
            }
        // Stage 4 Contract
        } else if (configAction == 'Contract'){
            if (configType == 'Prepare'){ 
            } else if (configType == 'Activated'){ 
                statusMessage ='Contract Activated, Prices can not be Updated';
                sendFeedback(key,recordId,title,errorMessage,mode,'warning');
            }
        // Stage 5 Order
        } else if (configAction == 'Order'){
            if (configType == 'Prepare'){ 
                 Try {
                    if(cfgObjectType == 'Opportunity'){
                        String orderType = [SELECT Id, Order_Type__c FROM Opportunity WHERE Id =: recordId]?.Order_Type__c;
                        if (orderType == 'Reclamation') {
                            processingResult = ReclamationController.prepareOrder(recordId);
                            statusMessage ='Reclamation Order updated successfully';
                            sendFeedback(key,recordId,title,statusMessage,mode,'info');
                        }
                    }
                 } catch (exception e)  {
                    statusMessage ='Exception Order Update '+e.getMessage();
                    sendFeedback(key,recordId,title,statusMessage,mode,'error');
               }  
               if (String.isNotBlank(processingResult)) {
                    if(cfgObjectType == 'Case' || cfgObjectType == 'Opportunity'){
                        initiateNextStage('Update','Order',cfgPlanId,cfgRecordId,cfgObjectType,cfgVisualId,cfgDocLinkId,cfgJSON);
                    }
                }
            } else if (configType == 'Update'){               
                Try {
                    processingResult = OrderTriggerHandler.upsertOrderLineItems(recordId);
                    statusMessage ='Order line Items Updated successfully';
                    sendFeedback(key,recordId,title,statusMessage,mode,'info');
               } catch (exception e)  {
                    statusMessage ='Exception Order Update '+e.getMessage();
                    sendFeedback(key,recordId,title,statusMessage,mode,'error');
               }   
            } else if (configType == 'Activated'){  
                statusMessage ='Order Activated, Configuration and Prices can not be Updated';
                sendFeedback(key,recordId,title,errorMessage,mode,'warning');
            }
        // Stage 6 Produce
        // Stage 7 Deliver
        // Stage 8 Install
        // Stage 9 Warrant - After Sales/Reclamation      
        // Stage 10 Close                              
        }                       
    }
    
}