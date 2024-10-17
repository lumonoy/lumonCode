/**
 * @description       : 
 * @author            : Henk Reynders
 * @group             : 
 * @last modified on  : 09-10-2024
 * @last modified by  : Henk Reynders
**/
public with sharing class DynamicListViewController { 
    @AuraEnabled
    public static List<ListView> getlistView(String objectType){
        List<ListView> listViews = [SELECT id, Name, DeveloperName 
                                    FROM ListView
                                    WHERE sObjectType = : objectType 
                                    ORDER BY Name ASC];
        return listViews;
    }
    @AuraEnabled
    public static List<ListViewData> getListViewData(String objectType){
        List<ListViewData> listViewDatas = new List<ListViewData>();
        List<ListView> listViews = getListView(objectType);
        for(ListView listView : listViews){ 
            ListViewData viewData = new ListViewData();
            viewData.label = listView.Name;
            viewData.developerName = listView.DeveloperName;
            listViewDatas.add(viewData);
        }
        
        return listViewDatas; 
    }

    /*wrapper class to store listView details*/ 
    public class ListViewData{
        @AuraEnabled public string label{get;set;} 
        @AuraEnabled public string developerName{get;set;} 
    }
}