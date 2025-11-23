package socialMediaApp.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class NewsService {

    @Value("${news.api.base-url}")
    private String apiBaseUrl; // Giá trị sẽ là http://localhost:8090

    @Value("${news.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;

    public NewsService(RestTemplateBuilder builder) {
        this.restTemplate = builder.build();
    }

    public String getTopHeadlines() {
        // Spring Boot sẽ gọi: http://localhost:8090/v2/top-headlines...
        String url = apiBaseUrl + "/v2/top-headlines?country=us&apiKey=" + apiKey;
        return restTemplate.getForObject(url, String.class);
    }
}