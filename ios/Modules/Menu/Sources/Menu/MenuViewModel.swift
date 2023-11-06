import Foundation

protocol MenuPresenting {
    func presentLoading() async
    func presentMenu(_ menu: MenuResponse) async
    func presentError(_ error: Error) async
    func presentProduct(_ product: ProductResponse)
}

class MenuViewModel: ObservableObject, MenuPresenting {
    let priceFormatter: PriceFormatting = PriceFormatter()
    @Published
    var state: MenuViewState = .loading
    
    @Published
    var presentedProducts = [ProductResponse]()
    
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
    
    // Might make more sense to change this to something like `updatePresentedProducts(_ products: [ProductResponse])`
    // in order to have the control of the stack handled by a `MenuRouter`.
    // Might even make sense to have the `presentedProducts` be a stream that is emitted by the Router instead of a direct call.
    func presentProduct(_ product: ProductResponse) {
        presentedProducts.append(product)
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
