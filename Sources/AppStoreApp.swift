import SwiftUI

@main
struct AppStoreApp: App {
    @AppStorage("rankingType") var rankingType: RankingType = .topFree
    @AppStorage("country") var country: Country = .US
    @AppStorage("categoryFilter") var categoryFilter: CategoryFilter = .allApps

    var body: some Scene {
        WindowGroup {
            RankingView(
                rankingType: $rankingType,
                country: $country,
                categoryFilter: $categoryFilter
            )
        }
    }
}
