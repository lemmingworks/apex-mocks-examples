@isTest
public class Stubbing_Test {

    @isTest
    private static void thenReturn_Example() {
    
        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);
        AccountsSelector mockSelector =
            (AccountsSelector)mocks.mock(AccountsSelector.class);

        mocks.startStubbing();

        // Can stub methods to return literal values
        mocks.when(mockApi.getLatestRate('GBP', 'USD'))
            .thenReturn(1.5);
        // ... or stub methods to return collections
        mocks.when(mockSelector.getAccountsWithIDs((Set<Id>)fflib_Match.anyObject()))
            .thenReturn(new List<Account>{
                new Account(Name = 'Netflix'),
                new Account(Name = 'Microsoft')
            });

        mocks.stopStubbing();

        // Test
        Decimal exchangeRate = mockApi.getLatestRate('GBP', 'USD');
        List<Account> selectedAccounts = mockSelector.getAccountsWithIDs(new Set<ID>{
            fflib_IDGenerator.generate(Account.SObjectType),
            fflib_IDGenerator.generate(Account.SObjectType)
        });

        // Assert
        System.assertEquals(1.5, exchangeRate);
        System.assertEquals(2, selectedAccounts.size());
        System.assertEquals('Netflix', selectedAccounts[0].Name);
        System.assertEquals('Microsoft', selectedAccounts[1].Name);
    }

    @isTest
    private static void thenReturnMulti_Example() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        mocks.startStubbing();

        // Can set up a series of different responses
        // for each successive call of the stubbed method.
        mocks.when(mockApi.getLatestRate('GBP', 'USD'))
            .thenReturnMulti(new List<Decimal>{ 1.0, 1.5, 2.0 });

        mocks.stopStubbing();

        // Test
        Decimal result1_0 = mockApi.getLatestRate('GBP', 'USD');
        Decimal result1_5 = mockApi.getLatestRate('GBP', 'USD');
        Decimal result2_0 = mockApi.getLatestRate('GBP', 'USD');

        Decimal resultExtraCall1 = mockApi.getLatestRate('GBP', 'USD');
        Decimal resultExtraCall2 = mockApi.getLatestRate('GBP', 'USD');

        // Assert
        System.assertEquals(1.0, result1_0);
        System.assertEquals(1.5, result1_5);
        System.assertEquals(2.0, result2_0);

        // Subsequent calls will continue to return the last stubbed response
        System.assertEquals(2.0, resultExtraCall1);
        System.assertEquals(2.0, resultExtraCall2);
    }

    @isTest
    private static void thenThrow_Example() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        mocks.startStubbing();

        mocks.when(mockApi.getLatestRate('INVALID_PARAM', 'USD'))
            .thenThrow(new BadRequest400Exception('Params must be valid iso currencies.'));

        mocks.stopStubbing();

        // Test and Assert
        try {
            mockApi.getLatestRate('INVALID_PARAM', 'USD');
            System.assert(false, 'Should have thrown an exception.');
        } catch(BadRequest400Exception ex) {
            System.assertEquals('Params must be valid iso currencies.', ex.getMessage());
        }
    }

    @isTest
    private static void thenThrow_DMLException_Example() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        DBService service = (DBService)mocks.mock(DBService.class);

        mocks.startStubbing();
        mocks.when(service.saveAccount((Account)fflib_Match.anySObject()))
            .thenThrow(new DmlException());
        mocks.stopStubbing();

        try {
            service.saveAccount(new Account());
            System.assert(false, 'Should have thrown an exception here.');
        } catch(Exception ex) {
            System.assert(ex instanceof DmlException);
        }
    }

    @isTest
    private static void thenThrowMulti_Example() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        // Stubbing
        mocks.startStubbing();

        mocks.when(mockApi.getLatestRate('INVALID_PARAM', 'USD'))
            .thenThrowMulti(new List<Exception>{
                new BadRequest400Exception('Invalid Params'),
                new RateLimit409Exception('Rate Limit')
            });

        mocks.stopStubbing();

        // Test and Assert
        try {
            mockApi.getLatestRate('INVALID_PARAM', 'USD');
            System.assert(false, 'Should have thrown an exception.');
        } catch(Exception ex) {
            System.assert(ex instanceof BadRequest400Exception);
            System.assertEquals('Invalid Params', ex.getMessage());
        }

        try {
            mockApi.getLatestRate('INVALID_PARAM', 'USD');
            System.assert(false, 'Should have thrown an exception.');
        } catch(Exception ex) {
            System.assert(ex instanceof RateLimit409Exception);
            System.assertEquals('Rate Limit', ex.getMessage());
        }

        try {
            mockApi.getLatestRate('INVALID_PARAM', 'USD');
            System.assert(false, 'Should have thrown an exception.');
        } catch(Exception ex) {
            // Subsequent calls will continue to throw the last configured Exception
            System.assert(ex instanceof RateLimit409Exception);
            System.assertEquals('Rate Limit', ex.getMessage());
        }
    }

    @isTest
    private static void doThrowWhen_Example() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ILogger mockLogger = (ILogger)mocks.mock(Logger.class);

        LoggingException logExp = new LoggingException('Log exception');

        // Stubbing
        mocks.startStubbing();
        ((ILogger)mocks.doThrowWhen(logExp, mockLogger))
            .log(fflib_Match.anyString());
        mocks.stopStubbing();

        // Test and Assert
        try {
            mockLogger.log('Test message');
            System.assert(false, 'Should have thrown an exception.');
        } catch(LoggingException ex) {
            System.assertEquals('Log exception', ex.getMessage());
        }
    }

    @isTest
    private static void doThrowWhen_MultiExceptionExample() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ILogger mockLogger = (ILogger)mocks.mock(Logger.class);

        LoggingException logExp1 = new LoggingException('Log exception 1');
        LoggingException logExp2 = new LoggingException('Log exception 2');
        
        // Stubbing
        mocks.startStubbing();
        List<LoggingException> loggingExceptions = new List<LoggingException>{ logExp1, logExp2 };
        ((ILogger)mocks.doThrowWhen(loggingExceptions,  mockLogger))
            .log(fflib_Match.anyString());
        mocks.stopStubbing();

        // Test and Assert
        try {
            mockLogger.log('First log');
            System.assert(false, 'Should have thrown an exception.');
        } catch(LoggingException ex) {
            System.assertEquals('Log exception 1', ex.getMessage());
        }

        try {
            mockLogger.log('Second log');
            System.assert(false, 'Should have thrown an exception.');
        } catch(LoggingException ex) {
            System.assertEquals('Log exception 2', ex.getMessage());
        }

        try {
            mockLogger.log('Third log');
            System.assert(false, 'Should have thrown an exception.');
        } catch(LoggingException ex) {
            // Continues to return the last configured exception.
            System.assertEquals('Log exception 2', ex.getMessage());
        }
    }

    //---------------------------------------------------------------
    // Gotchas and further details
    //---------------------------------------------------------------

    @isTest
    private static void unstubbedMethodsReturnNull() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        // NO STUBBS SET UP

        // Test
        Decimal result = mockApi.getLatestRate('GBP', 'USD');

        // Assert
        System.assertEquals(null, result);
    }

    @isTest
    private static void nullIsAValidReturnValue() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        // Stubbing
        mocks.startStubbing();
        // Explictly returning null is for thenReturn()
        mocks.when(mockApi.getLatestRate('GBP', 'USD')).thenReturn(null);
        mocks.stopStubbing();

        // Test
        Decimal result = mockApi.getLatestRate('GBP', 'USD');

        // Assert
        System.assertEquals(null, result);
    }

    @isTest
    private static void multiMethodsCantBePassedNull() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        // Stubbing will throw an exception
        mocks.startStubbing();
        try {
            // However thenReturnMulti() and thenThrowMulti() can't
            // have null as an argument.
            mocks.when(mockApi.getLatestRate('GBP', 'USD')).thenReturnMulti(null);
            System.assert(false, 'Should have thrown an exception.');
        } catch(Exception ex) {
            System.assert(ex instanceOf fflib_ApexMocks.ApexMocksException);
        }
        mocks.stopStubbing();
    }

    @isTest
    private static void multiMethodsCantBePassedEmptyList() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        // Stubbing will throw an exception
        mocks.startStubbing();
        try {
            // Nor can thenReturnMulti() and thenThrowMulti()
            // be passed an empty list.
            mocks.when(mockApi.getLatestRate('GBP', 'USD'))
                .thenReturnMulti(new List<Decimal>());
            System.assert(false, 'Should have thrown an exception.');
        } catch(Exception ex) {
            System.assert(ex instanceOf fflib_ApexMocks.ApexMocksException);
        }
        mocks.stopStubbing();
    }

    @isTest
    private static void thenReturn_ReturningListExample() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        mocks.startStubbing();
        mocks.when(mockApi.getValidCurrencies())
            .thenReturn(new List<String>{ 'USD', 'GBP', 'EUR' });
        mocks.stopStubbing();

        // Test
        List<String> currencies = mockApi.getValidCurrencies();

        // Assert
        System.assertEquals(3, currencies.size());
        System.assertEquals('USD', currencies[0]);
        System.assertEquals('GBP', currencies[1]);
        System.assertEquals('EUR', currencies[2]);
    }

    @isTest
    private static void thenReturn_ListParamExample() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IExchangeRateAPI mockApi =
            (IExchangeRateAPI)mocks.mock(ExchangeRateAPI.class);

        mocks.startStubbing();
        mocks.when(mockApi.getLatestRate(new List<String>{ 'USD', 'GBP' }))
            .thenReturn(1.5);
        mocks.stopStubbing();

        // Test
        Decimal result = mockApi.getLatestRate(new List<String>{ 'USD', 'GBP' });

        // Assert
        System.assertEquals(1.5, result);
    }

    @isTest
    private static void MustHaveAttachedAnswer() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        // Oops! Forgot to set up a response when stubbing this method
        mocks.when(mockFX.getRate('GBP', 'USD'));
        mocks.stopStubbing();

        
        try {
            // Throws exception
            mockFX.getRate('GBP', 'USD');
            System.assert(false, 'Should have thrown an exception here');
        } catch(fflib_ApexMocks.ApexMocksException ex) {
            System.assert(true);
        }
    }
}
