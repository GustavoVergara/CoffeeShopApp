import Foundation
import Core

protocol MenuPresenting {
    func presentLoading() async
    func presentMenu(_ menu: MenuResponse) async
    func presentError(_ error: Error) async
    func presentOpenCartButton(_ isPresented: Bool)
}

class MenuViewModel: ObservableObject, MenuPresenting {
    let priceFormatter: PriceFormatting = PriceFormatter()
    @Published
    var state: MenuViewState = .loading
    
    @Published
    var isCartButtonPresented: Bool = true
    
    @MainActor
    func presentLoading() async {
//        if case .loaded = state { return }
//        state = .loading
    }
    
    @MainActor
    func presentMenu(_ menu: MenuResponse) async {
        let items = menu.products.map { product in
            MenuItemViewData(
                id: product.id,
                name: product.name,
                description: product.description,
                imageURL: product.photo.flatMap { URL(string: $0) },
                price: priceFormatter.minimunDisplayPrice(in: product.skus)
            )
        }
        let viewData = MenuViewData(storeName: menu.storeName, items: items)
        state = .loaded(viewData)
    }
    
    @MainActor
    func presentError(_ error: Error) async {
        state = .failed
    }
    
    func presentOpenCartButton(_ isPresented: Bool) {
        isCartButtonPresented = isPresented
    }
}

enum MenuViewState: Hashable {
    case loading
    case loaded(MenuViewData)
    case failed
}

struct MenuViewData: Hashable {
    var storeName: String
    var items: [MenuItemViewData]
}

struct MenuItemViewData: Identifiable, Hashable {
    var id: String
    var name: String
    var description: String
    var imageURL: URL?
    var price: String
}
