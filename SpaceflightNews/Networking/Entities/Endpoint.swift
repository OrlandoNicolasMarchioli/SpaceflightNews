// Endpoint.swift

import Foundation

public protocol Endpoint {

    var scheme: String { get }

    var host: String { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var queryItems: [URLQueryItem]? { get }

    var headers: [String: String]? { get }

    var body: Data? { get }
}

public extension Endpoint {
    var scheme: String { "https" }
    var headers: [String: String]? { nil }
    var body: Data? { nil }

    func asURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host   = host
        components.path   = path

        if let queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody   = body

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
