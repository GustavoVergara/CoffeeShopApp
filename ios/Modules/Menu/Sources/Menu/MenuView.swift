import SwiftUI
import Core

struct MenuView: View {
    let interactor: MenuInteracting
    @StateObject var viewModel: MenuViewModel
    
    @State var searchQuery = ""

    var body: some View {
        NavigationStack(path: $viewModel.presentedProducts) {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let viewData):
                MenuProductListView(items: filterItems(viewData.items), interactor: interactor)
                    .searchable(text: $searchQuery)
                    .navigationTitle(viewData.storeName)
                    .navigationDestination(for: ProductResponse.self) { productResponse in
                        ProductDetailBuilder.shared.build(product: productResponse)
                    }
            case .failed:
                ScrollView {
                    Color.red
                }
            }
        }
        .refreshable {
            await interactor.didAppear()
        }
        .task {
            await interactor.didAppear()
        }
    }
    
    private var title: String {
        switch viewModel.state {
        case .loading:
            return "Carregando..."
        case .failed:
            return "Erro"
        case .loaded(let menu):
            return menu.storeName
        }
    }
    
    private func filterItems(_ items: [MenuItemViewData]) -> [MenuItemViewData] {
        guard searchQuery.isEmpty == false else {
            return items
        }
        let query = searchQuery.lowercased()
        return items.filter { $0.name.lowercased().contains(query) || $0.description.lowercased().contains(query) }
    }
}

struct MenuProductListView: View {
    var items: [MenuItemViewData]
    let interactor: MenuInteracting
    
    var body: some View {
        List(items) { menuItem in
            Button {
                interactor.didSelectItem(id: menuItem.id)
            } label: {
                MenuItemView(
                    image: menuItem.imageURL.map { CoreImage.url($0) } ?? .system("cup.and.saucer.fill"),
                    title: menuItem.name,
                    description: menuItem.description,
                    price: menuItem.price
                )
            }.buttonStyle(.plain)
        }
    }
}

struct MenuItemView: View {
    var image: CoreImage
    var title: String
    var description: String
    var price: String

    var body: some View {
        HStack {
            image
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 64)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Text(description)
                Text(price).bold()
            }
        }
    }

}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBuilder.build()
            .previewDisplayName("Live")
        MenuBuilder().buildPreview()
            .previewDisplayName("Mocked")
    }
}
