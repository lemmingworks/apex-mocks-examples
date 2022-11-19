@isTest
public class LWCService_Test {

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
            .thenThrow(new ServerError500Exception(
                'Something bad happened'
            ));
        mocks.stopStubbing();

        // Test
        LWCService.FXService = mockFX;
        LWCService.Response result = LWCService.GetFXRate('Wibble', 'USD');

        // Assert
        System.assertEquals(false, result.isSuccess);
        // A user-readable message is sent back to the UI
        // NOT the stack trace or message from the Exception.
        System.assertEquals(Label.UserReadableMessage, result.message);
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
        System.assertEquals(Label.UserReadableMessage, response.message);
        // Confirm the retry mechanism really did try 3 times.
        ((FXService)mocks.verify(mockFX, 3)).getRate('GBP', 'USD');
    }

    @isTest
    private static void Chaining_Test() {

        // Setup
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        FXService mockFX = (FXService)mocks.mock(FXService.class);

        mocks.startStubbing();
        mocks.when(mockFX.getRate('GBP', 'USD'))
            // First 2 attempts fail
            .thenThrowMulti(new List<Exception>{
                new ServerError500Exception('Argh!'),
                new ServerError500Exception('Yikes!')
            })
            // But the final retry succeeds
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
}
