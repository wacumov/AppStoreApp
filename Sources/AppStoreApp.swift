import SwiftUI

@main
struct AppStoreApp: App {
    @AppStorage("rankingType") var rankingType: RankingType = .topFree
    @AppStorage("country") var country: Country = .US
    @AppStorage("categoryFilter") var categoryFilter: CategoryFilter = .allApps
    @AppStorage("limit") var limit: Int = 10

    var body: some Scene {
        WindowGroup {
            RankingView(
                rankingType: $rankingType,
                country: $country,
                categoryFilter: $categoryFilter,
                limit: $limit
            )
        }
    }
}
