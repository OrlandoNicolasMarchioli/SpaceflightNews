// DetailView.swift
// SpaceNewsApp — Presentation/Detail/View
//

import SwiftUI

struct DetailView: View {
        
    @StateObject private var presenter: DetailPresenter
        
    init(router: SpaceflightRouter, id: String) {
        _presenter = StateObject(wrappedValue: DetailPresenter(router: router, articleID: id))
    }
        
    var body: some View {
        VStack(spacing: 0) {
            if presenter.model.isLoading {
                LoadingView(message: presenter.model.loadingMessage) {
                    presenter.router?.navigateTo(.home)
                }
            } else {
                articleDetailView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await presenter.action(.viewAppear)
        }
    }
}

extension DetailView {
    
    private var articleDetailView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    AsyncImage(url: URL(string: presenter.model.article?.imageUrl ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure, .empty:
                            ZStack {
                                Color(.systemGray5)
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.secondary)
                            }
                        @unknown default:
                            ProgressView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 240)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack(spacing: 8) {
                            Label(presenter.model.article?.newsSite ?? "", systemImage: "globe")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                            
                            Text("·")
                                .foregroundStyle(.tertiary)
                            
                            Label(presenter.model.article?.updatedAt.formatted(date: .abbreviated, time: .omitted) ?? "", systemImage: "calendar")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Text(presenter.model.article?.title ?? "")
                            .font(.title2.weight(.bold))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider()
                        
                        Text(presenter.model.article?.summary ?? "")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                }
            }
            
            if let url = URL(string: presenter.model.article?.url ?? "") {
                VStack(spacing: 0) {
                    Link(destination: url) {
                        Label(presenter.model.seeCompleteArticleButton, systemImage: "arrow.up.right.square")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationTitle(presenter.model.article?.newsSite ?? "")
    }
    
}
