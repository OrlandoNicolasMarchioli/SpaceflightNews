//
//  APIConfiguration.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 16/05/2026.
//

import Foundation

struct APIConfiguration {
    
    let baseURL: String
    let apiVersion: String
    let scheme: String
        
    var host: String {
        baseURL
    }
        
    static let shared: APIConfiguration = {
        guard let url = Bundle.module.url(forResource: "Configuration", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let apiConfig = plist["APIConfiguration"] as? [String: String],
              let baseURL = apiConfig["BaseURL"],
              let apiVersion = apiConfig["APIVersion"],
              let scheme = apiConfig["Scheme"] else {
            fatalError("Configuration.plist not found")
        }
        
        return APIConfiguration(
            baseURL: baseURL,
            apiVersion: apiVersion,
            scheme: scheme
        )
    }()
        
    private init(baseURL: String, apiVersion: String, scheme: String) {
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.scheme = scheme
    }
}

private final class BundleToken {}
