@isTest
private class LP_MainControllerTest {
	@TestSetup
	static void setup() {
		List<User> adminUser = [
			SELECT
				Id
			FROM User
			WHERE Profile.Name = 'System Administrator'
			AND UserRoleId != null
			AND IsActive = TRUE
			LIMIT 1
		];

		System.runAs(adminUser[0]){
			Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
			List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Name = 'Lumon Customer Portal User' LIMIT 1];
			Blob b = Crypto.GenerateAESKey(128);
			String h = EncodingUtil.ConvertTohex(b);
			String uid = h.SubString(0,6);

			Account acc = new Account();
			acc.RecordTypeId = recordTypeId;
			acc.FirstName = 'Peter';
			acc.LastName = 'Griffin';
			acc.PersonEmail = uid + '@gmail.com';
			acc.PersonMailingCity = 'Helsinki';
			acc.PersonMailingCountry = 'Finland';
			acc.PersonMailingStreet = 'Spooner St. 31';
			acc.PersonMailingPostalCode = '00100';
            acc.BillingCountry ='Finland';
            acc.BillingCity='Helsinki';
            acc.BillingPostalCode = '00100';
            acc.BillingStreet = 'Spooner St. 31';
			insert acc;

			System.assertEquals(true, acc.Id != null, 'Person Account was not created');
			List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId =: acc.Id AND IsPersonAccount = TRUE];

			User u = new User(
					Alias = uid,
					Email = uid + '@myorg.com',
					EmailEncodingKey = 'UTF-8',
					LastName = 'McTesterston',
					LanguageLocaleKey ='en_US',
					LocaleSidKey ='en_US',
					ProfileId = profiles[0]?.Id,
					TimeZoneSidKey = 'America/New_York',
					UserName = uid + '@myorg.com',
					IsActive=true,
					ContactId = contacts[0]?.Id
			);
			insert u;
			System.assertEquals(true, u.Id != null, 'Portal User was not created');

			Contract contract = new Contract();
			contract.AccountId = acc.Id;
			insert contract;

			Case c = new Case();
			c.Subject = 'Case test by McTesterston';
			c.ContactId = contacts[0]?.Id;
			insert c;

			System.assertEquals(true, c.Id != null, 'Case was not created');

			Id b2cRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('B2C_Opportunity').getRecordTypeId();

			Opportunity opp = new Opportunity();
			opp.RecordTypeId = b2cRecordTypeId;
			opp.AccountId = acc.Id;
			opp.Name = 'McTesterson OPPO';
			opp.StageName = 'Contract Signed';
			opp.Property_Type__c = 'APA';
			opp.LeadSource = 'Shows';
			opp.CloseDate = System.today() + 30;
			//opp.Building__c = building.Id;
			insert opp;

			System.assertEquals(true, opp.Id != null, 'Opportunity was not created');

			ContentVersion newFile = new ContentVersion();
			newFile.PathOnClient = 'TestFile';
			newFile.Title = 'B2C Contract_signed.pdf';
			newFile.PathOnClient = 'B2C Contract_signed.pdf';
			newFile.VersionData = Blob.valueOf('sample content');
			insert newFile;

			ContentVersion insertedFile = [SELECT Id, ContentDocumentId, FileExtension FROM ContentVersion WHERE Id =:newFile.Id];

			ContentDocumentLink linkedFile = new ContentDocumentLink(
					LinkedEntityId=opp.Id,
					ContentDocumentId=insertedFile.ContentDocumentId
			);
			insert linkedFile;

			Product2 product = new Product2(Name = 'Product TEST');
			insert product;
			Pricebook2 pB = new Pricebook2(Name = 'test PB');
			insert pB;
			PricebookEntry pBE1 = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = Test.getStandardPricebookId(), UnitPrice = 10);
			PricebookEntry pBE2 = new PricebookEntry(Product2Id = product.Id, Pricebook2Id = pB.Id, UnitPrice = 10);
			insert pBE1;
			insert pBE2;

			Order o = new Order();
			o.AccountId = acc.Id;
			o.OpportunityId = opp.Id;
			o.Pricebook2Id = pB.Id;
			o.EffectiveDate = System.today() + 30;
			o.Status = 'Draft';
			o.Confirmed_installation_time__c = System.today() + 30;
			o.ShippingCity = 'Helsinky';
			o.ShippingPostalCode = '9849 01';
			o.BillingCountry = 'Finland';
			insert o;

			List<String> productGroupNames = new List<String>{'LG','LGS','LUMONKAIDE'};
			List<OrderItem> oItems = new List<OrderItem>();
			for(Integer i = 0; i < 3;i++){
				OrderItem oI = new OrderItem();
				oI.OrderId = o.Id;
				oI.PricebookEntryId = pBE2.Id;
				oI.UnitPrice = 100 + i;
				oI.Quantity = 1.00 + i;
				oI.Product_Group__c = productGroupNames.get(i);
				oItems.add(oI);
			}
			insert oItems;
			System.debug('O item ID ' + oItems[1].Id + ' ### ' + oItems[1].OrderId);

			System.assertEquals(3, oItems.size(), '3 Order Items were not created');
		}
	}
	@isTest
	static void testLPMainControllerMethods() {
		// TODO add asserts to the test methods results
		Test.startTest();
		List<User> users = [SELECT Id, ContactId FROM User WHERE LastName = 'McTesterston' LIMIT 1];
		/*List<Order> orders = LP_MainController.fetchOrderHistory(users[0]?.ContactId);
		System.assertEquals(2, orders.size(), 'Two orders were not fetched for McTesterston.');*/

		List<Case> myCases = LP_MainController.fetchMyCases(users[0]?.ContactId);
		System.assertEquals(1, myCases.size(), 'One case was not fetched for McTesterston.');

		List<Account> myAccount = LP_MainController.fetchMyAccountDetails(users[0]?.ContactId);
		System.assertEquals(1, myAccount.size(), 'My Account was not fetched.');

		LP_MainController.updateAccount(myAccount[0]);

		String myOrdersSTR = LP_MainController.fetchMyOrders(users[0]?.ContactId);
		List<LP_MainControllerUtil.OrderWrapper> orderWrappers =
				(List<LP_MainControllerUtil.OrderWrapper>) System.JSON.deserialize(myOrdersSTR, List<LP_MainControllerUtil.OrderWrapper>.class);
		System.assertEquals(1, orderWrappers.size(), 'One custom order wrapper was not fetched.');

		LP_MainController.fetchContactInformation(orderWrappers[0]?.orderId);
		LP_MainController.fetchOrderDetails(orderWrappers[0]?.orderId);

		Test.stopTest();
	}
}