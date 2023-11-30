import SwiftUI
import Navigation

public struct MenuBuilder: ViewBuilding {
    public var id: String { "menu" }
    
    let navigationStack: ViewStacking
    
    public init(navigationStack: ViewStacking) {
        self.navigationStack = navigationStack
    }

    public func build() -> some View {
        let viewModel = MenuViewModel()
        let interactor = MenuInteractor(navigationStack: navigationStack, presenter: viewModel)
        return MenuView(interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewMenuBuilder: ViewBuilding {
    public var id: String { "preview/menu" }
    
    let navigationStack: ViewStacking

    func build() -> some View {
        let viewModel = MenuViewModel()
        let interactor = PreviewMenuInteractor(navigationStack: navigationStack, presenter: viewModel)
        return MenuView(interactor: interactor, viewModel: viewModel)
    }
    
    class PreviewMenuInteractor: MenuInteracting {
        private let navigationStack: ViewStacking
        private let presenter: MenuPresenting
        
        init(navigationStack: ViewStacking, presenter: MenuPresenting) {
            self.navigationStack = navigationStack
            self.presenter = presenter
        }
        
        func didAppear() async {
            let products: [ProductResponse] = [
                Stub.Product.cappuccino,
                Stub.Product.flatWhite
            ]
            let menu = MenuResponse(storeID: "0", storeName: "Preview Store", products: products)
            await presenter.presentMenu(menu)
        }
        
        func didSelectItem(id: String) {
            navigationStack.push(ProductDetailBuilder(navigationStack: navigationStack, product: Stub.Product.cappuccino))
        }
        
        enum Stub {
            enum Product {
                static let cappuccino = ProductResponse(
                    id: "capp",
                    name: "Cappuchino",
                    description: "Dose dupla de expresso com leite vaporizado",
                    photo: "https://globalassets.starbucks.com/digitalassets/products/bev/SBX20190617_Cappuccino.jpg?impolicy=1by1_wide_topcrop_630",
                    skus: [
                        SKUResponse(id: "capp-g", price: 12, attributes: ["tamanho": "Grande"]),
                        SKUResponse(id: "capp-m", price: 10, attributes: ["tamanho": "Médio"])
                    ],
                    allAttributes: [AttributeResponse(key: "tamanho", name: "Tamanho")]
                )
                
                static let flatWhite = ProductResponse(
                    id: "flat-white",
                    name: "Flat white",
                    description: "Dose dupla de expresso com leite vaporizado",
                    photo: "https://globalassets.starbucks.com/digitalassets/products/bev/SBX20230406_FlatWhite.jpg?impolicy=1by1_wide_topcrop_630",
                    skus: [
                        SKUResponse(id: "flat-white-g", price: 11, attributes: ["tamanho": "Grande"]),
                        SKUResponse(id: "flat-white-m", price: 09, attributes: ["tamanho": "Médio"])
                    ],
                    allAttributes: [AttributeResponse(key: "tamanho", name: "Tamanho")]
                )
            }
        }
    }
}
