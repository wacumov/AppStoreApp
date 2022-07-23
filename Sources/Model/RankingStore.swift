import AppStoreScraper
import SwiftUI

typealias RankingType = AppStoreScraper.RankingType

final class RankingStore: ObservableObject {
    @Published var state: State = .loading

    enum State {
        case loading
        case success([App])
        case failure(Error)
    }

    struct App: Identifiable {
        let rank: Int
        let name: String
        let id: String
    }

    func loadRanking(_ rankingType: RankingType) {
        state = .loading
        Task.detached(priority: .high) { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let ranking = try await self.scraper.getRanking(rankingType)
                let apps = ranking.applications.enumerated().map {
                    App(rank: $0.offset + 1,
                        name: $0.element.name.value,
                        id: $0.element.id.attributes.id)
                }
                self.updateState(.success(apps))
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
