//
//  SpaceflightLogger.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import Foundation
import Networking
import OSLog

@MainActor
final class SpaceflightLogger {
        
    static let shared = SpaceflightLogger()
        
    private let logger: Logger
    private let subsystem = Bundle.main.bundleIdentifier ?? "com.spaceflightnews"
        
    enum Category: String {
        case network = "Network"
        case endpoint = "Endpoint"
        case decoding = "Decoding"
        case routing = "Routing"
        case general = "General"
    }
    
    
    private init() {
        self.logger = Logger(subsystem: subsystem, category: "SpaceflightNews")
    }
    
    func logEndpointError(
        _ error: Error,
        endpoint: String,
        parameters: [String: Any]? = nil
    ) {
        let category = determineCategory(for: error)
        let message = formatErrorMessage(
            error: error,
            endpoint: endpoint,
            parameters: parameters
        )
        
        logger.error("[\(category.rawValue)] \(message)")
        
        #if DEBUG
        print("🔴 [\(category.rawValue)] ERROR")
        print("   Endpoint: \(endpoint)")
        if let params = parameters {
            print("   Parameters: \(params)")
        }
        print("   Error: \(error.localizedDescription)")
        if let networkError = error as? NetworkError {
            print("   Type: \(networkError)")
        }
        print("   Timestamp: \(Date().ISO8601Format())")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        #endif
    }
    
    func logWarning(_ message: String, category: Category = .general) {
        logger.warning("[\(category.rawValue)] \(message)")
        
        #if DEBUG
        print("⚠️ [\(category.rawValue)] \(message)")
        #endif
    }
    
    func logInfo(_ message: String, category: Category = .general) {
        logger.info("[\(category.rawValue)] \(message)")
        
        #if DEBUG
        print("ℹ️ [\(category.rawValue)] \(message)")
        #endif
    }
    
    func logSuccess(_ message: String, category: Category = .general) {
        logger.notice("[\(category.rawValue)] \(message)")
        
        #if DEBUG
        print("✅ [\(category.rawValue)] \(message)")
        #endif
    }
        
    private func determineCategory(for error: Error) -> Category {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .decodingError:
                return .decoding
            default:
                return .network
            }
        }
        return .endpoint
    }
    
    private func formatErrorMessage(
        error: Error,
        endpoint: String,
        parameters: [String: Any]?
    ) -> String {
        var message = "Endpoint: \(endpoint)"
        
        if let params = parameters, !params.isEmpty {
            let paramsString = params.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
            message += " | Params: \(paramsString)"
        }
        
        message += " | Error: \(error.localizedDescription)"
        
        return message
    }
}

extension SpaceflightLogger {
    
    func logArticlesFetchError(_ error: Error, query: String = "", limit: Int, offset: Int) {
        logEndpointError(
            error,
            endpoint: "/articles",
            parameters: [
                "query": query,
                "limit": limit,
                "offset": offset
            ]
        )
    }
    
    func logArticleDetailError(_ error: Error, articleID: String) {
        logEndpointError(
            error,
            endpoint: "/articles/\(articleID)",
            parameters: ["id": articleID]
        )
    }
}
