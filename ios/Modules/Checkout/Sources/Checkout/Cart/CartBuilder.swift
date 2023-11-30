import SwiftUI
import Navigation
import OrderLibrary

public struct CartBuilder: ViewBuilding {
    public var id: String { "cart" }
    
    public init() {}
    
    public func build() -> some View {
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: DraftOrderStore(), presenter: viewModel)
        return CartView(interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewCartBuilder: ViewBuilding {
    var id: String { "preview/cart" }

    var products: [DraftOrderProduct]
    
    func build() -> some View {
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: PreviewDraftOrderStore(products: products), presenter: viewModel)
        return CartView(interactor: interactor, viewModel: viewModel)
    }
    
    struct PreviewDraftOrderStore: DraftOrderStoring {
        var products: [DraftOrderProduct]
        
        func getProducts() -> [DraftOrderProduct] {
            products
        }
        
        func addProduct(_ product: DraftOrderProduct) {}
        func updateProductQuantity(id: String, skuID: String, quantity: Int) {}
        func removeProduct(id: String, skuID: String) {}
    }
}
