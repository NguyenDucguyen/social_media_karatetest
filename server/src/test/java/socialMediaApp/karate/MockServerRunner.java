package socialMediaApp.karate;

import com.intuit.karate.core.MockServer;

public class MockServerRunner {

    public static void main(String[] args) {
        MockServer server = MockServer
                .feature("classpath:socialMediaApp/karate/mocks/news-mock.feature")
                .http(8090)
                .build();
        // Giữ server sống
        server.waitSync();
    }
}