import Foundation

protocol MenuPresenting {
    func presentLoading() async
    func presentMenu(_ menu: MenuResponse) async
    func presentError(_ error: Error) async
}

class MenuViewModel: ObservableObject, MenuPresenting {
    @Published
    var state: MenuViewState = .loading
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "R$"
        return formatter
    }()
    
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
                price: priceText(forProduct: product)
            )
        }
        let viewData = MenuViewData(storeName: menu.storeName, items: items)
        state = .loaded(viewData)
    }
    
    @MainActor
    func presentError(_ error: Error) async {
        state = .failed
    }
    
    private func priceText(forProduct product: MenuResponse.ProductResponse) -> String {
        var minPrice: Double?
        var hasHigherPrices = false
        for sku in product.skus {
            guard let currentMinPrice = minPrice, currentMinPrice != sku.price else {
                minPrice = sku.price
                continue
            }
            
            minPrice = min(currentMinPrice, sku.price)
            hasHigherPrices = true
        }
        
        guard let minPrice else {
            return "??"
        }
        
        if hasHigherPrices {
            return "apartir de \(formatter.string(for: minPrice) ?? "??")"
        } else {
            return formatter.string(for: minPrice) ?? "??"
        }
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
