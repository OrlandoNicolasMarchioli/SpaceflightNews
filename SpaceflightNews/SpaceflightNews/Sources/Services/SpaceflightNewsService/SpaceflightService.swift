//
//  SpaceflightService.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 16/05/2026.
//

import Foundation
import Networking

protocol SpaceflightServiceProtocol: Sendable {
    func fetchArticles(query: String?, limit: Int, offset: Int) async throws -> SpaceflightService.DTO.ArticleListResponse
    func fetchArticle(by id: String) async throws -> SpaceflightService.DTO.Article
}

final class SpaceflightService: SpaceflightServiceProtocol, @unchecked Sendable {
        
    private let httpClient: HTTPClient
        
    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }
        
    enum Endpoints: Endpoint {
        case articles(query: String?, limit: Int, offset: Int)
        case article(id: String)
        
        var host: String {
            APIConfiguration.shared.host
        }
        
        var path: String {
            let version = APIConfiguration.shared.apiVersion
            switch self {
            case .articles:
                return "/\(version)/articles"
            case .article(let id):
                return "/\(version)/articles/\(id)"
            }
        }
        
        var method: HTTPMethod {
            .get
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .articles(let query, let limit, let offset):
                var items: [URLQueryItem] = [
                    URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "offset", value: "\(offset)")
                ]
                
                if let query = query, !query.isEmpty {
                    items.append(URLQueryItem(name: "search", value: query))
                }
                
                return items
                
            case .article:
                return nil
            }
        }
    }
    
    func fetchArticles(query: String?, limit: Int, offset: Int) async throws -> SpaceflightService.DTO.ArticleListResponse {
        let endpoint = Endpoints.articles(query: query, limit: limit, offset: offset)
        return try await httpClient.request(endpoint: endpoint, responseType: SpaceflightService.DTO.ArticleListResponse.self)
    }
    
    func fetchArticle(by id: String) async throws -> SpaceflightService.DTO.Article {
        let endpoint = Endpoints.article(id: id)
        return try await httpClient.request(endpoint: endpoint, responseType: SpaceflightService.DTO.Article.self)
    }
}
