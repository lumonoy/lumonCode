import myDetails from '@salesforce/label/c.LP_Acc_My_Details';
import general from '@salesforce/label/c.LP_Acc_General';
import password from '@salesforce/label/c.LP_Acc_Password';
import logOut from '@salesforce/label/c.LP_Acc_Logout';
import firstName from '@salesforce/label/c.LP_Acc_First_Name';
import lastName from '@salesforce/label/c.LP_Acc_Last_Name';
import email from '@salesforce/label/c.LP_Acc_Email';
import address from '@salesforce/label/c.LP_Acc_Address';
import phone from '@salesforce/label/c.LP_Acc_Phone';
/*import customerService from '@salesforce/label/c.LP_Acc_Customer_Service';
import customerServiceUrl from '@salesforce/label/c.LP_Acc_Customer_Service_URL';
import contactSupport1 from '@salesforce/label/c.LP_Acc_Contact_Support_1';
import contactSupport2 from '@salesforce/label/c.LP_Acc_Contact_Support_2';*/
import userName from '@salesforce/label/c.LP_Acc_User_Name';
import changePassword from '@salesforce/label/c.LP_Acc_Change_Password';
import account from '@salesforce/label/c.LP_Acc_Account';
import changeMyPassword from '@salesforce/label/c.LP_Change_My_Password';
import save from '@salesforce/label/c.LP_Acc_Save_Btn';

export const myAccountLabels =  {
	myDetails : myDetails,
	general : general,
	password : password,
	logOut : logOut,
	firstName : firstName,
	lastName : lastName,
	email : email,
	address : address,
	phone : phone,
	userName : userName,
	changePassword : changePassword,
	changeMyPassword : changeMyPassword,
	account : account,
	save : save
};

import marketingPermission from '@salesforce/label/c.LP_Acc_Marketing_permissions';
import futureMessages from '@salesforce/label/c.LP_Acc_Future_Msgs';
import marketingDisclaimer1 from '@salesforce/label/c.LP_Acc_Marketing_Disclaimer_1';
import marketingDisclaimer2 from '@salesforce/label/c.LP_Acc_Marketing_Disclaimer_2';
import accPrivacy1 from '@salesforce/label/c.LP_Acc_Privacy_1';
import accPrivacy2 from '@salesforce/label/c.LP_Acc_Privacy_2';
import accPrivacyPolicy from '@salesforce/label/c.LP_Acc_Privacy_Policy';
import accPrivacyPolicyUrl from '@salesforce/label/c.LP_Acc_Privacy_Policy_Url';
import yes from '@salesforce/label/c.LP_Acc_Yes';
import no from '@salesforce/label/c.LP_Acc_No';
import sms from '@salesforce/label/c.LP_Acc_Sms';
import maintenanceTips from '@salesforce/label/c.LP_Acc_Maintenance_Tips';
import discountNews from '@salesforce/label/c.LP_Acc_Discount_News';
import newProductsServices from '@salesforce/label/c.LP_Acc_New_Product_Services';
import successTitle from '@salesforce/label/c.LP_Acc_Success_Save_Title';
import successMessage from '@salesforce/label/c.LP_Acc_Success_Save_Msg';

export const marketingLabels = {
	marketingPermission : marketingPermission,
	futureMessages : futureMessages,
	discountNews : discountNews,
	marketingDisclaimer1 : marketingDisclaimer1,
	marketingDisclaimer2 : marketingDisclaimer2,
	accPrivacy1 : accPrivacy1,
	accPrivacyPolicy: accPrivacyPolicy,
	accPrivacyPolicyUrl : accPrivacyPolicyUrl,
	accPrivacy2 : accPrivacy2,
	yes : yes,
	no : no,
	sms : sms,
	maintenanceTips : maintenanceTips,
	newProductsServices : newProductsServices,
	successMessage : successMessage,
	successTitle : successTitle
};

import Cookie_Headline from '@salesforce/label/c.LP_Cookie_Consent_Headline';
import Cookie_Content from '@salesforce/label/c.LP_Cookie_Consent_Content';
import Cookie_Button from '@salesforce/label/c.LP_Cookie_Consent_Button_Label';

export const cookieLabels = {
	cookieHeadline : Cookie_Headline,
	cookieContent:  Cookie_Content,
	cookieButton : Cookie_Button
};

import followUs from '@salesforce/label/c.LP_Footer_Follow_Us';
import residential from '@salesforce/label/c.LP_Footer_Residential';
import company from '@salesforce/label/c.LP_Footer_Company';
import lumonGroup from '@salesforce/label/c.LP_Footer_Lumon_Group';

export const footerLabels = {
	followUs    : followUs,
	residential : residential,
	company     : company,
	lumonGroup  : lumonGroup
};

import Login_Problem from '@salesforce/label/c.LP_Login_Problem_Msg';
import Contact_Support from '@salesforce/label/c.LP_Login_Contact_Support';
import Contact_Support_Url from '@salesforce/label/c.LP_Login_Customer_Service_Url';
import Login_Welcome from '@salesforce/label/c.LP_Login_Welcome_Msg';
import Login_Website_Url from '@salesforce/label/c.LP_Login_Website_Url';
import Login_Website_Label from '@salesforce/label/c.LP_Login_Website_Label';

export const loginLabels = {
	loginProblem : Login_Problem,
	contactSupport : Contact_Support,
	supportUrl : Contact_Support_Url,
	welcomeMsg : Login_Welcome,
	backToWebSiteUrl : Login_Website_Url,
	backToWebSiteLabel : Login_Website_Label
};

import myCasesNoCasesFound from '@salesforce/label/c.LP_My_Cases_No_Cases_Found';

export const myCasesLabels = {
	noCasesFound : myCasesNoCasesFound
};

import titleHome from '@salesforce/label/c.LP_Page_Title_Home';
import titleSupportCenter from '@salesforce/label/c.LP_Page_Title_Support_Center';
import titleMyCases from '@salesforce/label/c.LP_Page_Title_My_Cases';
import titleMyOrders from '@salesforce/label/c.LP_Page_Title_My_Orders';
import titleOrderHistory from '@salesforce/label/c.LP_Page_Title_Order_History';
import titleOrderDetail from '@salesforce/label/c.LP_Order_Details';
import titleOngoingShipments from '@salesforce/label/c.LP_Page_Title_Ongoing_Shipments';
import subTitle from '@salesforce/label/c.LP_Page_Sub_Title';
import subTitleHome from '@salesforce/label/c.LP_Page_Sub_Title_Home';

export const bannerTitles = {
	Order_Details :  titleOrderDetail,
	Home : titleHome,
	My_Cases : titleMyCases,
	My_Orders : titleMyOrders,
	Ongoing_Shipments : titleOngoingShipments,
	Order_History : titleOrderHistory,
	Support_Center : titleSupportCenter,
	Sub_Title : subTitle,
	Sub_Title_Home : subTitleHome
};

import installationStart from '@salesforce/label/c.LP_Installation_Start';
import installationComment from '@salesforce/label/c.LP_Installation_Comment';
import installationPreparation from '@salesforce/label/c.LP_Installation_Preparation';
import installationHeadline from '@salesforce/label/c.LP_Installation_Headline';

export const installationLabels = {
	installationStart : installationStart,
	installationComment : installationComment,
	installationPreparation : installationPreparation,
	installationHeadline : installationHeadline
};

import caseHeadline from '@salesforce/label/c.LP_Case_Headline';
import caseSubheadLine from '@salesforce/label/c.LP_Case_SubHeadline';
import caseOrderNumber from '@salesforce/label/c.LP_Case_Order_Number';

export const caseLabels = {
	caseHeadline : caseHeadline,
	caseSubheadLine : caseSubheadLine,
	caseOrderNumber : caseOrderNumber
};

import osHeadline from '@salesforce/label/c.LP_Ongoing_Shipments_Headline';
import osOrderNumber from '@salesforce/label/c.LP_Active_Order_Number';
import osOrderInstallationAddress from '@salesforce/label/c.LP_Active_Order_Installation_Address';
import osOrderTotalCost from '@salesforce/label/c.LP_Active_Order_Total_Cost';
import osOrderComment from '@salesforce/label/c.LP_Active_Order_Comment';
import myOrdersHeadline from '@salesforce/label/c.LP_My_Orders_Headline';

export const ongoingShipmentLabels = {
	headline : osHeadline,
	myOrdersHeadline : myOrdersHeadline,
	orderNumber : osOrderNumber,
	installationAddress : osOrderInstallationAddress,
	orderTotalCost : osOrderTotalCost,
	orOrderComment : osOrderComment
};

import contractHeadline from '@salesforce/label/c.LP_Contract_Headline';
import contractDate from '@salesforce/label/c.LP_Contract_Signed_Date';
import contractDownload from '@salesforce/label/c.LP_Contract_Download';

export const contractLabels = {
	headline   : contractHeadline,
	signedDate : contractDate,
	download   : contractDownload
};

import contactHeadline from '@salesforce/label/c.LP_Contact_Headline';

export const contactLabels = {
	headline : contactHeadline
};
import orderOrdered from '@salesforce/label/c.LP_Order_Path_Order_Placed';
import orderDelivery from '@salesforce/label/c.LP_Order_Path_Est_Delivery';
import orderInstallationStart from '@salesforce/label/c.LP_Order_Path_Installation_Start';

export const orderProgress = {
	orderOrdered : orderOrdered,
    orderDelivery : orderDelivery,
	orderInstallationStart : orderInstallationStart
};

import orderNo from '@salesforce/label/c.LP_Order_History_Order_No';
import installDate from '@salesforce/label/c.LP_Order_History_Install_Date';
import installAddress from '@salesforce/label/c.LP_Order_History_Install_Address';
import totalCost from '@salesforce/label/c.LP_Order_History_Cost';

export const orderHistoryLabels = {
	orderNo : orderNo,
	installDate : installDate,
	installAddress : installAddress,
	totalCost : totalCost
};

import productDetails from '@salesforce/label/c.LP_Order_Detail_Product_Details';
import orderTotalCost from '@salesforce/label/c.LP_Order_Detail_Total_Cost';
import orderAddress from '@salesforce/label/c.LP_Order_Detail_Install_Address';
import orderDate from '@salesforce/label/c.LP_Order_Detail_Install_Date';
import orderProduct from '@salesforce/label/c.LP_Order_Detail_Product';
import productName from '@salesforce/label/c.LP_Order_Detail_Product_Name';
import warrantyStart from '@salesforce/label/c.LP_Order_Detail_Warranty_Start';
import warrantyEnd from '@salesforce/label/c.LP_Order_Detail_Warranty_End';
import orderDetailsTitle from '@salesforce/label/c.LP_Order_Details';

export const orderDetailLabels = {
	productDetails : productDetails,
	totalCost : orderTotalCost,
	address:orderAddress,
	date:orderDate,
	orderProduct:orderProduct,
	productName:productName,
	warrantyStart:warrantyStart,
	warrantyEnd:warrantyEnd,
	orderDetailsTitle:orderDetailsTitle
};

import errorTitle from '@salesforce/label/c.LP_Error_Title';
import errorMessage from '@salesforce/label/c.LP_Error_Message';

export const errorLabels = {
	errorTitle: errorTitle,
	errorMessage: errorMessage
};