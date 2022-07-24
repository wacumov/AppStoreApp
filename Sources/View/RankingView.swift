import SwiftUI

struct RankingView: View {
    @StateObject var store: RankingStore = .init()

    @Binding var rankingType: RankingType
    @Binding var country: Country
    @Binding var categoryFilter: CategoryFilter
    @Binding var limit: Int

    @State private var isSettingsPresented = false

    var body: some View {
        NavigationView {
            Group {
                switch store.state {
                case .loading:
                    ProgressView()
                case let .success(items):
                    List(items) { item in
                        AppListItemView(item: item)
                    }
                case let .failure(error):
                    Text(error.localizedDescription)
                }
            }
            .navigationTitle(rankingType.name)
            .navigationBarItems(trailing: RankingSettingsButton(
                isSettingsPresented: $isSettingsPresented
            )
            )
            .sheet(isPresented: $isSettingsPresented) {
                RankingSettingsView(
                    rankingType: $rankingType,
                    country: $country,
                    categoryFilter: $categoryFilter,
                    limit: $limit
                )
            }
        }
        .onAppear {
            refresh()
        }
        .onChange(of: rankingType) { _ in
            refresh()
        }
        .onChange(of: country) { _ in
            refresh()
        }
        .onChange(of: categoryFilter) { _ in
            refresh()
        }
        .onChange(of: limit) { _ in
            refresh()
        }
    }

    private func refresh() {
        store.loadRanking(rankingType, country: country, categoryFilter: categoryFilter, limit: limit)
    }
}

private struct RankingSettingsButton: View {
    @Binding var isSettingsPresented: Bool

    var body: some View {
        Button(action: {
            isSettingsPresented = true
        }) {
            Image(systemName: "slider.horizontal.3")
        }
    }
}
