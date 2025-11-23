Feature: Full Stack NewsAPI Mock

  Background:
    * configure cors = true
    # Hàm helper để tạo ngày tháng ngẫu nhiên (nếu cần)
    * def now = function(){ return java.time.Instant.now().toString() }

  # =================================================================
  # API 1: LẤY DANH SÁCH NGUỒN BÁO (/v2/top-headlines/sources)
  # =================================================================
  Scenario: pathMatches('/v2/top-headlines/sources')
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "sources": [
        { "id": "abc-news", "name": "ABC News", "category": "general", "language": "en", "country": "us" },
        { "id": "bbc-sport", "name": "BBC Sport", "category": "sports", "language": "en", "country": "gb" },
        { "id": "vn-express", "name": "VnExpress", "category": "general", "language": "vi", "country": "vn" },
        { "id": "techcrunch", "name": "TechCrunch", "category": "technology", "language": "en", "country": "us" }
      ]
    }
    """

  # =================================================================
  # API 2: TÌM KIẾM TOÀN BỘ (/v2/everything)
  # =================================================================

  # Case 2.1: Tìm tin về Bitcoin
  Scenario: pathMatches('/v2/everything') && paramValue('q') == 'bitcoin'
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "totalResults": 150,
      "articles": [
        {
          "source": { "id": "wired", "name": "Wired" },
          "author": "Satoshi Nakamoto",
          "title": "Bitcoin đạt mốc 100k USD giả lập",
          "description": "Thị trường tiền ảo đang biến động mạnh trong môi trường Mock Karate.",
          "url": "https://www.wired.com/bitcoin",
          "urlToImage": "https://images.unsplash.com/photo-1518546305927-5a555bb7020d?w=500",
          "publishedAt": "2025-11-23T09:00:00Z",
          "content": "Nội dung chi tiết về Bitcoin..."
        }
      ]
    }
    """

  # Case 2.2: Tìm tin về Apple
  Scenario: pathMatches('/v2/everything') && paramValue('q') == 'apple'
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "totalResults": 40,
      "articles": [
        {
          "source": { "id": "verge", "name": "The Verge" },
          "author": "Nilay Patel",
          "title": "iPhone 16 rò rỉ hình ảnh mới",
          "description": "Apple chuẩn bị ra mắt dòng sản phẩm mới với tính năng AI tích hợp.",
          "urlToImage": "https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=500",
          "publishedAt": "2025-11-22T15:30:00Z"
        }
      ]
    }
    """


  Scenario: pathMatches('/v2/top-headlines') && paramValue('category') == 'sports'
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "articles": [
        {
          "source": { "name": "ESPN" },
          "title": "Manchester United vô địch Premier League (Mock)",
          "description": "Một chiến thắng lịch sử trong môi trường kiểm thử.",
          "urlToImage": "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=500",
          "publishedAt": "2025-11-23T08:00:00Z"
        }
      ]
    }
    """

  # Case 3.2: Tin Công nghệ (category=technology)
  Scenario: pathMatches('/v2/top-headlines') && paramValue('category') == 'technology'
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "articles": [
        {
          "source": { "name": "TechCrunch" },
          "title": "AI Gemini thay thế lập trình viên? Không, nó chỉ giúp đỡ.",
          "description": "Cuộc cách mạng AI đang diễn ra.",
          "urlToImage": "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=500",
          "publishedAt": "2025-11-23T07:00:00Z"
        }
      ]
    }
    """


  Scenario: pathMatches('/v2/top-headlines') && paramValue('country') == 'vn'
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "articles": [
        {
          "source": { "name": "VnExpress" },
          "title": "Thời tiết Hà Nội hôm nay rất đẹp để code",
          "description": "Dự báo thời tiết cho thấy coder sẽ làm việc hiệu quả.",
          "urlToImage": "https://images.unsplash.com/photo-1555921090-b3a27c44a9b1?w=500",
          "publishedAt": "2025-11-23T06:00:00Z"
        }
      ]
    }
    """

  # Case 3.4: Fallback (Mặc định nếu không khớp cái nào)
  Scenario: pathMatches('/v2/top-headlines')
    * def responseStatus = 200
    * def response =
    """
    {
      "status": "ok",
      "articles": [
        { "source": { "name": "General News" }, "title": "Tin chung chung: Hệ thống vẫn ổn" }
      ]
    }
    """