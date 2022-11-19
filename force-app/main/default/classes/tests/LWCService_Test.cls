@isTest
public class LWCService_Test {
    
    @isTest 
    private static void TestInit() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            .thenReturn(1.5);
        mocks.stopStubbing();

        // Test
        LWCService.fxService = mockFX;

        // Assert
        System.assertEquals(1.5, LWCService.fxService.getRate('GBP', 'USD'));
    }

    @isTest
    private static void ThenReturn_Test() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            .thenReturn(1.5);
        mocks.stopStubbing();
        
        // Test
        LWCService.fxService = mockFX;
        LWCService.Response response = LWCService.GetFXRate('GBP', 'USD');

        // Assert
        System.assert(response.isSuccess);
        System.assertEquals(1.5, response.data);
    }

    @isTest
    private static void ThenThrow_Test() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('Wibble', 'USD'))
            .thenThrow(new BadRequest400Exception(
                'Currency arguments must be currency iso codes'
            ));
        mocks.stopStubbing();

        // Test
        LWCService.FXService = mockFX;
        LWCService.Response result = LWCService.GetFXRate('Wibble', 'USD');

        // Assert
        System.assertEquals(false, result.isSuccess);
        System.assertEquals('Currency arguments must be currency iso codes', result.message);
    }

    @isTest
    private static void ThenThrowMulti_Test() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            .thenThrowMulti(new List<Exception>{
                new ServerError500Exception('Argh!'),
                new ServerError500Exception('Yikes!'),
                new ServerError500Exception('Oh no!')
            });
        mocks.stopStubbing();

        // Test
        LWCService.FXService = mockFX;
        LWCService.Response response = LWCService.GetFXRate('GBP', 'USD');

        // Assert
        System.assertEquals(false, response.isSuccess);
        System.assertEquals('We would politely like to inform you that our FX api has gone to s%@t', response.message);
        ((FXService)mocks.verify(mockFX, 3)).getRate('GBP', 'USD');
    }

    @isTest
    private static void Chaining_Test() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            .thenThrowMulti(new List<Exception>{
                new ServerError500Exception('Argh!'),
                new ServerError500Exception('Yikes!')
            })
            .thenReturn(1.5);
        mocks.stopStubbing();

        // Test
        LWCService.FXService = mockFX;
        LWCService.Response response = LWCService.GetFXRate('GBP', 'USD');

        // Assert
        System.assertEquals(true, response.isSuccess);
        System.assertEquals(1.5, response.data);
        ((FXService)mocks.verify(mockFX, 3)).getRate('GBP', 'USD');
    }

    @isTest
    private static void Verify_VoidMethods() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);
        Logger mockLogger = (Logger)mocks.mock(Logger.class);
        Emailer mockEmailer = (Emailer)mocks.mock(Emailer.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            .thenThrowMulti(new List<Exception>{
                new ServerError500Exception('Argh!'),
                new ServerError500Exception('Argh!'),
                new ServerError500Exception('Argh!')
            });
        mocks.stopStubbing();

        // Test
        LWCService.fxService = mockFX;
        LWCService.logger = mockLogger;
        LWCService.emailer = mockEmailer;
        LWCService.Response response = LWCService.GetFXRate('GBP', 'USD');

        // Assert
        ((Logger)mocks.verify(mockLogger, 3)).log('Argh!');
        ((Emailer)mocks.verify(mockEmailer, 1)).notifyAdmins();
    }

    @isTest
    private static void ThenReturn_Anything() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRates())
            .thenReturn(new List<Decimal>{1, 2, 3 });
        mocks.stopStubbing();

        // Test
        List<Decimal> result = mockFX.getRates();

        // Assert
        System.assertEquals(1, result[0]);
        System.assertEquals(2, result[1]);
        System.assertEquals(3, result[2]);
    }

    @isTest
    private static void NullMatchingParameter_Test() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate(null, 'GBP'))
            .thenThrow(new BadRequest400Exception('Invalid Parameter'));
        mocks.stopStubbing();

        // Test
        try {
            mockFX.getRate(null, 'GBP');
            System.assert(false, 'Should have thrown');
        } catch(BadRequest400Exception ex400) {
            System.assertEquals('Invalid Parameter', ex400.getMessage());
        }
    }

    @isTest
    private static void MustHaveAttachedAnswer() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'));
        mocks.stopStubbing();

        // Throws exception
        mockFX.getRate('GBP', 'USD');
    }

    @isTest
    private static void MultiMethodsExceptionThrownIfNull() {

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        try {

            mocks.startStubbing();
            mocks.when(mockFX.getRate('GBP', 'USD'))
                .thenThrowMulti(null);
            mocks.stopStubbing();

        } catch(fflib_ApexMocks.ApexMocksException ex) {
            System.assert(true);
        }
    }
}
