/**================================================================
 * Name: TestDataFactory_AusPost
 * @description:Test Data Factory class for insertion of creating the data for objects.
 * @author: Vijay
 *
 * Date Modified      Modified By      Description of the update
 * 14/09/2020
 * ==============================================================*/
public class TestDataFactory_AusPost  {

   //Account Creation
    public static List<Account> createAccounts( Integer numberOfAccounts, boolean isInsertRec){
        List<Account> accounts = new List<Account>();
        for ( Integer i = 0 ; i < numberOfAccounts ; i++ ) {
            Account account = new Account();
            account.Name = 'Level'+String.ValueOf(i); 
            accounts.add( account);
            
        }
        if(isInsertRec){
            insert accounts; 
            
        }
        return accounts;        
    }

    //Contact Creation
    public static List<Contact> createContacts( Integer numberOfContacts, Id AccountId, boolean isInsertRec){
        List<Contact> contacts = new List<Contact>();
        for ( Integer i = 0 ; i < numberOfContacts ; i++ ) {
            
            Contact contact = new Contact();
            contact.FirstName = 'TestContactF'; 
            contact.LastName = 'TestContactL';  
            contact.Email = 'none'+i+'@yopmail.com';
            contacts.add(contact);
        }
        if(isInsertRec){
            insert contacts; 
        }
        return contacts;
        
    }
    
	//Case Creation
    public static List<Case> createCases( Integer numberOfCase, Id AccountId, boolean isInsertRec){
        List<Case> cases = new List<Case>();  
        for ( Integer i = 0 ; i < numberOfCase ; i++ ) { 
            
            Case case1 = new Case(); 
			case1.Status ='Closed';
			case1.Origin ='Web';
			case1.ContactId='0032w00000J9SxRAAV';
			case1.isProcessed__c= false;
			case1.secret_Key__c='';
			case1.Subject='Test Subject for WP API';
            cases.add(case1);            
        }
        if(isInsertRec){
            insert cases; 
        }
        return cases;        
    }
    
    

}