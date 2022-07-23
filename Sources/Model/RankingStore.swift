import AppStoreScraper
import SwiftUI

final class RankingStore: ObservableObject {
    @Published var state: State = .loading

    enum State {
        case loading
        case success([AppListItem])
        case failure(Error)
    }

    func loadRanking(_ rankingType: RankingType, country: Country, categoryFilter: CategoryFilter) {
        state = .loading
        Task.detached(priority: .high) { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let ranking = try await self.scraper.getRanking(rankingType, country: country, categoryFilter: categoryFilter)
                let items = ranking.applications.enumerated().map {
                    AppListItem($0.element, index: $0.offset)
                }
                self.updateState(.success(items))
            } catch {
                self.updateState(.failure(error))
            }
        }
    }

    private let scraper = Scraper()

    private func updateState(_ newValue: State) {
        Task { @MainActor [weak self] in
            self?.state = newValue
        }
    }
}

private extension AppListItem {
    init(_ app: Ranking.Application, index: Int) {
        let icon = app.icons.sorted(by: {
            $0.attributes.height > $1.attributes.height
        }).first
        let iconURL: URL? = {
            guard let icon = icon?.url else {
                return nil
            }
            return URL(string: icon)
        }()
        let price: String = {
            var amount = app.price.attributes.amount
            if let value = Double(amount), value == 0.0 {
                return "GET"
            }
            amount = amount.replacingOccurrences(of: ".00", with: "")
            let currency = app.price.attributes.currency
            return "\(amount) \(currency)"
        }()
        self.init(
            id: app.id.attributes.id,
            icon: iconURL,
            title: "\(index + 1). \(app.name.value)",
            subtitle: app.developer.value,
            price: price
        )
    }
}
