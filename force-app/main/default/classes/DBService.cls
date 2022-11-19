public class DBService {
    
    public Account saveAccount(Account acc) {
        upsert acc;
        return acc;
    }
}
