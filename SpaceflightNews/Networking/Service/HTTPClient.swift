// HTTPClient.swift
//

import Foundation

public protocol HTTPClient: Sendable {
    func request<T: Decodable>(
        endpoint: any Endpoint,
        responseType: T.Type
    ) async throws -> T
}


public final class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession
    private let decoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }(),
    ) {
        self.session = session
        self.decoder = decoder
    }

    public func request<T: Decodable>(
        endpoint: any Endpoint,
        responseType: T.Type
    ) async throws -> T {

        let urlRequest: URLRequest
        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            throw NetworkError.invalidURL
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let urlError as URLError {
            let networkError = NetworkError.from(urlError)
            throw networkError
        } catch {
            let networkError = NetworkError.unknown(error.localizedDescription)
            throw networkError
        }

        if let httpResponse = response as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NetworkError.httpError(statusCode: httpResponse.statusCode)
                throw error
            }
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            let error = NetworkError.decodingError(decodingError.readableDescription)
            throw error
        }
    }
}

extension DecodingError {
    var readableDescription: String {
        switch self {
        case .typeMismatch(let type, let context):
            let path = context.codingPath.map(\.stringValue).joined(separator: ".")
            return String(format: "DECODING_ERROR_TYPE_MISMATCH".translate, "\(type)", path, context.debugDescription)
        case .valueNotFound(let type, let context):
            let path = context.codingPath.map(\.stringValue).joined(separator: ".")
            return String(format: "DECODING_ERROR_VALUE_NOT_FOUND".translate, "\(type)", path, context.debugDescription)
        case .keyNotFound(let key, let context):
            let path = context.codingPath.map(\.stringValue).joined(separator: ".")
            return String(format: "DECODING_ERROR_KEY_NOT_FOUND".translate, key.stringValue, path)
        case .dataCorrupted(let context):
            let path = context.codingPath.map(\.stringValue).joined(separator: ".")
            return String(format: "DECODING_ERROR_DATA_CORRUPTED".translate, path, context.debugDescription)
        @unknown default:
            return localizedDescription
        }
    }
}

