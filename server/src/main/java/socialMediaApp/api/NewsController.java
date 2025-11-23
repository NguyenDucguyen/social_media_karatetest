package socialMediaApp.api;



import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class NewsController {

    @Value("${news.api.base-url}")
    private String apiBaseUrl; // http://localhost:8090

    @Value("${news.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate = new RestTemplate();


    @GetMapping("/api/news/headlines")
    public String getHeadlines(
            @RequestParam(required = false, defaultValue = "us") String country,
            @RequestParam(required = false) String category
    ) {
        String url = apiBaseUrl + "/v2/top-headlines?apiKey=" + apiKey + "&country=" + country;
        if (category != null) {
            url += "&category=" + category;
        }
        return restTemplate.getForObject(url, String.class);
    }


    @GetMapping("/api/news/search")
    public String searchNews(@RequestParam String q) {
        String url = apiBaseUrl + "/v2/everything?apiKey=" + apiKey + "&q=" + q;
        return restTemplate.getForObject(url, String.class);
    }


    @GetMapping("/api/news/sources")
    public String getSources() {
        String url = apiBaseUrl + "/v2/top-headlines/sources?apiKey=" + apiKey;
        return restTemplate.getForObject(url, String.class);
    }
}