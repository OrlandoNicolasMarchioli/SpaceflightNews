# 🚀 SpaceflightNews

> A space news application built with Swift, SwiftUI, and modular architecture.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Modules](#-modules)
- [Data Flow](#-data-flow)
- [Localization](#-localization)
- [Logging](#-logging)
- [Testing](#-testing)
- [Installation](#-installation)
- [Usage](#-usage)
- [Requirements](#-requirements)

## ✨ Features

- ✅ **Modular Architecture** with Swift Package Manager
- ✅ **SwiftUI + UIKit Hybrid** with UIHostingController navigation
- ✅ **Presenter Pattern** for separation of concerns
- ✅ **Router Pattern** for decoupled navigation
- ✅ **Type-Safe Networking** with async/await
- ✅ **Full Localization** (EN)
- ✅ **Centralized Logging** with OSLog
- ✅ **Real-Time Search**
- ✅ **Infinite Pagination**
- ✅ **Pull to Refresh**
- ✅ **Feedback States** (Loading, Error, Empty)
- ✅ **Unit Testing** with Swift Testing

## 🏗️ Architecture

The project follows a **clean modular architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────────┐
│                  SpaceflightNewsApp                 │
│                   (UIKit Entry)                     │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│                 SpaceflightRouter                   │
│            (Coordinador de Navegación)              │
└─────┬──────────────────────────────────────┬────────┘
      │                                      │
      ▼                                      ▼
┌─────────────────┐              ┌─────────────────────┐
│   HomeView      │              │    DetailView       │
│   (SwiftUI)     │              │    (SwiftUI)        │
└────────┬────────┘              └──────────┬──────────┘
         │                                  │
         ▼                                  ▼
┌─────────────────┐              ┌─────────────────────┐
│  HomePresenter  │              │  DetailPresenter    │
│    (Logic)      │              │     (Logic)         │
└────────┬────────┘              └──────────┬──────────┘
         │                                  │
         └──────────────┬───────────────────┘
                        │
                        ▼
              ┌──────────────────┐
              │ SpaceflightService│
              │   (API Client)    │
              └─────────┬─────────┘
                        │
                        ▼
              ┌──────────────────┐
              │   HTTPClient      │
              │  (Networking)     │
              └───────────────────┘
```

### Architecture Layers:

1. **Presentation Layer** (SwiftUI + Presenters)
   - Views: Declarative UI
   - Presenters: Presentation logic
   - Router: Navigation

2. **Domain Layer** (Models + Services)
   - Domain models
   - Use cases
   - Services

3. **Data Layer** (Networking + DTOs)
   - HTTPClient
   - Endpoints
   - DTOs and mappers

4. **Cross-Cutting** (Logger + Extensions)
   - SpaceflightLogger
   - Localization
   - Extensions

## 📦 Project Structure

```
SpaceflightNews/
├── SpaceflightNewsApp/          # Main app (UIKit entry)
│   ├── SpaceflightNewsApp.swift # AppDelegate & SceneDelegate
│   ├── SpaceflightRouter.swift  # Navigation coordinator
│   └── Resources/
│       ├── en.lproj/
│       │   └── Localizable.strings
│       └── es.lproj/
│           └── Localizable.strings
│
├── SpaceflightNews/             # Main module (SPM)
│   ├── Sources/
│   │   ├── Presentation/
│   │   │   ├── Home/
│   │   │   │   ├── HomeView.swift
│   │   │   │   ├── HomePresenter.swift
│   │   │   │   └── HomePresenter+Model.swift
│   │   │   ├── Detail/
│   │   │   │   ├── DetailView.swift
│   │   │   │   ├── DetailPresenter.swift
│   │   │   │   └── DetailPresenter+Model.swift
│   │   │   └── Components/
│   │   │       ├── ArticleRowView.swift
│   │   │       └── FeedbackViews.swift
│   │   ├── Domain/
│   │   │   ├── Models/
│   │   │   │   └── Article.swift
│   │   │   └── Services/
│   │   │       ├── SpaceflightService.swift
│   │   │       └── SpaceflightService+DTO.swift
│   │   ├── Utils/
│   │   │   ├── SpaceflightLogger.swift
│   │   │   ├── String+Localization.swift
│   │   │   └── String+Extensions.swift
│   │   └── Resources/
│   │       └── Localizable.strings
│   └── Tests/
│       └── HomePresenterTests.swift
│
└── Networking/                  # Networking module (SPM)
    ├── Endpoint.swift
    ├── HTTPClient.swift
    ├── HTTPMethod.swift
    ├── NetworkError.swift
    ├── APIConfiguration.swift
    ├── JSONDecoder+Extensions.swift
    └── NetworkingString+Localization.swift
```

## 🧩 Modules

### 1. **Networking** (Reusable Module)

Type-safe and protocol-oriented HTTP client.

**Components:**

```swift
// Protocol to define endpoints
protocol Endpoint: Sendable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    func asURLRequest() throws -> URLRequest
}

// HTTP client with async/await
protocol HTTPClient: Sendable {
    func request<T: Decodable>(
        endpoint: any Endpoint,
        responseType: T.Type
    ) async throws -> T
}

// Typed and localized errors
enum NetworkError: LocalizedError {
    case invalidURL
    case noConnection
    case httpError(statusCode: Int)
    case decodingError(String)
    case timeout
    case unknown(String)
}
```

**Features:**
- ✅ Type-safe endpoints
- ✅ Native async/await
- ✅ Localized errors
- ✅ JSON decoding with snake_case
- ✅ Enhanced decoding error handling
- ✅ Testable (protocol-based)

### 2. **SpaceflightNews** (Main Module)

App-specific implementation.

**Service Layer:**

```swift
final class SpaceflightService {
    private let httpClient: HTTPClient
    
    func fetchArticles(query: String, limit: Int, offset: Int) async throws -> ArticleListResult
    func fetchArticle(by id: String) async throws -> Article
}
```

**Presenter Pattern:**

```swift
@MainActor
final class HomePresenter: ObservableObject {
    @Published var model: Model
    private let service: SpaceflightService
    weak var router: SpaceflightRouter?
    
    func action(_ action: Action) async {
        // Handles view actions
    }
}
```

**Router Pattern:**

```swift
@MainActor
protocol SpaceflightRouterProtocol {
    var navigationController: UINavigationController? { get }
    func navigateTo(_ destination: Destination)
    func pop()
    func popToRoot()
}
```

## 🔄 Data Flow

### Example: Loading Articles

```
1. User Action
   └─> HomeView taps "Refresh"

2. Presenter
   └─> action(.refresh) called
       └─> fetchData() async

3. Service Layer
   └─> service.fetchArticles(query: "", limit: 10, offset: 0)
       └─> Builds ArticleEndpoint

4. Networking Layer
   └─> httpClient.request(endpoint, responseType: ArticleListResultDTO.self)
       └─> URLSession.data(for: request)
       └─> Decode JSON → ArticleListResultDTO
       └─> Map to Domain: .toDomain()

5. Error Handling
   └─> If error occurs:
       ├─> SpaceflightLogger.shared.logEndpointError()
       └─> Router.navigateTo(errorView)

6. Update UI
   └─> model.updateArticles(articles)
       └─> @Published updates SwiftUI
```

## 🌍 Localization

Complete localization system with support for **English**.985

### Structure:

```swift
// Extension for String
extension String {
    var translate: String {
        NSLocalizedString(self, bundle: .main, comment: "")
    }
}

// Usage in code
"HOME_NAV_BAR_TITLE".translate  // → "Spaceflight News"
```

### Available Strings:

**UI Strings:**
- `HOME_NAV_BAR_TITLE`
- `HOME_SEARCH_PLACEHOLDER`
- `HOME_LOADING_MESSAGE`
- `DETAIL_SEE_COMPLETE_ARTICLE_BUTTON`
- `EMPTY_STATE_TITLE`
- `EMPTY_STATE_MESSAGE`

**Error Strings:**
- `DECODING_ERROR_TYPE_MISMATCH`
- `DECODING_ERROR_VALUE_NOT_FOUND`
- `DECODING_ERROR_KEY_NOT_FOUND`
- `DECODING_ERROR_DATA_CORRUPTED`
- `DECODING_ERROR_UNKNOWN`

**Location:**
- `SpaceflightNewsApp/Resources/en.lproj/Localizable.strings`
- `SpaceflightNewsApp/Resources/es.lproj/Localizable.strings`

## 📊 Logging

Centralized logging system with **OSLog** for debugging and monitoring.

### SpaceflightLogger

```swift
@MainActor
final class SpaceflightLogger {
    static let shared = SpaceflightLogger()
    
    enum Category {
        case network, endpoint, decoding, routing, general
    }
    
    // Available methods
    func logEndpointError(_ error: Error, endpoint: String, parameters: [String: Any]?)
    func logWarning(_ message: String, category: Category)
    func logInfo(_ message: String, category: Category)
    func logSuccess(_ message: String, category: Category)
    
    // Convenience methods
    func logArticlesFetchError(_ error: Error, query: String, limit: Int, offset: Int)
    func logArticleDetailError(_ error: Error, articleID: String)
}
```

### Usage:

```swift
// In Presenters
do {
    let articles = try await service.fetchArticles(...)
    SpaceflightLogger.shared.logSuccess("Fetched \(articles.count) articles", category: .endpoint)
} catch {
    SpaceflightLogger.shared.logArticlesFetchError(error, query: "", limit: 10, offset: 0)
}
```

### DEBUG Output:

```
🔴 [Endpoint] ERROR
   Endpoint: /articles
   Parameters: ["query": "", "limit": 10, "offset": 0]
   Error: No internet connection
   Type: noConnection
   Timestamp: 2026-05-18T10:30:45Z
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🧪 Testing

### Swift Testing Framework

```swift
import Testing
@testable import SpaceflightNews

@Suite("Home Presenter Tests")
struct HomePresenterTests {
    
    @Test("Fetches articles on view appear")
    func fetchArticlesOnViewAppear() async throws {
        // Given
        let mockService = MockSpaceflightService()
        let presenter = HomePresenter(router: mockRouter, service: mockService)
        
        // When
        await presenter.action(.viewAppear)
        
        // Then
        #expect(presenter.model.articles.count > 0)
        #expect(!presenter.model.isLoading)
    }
}
```

### Available Tests:
- ✅ `HomePresenterTests.swift` - Presentation logic tests
- ✅ `ArticleEndpointTests.swift` - Endpoint construction tests
- ✅ DTO decoding tests
- ✅ Domain mapper tests

### Running Tests:

```bash
# All tests
swift test

# Specific tests
swift test --filter HomePresenterTests

# With verbose output
swift test --verbose
```

## 💻 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/SpaceflightNews.git
cd SpaceflightNews
```

### 2. Open in Xcode

```bash
open SpaceflightNewsApp/SpaceflightNews.xcodeproj
```

### 3. Build and Run

```bash
# From Xcode: Cmd + R
# From Terminal:
xcodebuild -scheme SpaceflightNews -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## 🚀 Usage

### Creating an Endpoint

```swift
enum ArticleEndpoint: Endpoint {
    case articles(query: String?, limit: Int, offset: Int)
    case articleDetail(id: Int)
    
    var host: String { "api.spaceflightnewsapi.net" }
    
    var path: String {
        switch self {
        case .articles:
            return "/v4/articles"
        case .articleDetail(let id):
            return "/v4/articles/\(id)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .articles(let query, let limit, let offset):
            var items = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            if let query = query, !query.isEmpty {
                items.append(URLQueryItem(name: "search", value: query))
            }
            return items
        case .articleDetail:
            return nil
        }
    }
}
```

### Consuming the API

```swift
// In a Presenter
private func fetchData() async {
    do {
        let result = try await service.fetchArticles(
            query: "",
            limit: 20,
            offset: 0
        )
        model.updateArticles(result.results)
        SpaceflightLogger.shared.logSuccess("Fetched articles", category: .endpoint)
    } catch {
        SpaceflightLogger.shared.logArticlesFetchError(error, query: "", limit: 20, offset: 0)
        router?.navigateTo(.error)
    }
}
```

### Adding Localization

1. Add the key in `Localizable.strings`:

```strings
// en.lproj/Localizable.strings
"MY_NEW_KEY" = "My English Text";

// es.lproj/Localizable.strings
"MY_NEW_KEY" = "Mi Texto en Español";
```

2. Use in code:

```swift
let text = "MY_NEW_KEY".translate
```

## 📝 Requirements

- **iOS:** 17.0+
- **macOS:** 14.0+
- **Swift:** 6.0+
- **Xcode:** 16.0+
- **Swift Package Manager:** Included in Xcode

## 🔧 Configuration

### Package.swift

```swift
// swift-tools-version: 6.0
let package = Package(
    name: "SpaceflightNews",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "SpaceflightNews", targets: ["SpaceflightNews"]),
        .library(name: "Networking", targets: ["Networking"])
    ],
    targets: [
        .target(name: "Networking", path: "Networking"),
        .target(name: "SpaceflightNews", dependencies: ["Networking"])
    ]
)
```

## 👨‍💻 Author

**Orlando Nicola Marchioli**

- GitHub: [@orlandonicola](https://github.com/orlandonicola)
- Email: nico.marchioli@gmail.com


