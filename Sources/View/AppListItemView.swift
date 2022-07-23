import SwiftUI

struct AppListItemView: View {
    let item: AppListItem

    var body: some View {
        HStack {
            icon
            titleAndSubtitle
            Spacer()
            priceButton
        }
    }

    private var icon: some View {
        AsyncImage(url: item.icon) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(Color.gray.opacity(0.8))
            case let .success(image):
                image
                    .resizable()
                    .scaledToFit()
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(12)
        .frame(width: 50, height: 50)
    }

    private var titleAndSubtitle: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .bold()
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var priceButton: some View {
        Button(item.price) {}
            .font(Font.system(.caption).bold())
            .foregroundColor(Color.blue)
            .padding(.horizontal, CGFloat(24 - item.price.count))
            .padding(.vertical, 6)
            .background(Color(UIColor.systemGray6))
            .clipShape(Capsule())
    }
}
