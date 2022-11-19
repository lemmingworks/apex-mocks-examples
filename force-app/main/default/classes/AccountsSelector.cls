public class AccountsSelector {
    
    public List<Account> getAccountsWithIDs(Set<Id> accountIds) {
        return [
            Select Id, Name
            From Account
            Where ID IN :accountIds
        ];
    }
}
