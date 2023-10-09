import SwiftUI

public struct MenuBuilder {
    
    public static func build() -> some View {
        let viewModel = MenuViewModel()
        let interactor = MenuInteractor(presenter: viewModel)
        return MenuView(interactor: interactor, viewModel: viewModel)
    }
    
    func buildPreview() -> some View {
        let viewModel = MenuViewModel()
        let interactor = PreviewMenuInteractor(presenter: viewModel)
        return MenuView(interactor: interactor, viewModel: viewModel)
    }
    
}

class PreviewMenuInteractor: MenuInteracting {
    private let presenter: MenuPresenting
    
    init(presenter: MenuPresenting) {
        self.presenter = presenter
    }
    
    func didAppear() async {
        let products: [MenuResponse.ProductResponse] = [
            MenuResponse.ProductResponse(
                id: "capp",
                name: "Cappuchino",
                description: "Dose dupla de expresso com leite vaporizado",
                photo: "https://globalassets.starbucks.com/digitalassets/products/bev/SBX20190617_Cappuccino.jpg?impolicy=1by1_wide_topcrop_630",
                skus: [
                    MenuResponse.SKUResponse(id: "capp-g", price: 12, attributes: ["tamanho": "Grande"]),
                    MenuResponse.SKUResponse(id: "capp-m", price: 10, attributes: ["tamanho": "Médio"])
                ],
                allAttributes: [MenuResponse.AttributeResponse(key: "tamanho", name: "Tamanho")]
            ),
            MenuResponse.ProductResponse(
                id: "flat-white",
                name: "Flat white",
                description: "Dose dupla de expresso com leite vaporizado",
                photo: "https://globalassets.starbucks.com/digitalassets/products/bev/SBX20230406_FlatWhite.jpg?impolicy=1by1_wide_topcrop_630",
                skus: [
                    MenuResponse.SKUResponse(id: "flat-white-g", price: 11, attributes: ["tamanho": "Grande"]),
                    MenuResponse.SKUResponse(id: "flat-white-m", price: 09, attributes: ["tamanho": "Médio"])
                ],
                allAttributes: [MenuResponse.AttributeResponse(key: "tamanho", name: "Tamanho")]
            )
        ]
        let menu = MenuResponse(storeID: "0", storeName: "Preview Store", products: products)
        await presenter.presentMenu(menu)
    }
}
