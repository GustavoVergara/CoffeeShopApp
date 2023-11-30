import SwiftUI
import OrderLibrary

protocol CartBuilding {
    associatedtype Content: View
    func build() -> Content
}

struct CartBuilder: CartBuilding {
    func build() -> some View {
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: DraftOrderStore(), presenter: viewModel)
        return CartView(interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewCartBuilder: CartBuilding {
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
