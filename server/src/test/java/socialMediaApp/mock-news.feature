Feature: Mock News API

  Background:
    # Chạy mock server trên port 8080
    * url 'http://localhost:9090'

  Scenario: Mock top headlines
    * path '/api/v1/news/headlines'
    * param country = 'us'
    * param category = 'technology'
    * method get
    * status 200
    * def response =
      """
      {
        "status": "ok",
        "totalResults": 2,
        "articles": [
          {
            "source": { "id": null, "name": "Eurogamer.net" },
            "author": "Vikki Blake",
            "title": "Sony slaps down fan-made Concord resurrection effort",
            "description": "Sony issued DMCA notices against a fan project.",
            "url": "https://www.eurogamer.net/article",
            "urlToImage": "https://assetsio.gnwcdn.com/image.png",
            "publishedAt": "2025-11-16T14:17:07Z",
            "content": "Content goes here..."
          },
          {
            "source": { "id": null, "name": "9to5Mac" },
            "author": "Chance Miller",
            "title": "Bloomberg: iPhone Air 2 update",
            "description": "Apple delays iPhone Air 2 release.",
            "url": "https://9to5mac.com/article",
            "urlToImage": "https://i0.wp.com/image.jpg",
            "publishedAt": "2025-11-16T14:15:00Z",
            "content": "Content goes here..."
          }
        ]
      }
      """
