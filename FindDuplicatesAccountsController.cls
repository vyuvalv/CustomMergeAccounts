public with sharing class FindDuplicatesAccountsController {

	private ApexPages.StandardController std;
    
    //List of type of our wrapper class
    Public List<AccDisplayWrapper> accWrapperList {get; set;}
    public List<Account> selectedAccounts{get;set;}
    public String message {get;set;}
    public Boolean success {get;set;}
    
    /*This is the constructor for class*/
    public FindDuplicatesAccountsController(ApexPages.StandardController controller){
        std = controller;
        wrapperAccountData();
       
        message = 'No Records were Selected'; //initial msg
            //'/merge/accmergewizard.jsp?goNext=+Next+&cid=' + acc1Id + '&cid=' +acc2Id;
                   
    } 
    
    //Get Main Object record to Page
    public Account getAccount()     {
     return (Account) std.getRecord();
    }
    
    Public Account currentAccountFields;
    public Account getCurrentAccountFields()     {
        if(null!=getAccount().Id) {
        currentAccountFields = [Select Id, Name, AccountNumber,  Type, Industry,BillingStreet, BillingCity,BillingPostalCode from Account Where Id=:getAccount().Id];
        }
     return currentAccountFields;
    }
    
    public void wrapperAccountData() {
        if(accWrapperList == null) {
            //Create new instance of the list that will store wrapper class instances
            accWrapperList = new List<AccDisplayWrapper>();
            
            //Query some Accounts records randomly
            for(Account acc: [select Id, Name, AccountNumber, Type, Industry,BillingStreet, BillingCity,BillingPostalCode from Account Where AccountNumber=:getCurrentAccountFields().AccountNumber limit 4]) {
                // add the Account records and bollean flag to the wrapper class instances one by one
                accWrapperList.add(new AccDisplayWrapper(acc,true));
            }
        }
    }
    
    
    /*This is the wrapper class*/
    public class AccDisplayWrapper {
        
        public Account AccRec  {get; set;}
        public Boolean AccFlag {get; set;}
        
        /*This is the constructor for wrapper class*/ 
        public AccDisplayWrapper (Account acc,Boolean accflagvalue) {
            AccRec = acc;
            AccFlag= accflagvalue;
        }
    }

    public PageReference Save() {
    	
    	boolean result=true;
    	PageReference pr=Page.AccountFindDuplicatesVF;
       
        if (result)      {
            // call standard controller save
            std.save();
            pr.setRedirect(true);
            pr.getParameters().put('id', getAccount().id);
            return pr;
         }
         else      {
          return null;
         }

    }
	
    public void processSelected() {
    selectedAccounts = new List<Account>();
 
        for(AccDisplayWrapper wrapAccountObj : accWrapperList) {
            if(wrapAccountObj.AccFlag == true) {
                selectedAccounts.add(wrapAccountObj.AccRec);
            }
        }
    }
    
    	Id acc1Id {get;set;} 
        Id acc2Id {get;set;} 
		Id acc3Id {get;set;} 
        Id acc4Id {get;set;} 
        Id acc5Id {get;set;} 
    
    public PageReference processRedirect() { 
   		processSelected();
        
        String URLLink = '/merge/accmergewizard.jsp?goNext=+Next+&cid=';
        
        if (2 >selectedAccounts.size()){
        success=false;
        message ='Cannot merge less than 2 Records';
        }
        if (2 ==selectedAccounts.size()){
        acc1Id = selectedAccounts[0].Id;
        acc2Id = selectedAccounts[1].Id;
      	success=true;
        message = URLLink +acc1Id + '&cid=' + acc2Id;
        }
        if (3 ==selectedAccounts.size()){
        acc1Id = selectedAccounts[0].Id;
        acc2Id = selectedAccounts[1].Id;
        acc3Id = selectedAccounts[2].Id;
      	success=true;
        message =URLLink + acc1Id + '&cid=' + acc2Id + '&cid=' + acc3Id;
        }
        if (4 ==selectedAccounts.size()){
        acc1Id = selectedAccounts[0].Id;
        acc2Id = selectedAccounts[1].Id;
        acc3Id = selectedAccounts[2].Id;
        acc4Id = selectedAccounts[3].Id;
      	success=true;
        message =URLLink + acc1Id + '&cid=' + acc2Id + '&cid=' + acc3Id + '&cid=' + acc4Id;
        }
        
    return null;
  }
    
   
    
    
    
}