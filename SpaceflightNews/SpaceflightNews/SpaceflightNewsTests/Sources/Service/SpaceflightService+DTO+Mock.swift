//
//  SpaceflightService+DTO+Mock.swift
//  SpaceflightNewsTests
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import Foundation
@testable import SpaceflightNews

extension SpaceflightService.DTO.Article {
    static let mock: SpaceflightService.DTO.Article = .init(
        id: 123,
        title: "SpaceX Launches New Starship",
        authors: [.mock],
        url: "https://example.com/article",
        imageUrl: "https://example.com/image.jpg",
        newsSite: "Space.com",
        summary: "SpaceX successfully launched its newest Starship rocket today.",
        publishedAt: Date(timeIntervalSince1970: 1705420800), // 2024-01-16
        updatedAt: Date(timeIntervalSince1970: 1705420800),
        featured: true,
        launches: [.mock],
        events: nil
    )
    
    static let mock2: SpaceflightService.DTO.Article = .init(
        id: 124,
        title: "NASA Announces Mars Mission",
        authors: [.mock],
        url: "https://example.com/article2",
        imageUrl: "https://example.com/image2.jpg",
        newsSite: "NASA",
        summary: "NASA has announced plans for a new Mars mission in 2026.",
        publishedAt: Date(timeIntervalSince1970: 1705507200), // 2024-01-17
        updatedAt: Date(timeIntervalSince1970: 1705507200),
        featured: false,
        launches: nil,
        events: nil
    )
    
    static let mock3: SpaceflightService.DTO.Article = .init(
        id: 125,
        title: "Blue Origin's New Glenn Ready for Launch",
        authors: [.mock2],
        url: "https://example.com/article3",
        imageUrl: "https://example.com/image3.jpg",
        newsSite: "Blue Origin",
        summary: "Blue Origin's New Glenn rocket is ready for its maiden flight.",
        publishedAt: Date(timeIntervalSince1970: 1705334400), // 2024-01-15
        updatedAt: Date(timeIntervalSince1970: 1705334400),
        featured: true,
        launches: [.mock],
        events: nil
    )
}

extension SpaceflightService.DTO.Author {
    static let mock: SpaceflightService.DTO.Author = .init(
        name: "John Doe",
        socials: .init(
            x: "@johndoe",
            youtube: "johndoechannel",
            instagram: "johndoe",
            linkedin: "johndoe",
            mastodon: nil,
            bluesky: nil
        )
    )
    
    static let mock2: SpaceflightService.DTO.Author = .init(
        name: "Jane Smith",
        socials: nil
    )
}

extension SpaceflightService.DTO.LaunchReference {
    static let mock: SpaceflightService.DTO.LaunchReference = .init(
        launchId: "launch-123",
        provider: "SpaceX"
    )
}

extension SpaceflightService.DTO.EventReference {
    static let mock: SpaceflightService.DTO.EventReference = .init(
        eventId: 456,
        provider: "NASA"
    )
}

extension SpaceflightService.DTO.ArticleListResponse {
    static let mock: SpaceflightService.DTO.ArticleListResponse = .init(
        count: 3,
        next: "https://api.example.com/articles?offset=10",
        previous: nil,
        results: [.mock, .mock2, .mock3]
    )
    
    static let mockPage2: SpaceflightService.DTO.ArticleListResponse = .init(
        count: 2,
        next: nil,
        previous: "https://api.example.com/articles?offset=0",
        results: [
            .init(
                id: 126,
                title: "International Space Station Update",
                authors: [.mock],
                url: "https://example.com/article4",
                imageUrl: "https://example.com/image4.jpg",
                newsSite: "ESA",
                summary: "New modules added to the International Space Station.",
                publishedAt: Date(timeIntervalSince1970: 1705593600), // 2024-01-18
                updatedAt: Date(timeIntervalSince1970: 1705593600),
                featured: false,
                launches: nil,
                events: nil
            ),
            .init(
                id: 127,
                title: "Artemis Program Progress",
                authors: [.mock2],
                url: "https://example.com/article5",
                imageUrl: "https://example.com/image5.jpg",
                newsSite: "NASA",
                summary: "NASA's Artemis program makes significant progress.",
                publishedAt: Date(timeIntervalSince1970: 1705680000), // 2024-01-19
                updatedAt: Date(timeIntervalSince1970: 1705680000),
                featured: true,
                launches: [.mock],
                events: [.mock]
            )
        ]
    )
    
    static let mockEmpty: SpaceflightService.DTO.ArticleListResponse = .init(
        count: 0,
        next: nil,
        previous: nil,
        results: []
    )
}
