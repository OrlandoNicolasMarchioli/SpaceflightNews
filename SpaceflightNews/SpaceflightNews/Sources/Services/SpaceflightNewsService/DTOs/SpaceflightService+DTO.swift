//
//  SpaceflightService+DTO.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 17/05/2026.
//

import Foundation

extension SpaceflightService {
    enum DTO {}
}

extension SpaceflightService.DTO {
    struct PaginatedResponse<T: Decodable & Sendable>: Decodable, Sendable {
        let count: Int
        let next: String?
        let previous: String?
        let results: [T]
    }
}

extension SpaceflightService.DTO {
    struct Article: Codable, Identifiable, Sendable {
        let id: Int
        let title: String
        let authors: [Author]
        let url: String
        let imageUrl: String?
        let newsSite: String
        let summary: String
        let publishedAt: Date
        let updatedAt: Date
        let featured: Bool?
        let launches: [LaunchReference]?
        let events: [EventReference]?
    }
}

extension SpaceflightService.DTO {
    struct Blog: Codable, Sendable {
        let id: Int
        let title: String
        let authors: [Author]
        let url: String
        let imageUrl: String?
        let newsSite: String
        let summary: String
        let publishedAt: Date
        let updatedAt: Date
        let featured: Bool?
        let launches: [LaunchReference]?
        let events: [EventReference]?
    }
}

extension SpaceflightService.DTO {
    struct Report: Codable, Sendable {
        let id: Int
        let title: String
        let authors: [Author]
        let url: String
        let imageUrl: String?
        let newsSite: String
        let summary: String
        let publishedAt: Date
        let updatedAt: Date
        let featured: Bool?
        let launches: [LaunchReference]?
        let events: [EventReference]?
    }
}

extension SpaceflightService.DTO {
    struct Author: Codable, Sendable {
        let name: String
        let socials: SpaceflightService.DTO.AuthorSocials?
    }

    struct AuthorSocials: Codable, Sendable {
        let x: String?
        let youtube: String?
        let instagram: String?
        let linkedin: String?
        let mastodon: String?
        let bluesky: String?
    }
}

extension SpaceflightService.DTO {
    struct LaunchReference: Codable, Sendable {
        let launchId: String?
        let provider: String?
    }
}

extension SpaceflightService.DTO {
    struct EventReference: Codable, Sendable {
        let eventId: Int?
        let provider: String?
    }
}

extension SpaceflightService.DTO {
    struct NewsSite: Codable, Sendable {
        let id: Int
        let name: String
    }
}

extension SpaceflightService.DTO {
    struct InfoResponse: Codable, Sendable {
        let version: String
        let newsSites: Int
        let articles: Int
        let blogs: Int
        let reports: Int
    }
}

extension SpaceflightService.DTO {
    typealias ArticleListResponse = PaginatedResponse<Article>
    typealias BlogListResponse = PaginatedResponse<Blog>
    typealias ReportListResponse = PaginatedResponse<Report>
    typealias NewsSiteListResponse = PaginatedResponse<NewsSite>
}
