//
//  ArticleRowView.swift
//  SpaceflightNews
//
//  Created by Orlando Nicola Marchioli on 18/05/2026.
//

import SwiftUI

struct ArticleRowView: View {

    let item: SpaceflightService.DTO.Article
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var isVertical: Bool {
        verticalSizeClass == .regular && horizontalSizeClass == .compact
    }

    var body: some View {
        if isVertical {
            verticalLayout
        } else {
            horizontalLayout
        }
    }
        
    @ViewBuilder
    private var verticalLayout: some View {
        VStack(alignment: .center, spacing: 12) {
            articleImage
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            articleContent
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
        
    @ViewBuilder
    private var horizontalLayout: some View {
        HStack(alignment: .top, spacing: 12) {
            articleImage
                .frame(width: 160, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            articleContent
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
        
    @ViewBuilder
    private var articleImage: some View {
        AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            @unknown default:
                Color(.systemGray6)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var articleContent: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(item.title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(2)
                .foregroundStyle(.primary)

            Text(item.summary)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "globe")
                    .font(.caption2)
                Text(item.newsSite)
                    .font(.caption2.weight(.medium))
                Spacer()
                Label(item.updatedAt.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.tertiary)
        }
    }
}
