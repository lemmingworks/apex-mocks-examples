public interface IExchangeRateAPI {
    Decimal getLatestRate(String fromIsoCurrency, String toIsoCurrency);
    Decimal getLatestRate(List<String> fromToIsoCurrencies);
    List<String> getValidCurrencies();
}
