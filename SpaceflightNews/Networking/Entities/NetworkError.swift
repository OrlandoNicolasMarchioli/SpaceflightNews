// NetworkError.swift
//


import Foundation


public enum NetworkError: LocalizedError, Equatable {

    case invalidURL

    case httpError(statusCode: Int)

    case decodingError(String)

    case noConnection

    case unknown(String?)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "NETWORK_ERROR_INVALID_URL".translate
        case .httpError(let code):
            return String(format: "NETWORK_ERROR_HTTP_ERROR".translate, code)
        case .decodingError(let detail):
            return String(format: "NETWORK_ERROR_DECODING_ERROR".translate, detail)
        case .noConnection:
            return "NETWORK_ERROR_NO_CONNECTION".translate
        case .unknown(let msg):
            return msg ?? "NETWORK_ERROR_UNKNOWN".translate
        }
    }

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):                    return true
        case (.noConnection, .noConnection):                return true
        case (.httpError(let a), .httpError(let b)):        return a == b
        case (.decodingError(let a), .decodingError(let b)):return a == b
        case (.unknown(let a), .unknown(let b)):            return a == b
        default:                                            return false
        }
    }

    static func from(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut:
            return .noConnection
        default:
            return .unknown(urlError.localizedDescription)
        }
    }
}
