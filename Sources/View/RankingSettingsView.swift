import SwiftUI

struct RankingSettingsView: View {
    @Binding var rankingType: RankingType
    @Binding var country: Country
    @Binding var categoryFilter: CategoryFilter

    var body: some View {
        NavigationView {
            Form {
                rankingTypePicker
                countryPicker
                categoryPicker
            }
        }
    }

    private var rankingTypePicker: some View {
        Picker(selection: $rankingType, label: Text("Ranking")) {
            ForEach(RankingType.allCases, id: \.self) { rankingType in
                Text(rankingType.name)
                    .tag(rankingType)
            }
        }
    }

    private var countryPicker: some View {
        Picker(selection: $country, label: Text("Country")) {
            ForEach(Country.allCases, id: \.self) { country in
                Text(country.name)
                    .tag(country)
            }
        }
    }

    private var categoryPicker: some View {
        Picker(selection: $categoryFilter, label: Text("Category")) {
            ForEach(CategoryFilter.allCases, id: \.self) { category in
                Text(category.name)
                    .tag(category)
            }
        }
    }
}
