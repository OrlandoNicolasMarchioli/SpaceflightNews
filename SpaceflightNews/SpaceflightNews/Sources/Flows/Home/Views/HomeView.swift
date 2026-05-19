// HomeView.swift
// SpaceNewsApp — Presentation/Home/View
// //  Created by Orlando Nicola Marchioli on 17/05/2026.


import SwiftUI

struct HomeView: View {
    
    @StateObject private var presenter: HomePresenter
    @State private var searchText: String = ""
    @State private var scrollPosition: Int?
    
    init(router: SpaceflightRouter) {
        _presenter = StateObject(wrappedValue: HomePresenter(router: router))
    }
        
    var body: some View {
        VStack(spacing: 0) {
            if presenter.model.isLoading {
                LoadingView(message: presenter.model.loadingMessage)
            } else {
                searchBar
                articlesListHeader
                articlesListView
            }
        }
        .refreshable {
            await presenter.action(.resfresh)
        }
        .task {
            await presenter.action(.viewAppear)
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField(presenter.model.searchPlaceholder, text: $searchText)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onChange(of: searchText) {newValue in
                    Task {
                        await presenter.action(.filter(text: newValue))
                    }
                }
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    Task {
                        await presenter.action(.filter(text: ""))
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    private var articlesListHeader: some View {
        HStack(spacing: 16) {
            Text(presenter.model.headerTitle)
            Spacer()
            Button(action: {
                Task {
                    await presenter.action(.showSheet)
                }
            })
            {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("SORT_BUTTON_TITLE".translate)
                        .font(.subheadline)
                }
                .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .sheet(isPresented: $presenter.model.showSortSheet) {
            sortSheet
        }
    }
    
    @ViewBuilder
    private var sortSheet: some View {
        NavigationStack {
            List {
                Section {
                    sortOption(.descending)
                    sortOption(.ascending)
                } header: {
                    Text("SORT_SHEET_SECTION_HEADER".translate)
                }
            }
            .navigationTitle("SORT_SHEET_TITLE".translate)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("SORT_SHEET_CLOSE_BUTTON".translate) {
                        presenter.model.showSortSheet = false
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    @ViewBuilder
    private var articlesListView: some View {
        if presenter.model.articles.isEmpty {
            EmptyStateView(
                icon: "magnifyingglass",
                title: "EMPTY_STATE_TITLE".translate,
                message: "EMPTY_STATE_MESSAGE".translate
            )
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(presenter.model.articles.enumerated()), id: \.element.id) { index, item in
                        ArticleRowView(item: item)
                            .id(item.id)
                            .padding(.bottom, 24)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .onTapGesture {
                                Task {
                                    await presenter.action(.detail(id: String(item.id)))
                                }
                            }
                            .onAppear {
                                if index == presenter.model.articles.count - 3 {
                                    Task {
                                        await presenter.action(.loadMore)
                                    }
                                }
                            }
                    }
                    
                    if presenter.model.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            .scrollPosition(id: $scrollPosition, anchor: .top)
            .scrollBounceBehavior(.basedOnSize)
            .listStyle(.plain)
            .navigationTitle(presenter.model.title)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

extension HomeView {
    
    @ViewBuilder
    private func sortOption(_ order: HomePresenter.SortOrder) -> some View {
        Button {
            Task {
                await presenter.action(.setSortOrder(order))
            }
        } label: {
            HStack {
                Image(systemName: order.icon)
                    .foregroundStyle(.black)
                Text(order.title)
                    .foregroundStyle(.black)
                Spacer()
                if presenter.model.sortOrder == order {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
}
