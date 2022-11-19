public class ExchangeRateAPI implements IExchangeRateAPI {
    
    public Decimal getLatestRate(String fromIsoCurrency, String toIsoCurrency) {
        // Real-version would implement getting data
        // from an API using HTTPRequests.
        return null;
    }

    public Decimal getLatestRate(List<String> fromToIsoCurrencies) {
        return null;
    }

    public List<String> getValidCurrencies() {
        return null;
    }
}
