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
    
    class PreviewDraftOrderStore: DraftOrderStoring {
        var products: [DraftOrderProduct]
        
        init(products: [DraftOrderProduct]) {
            self.products = products
        }
        
        func getProducts() -> [DraftOrderProduct] {
            products
        }
        
        func addProduct(_ product: DraftOrderProduct) {
            products.append(product)
        }
        
        func updateProductQuantity(id: String, skuID: String, quantity: Int) {
            guard let index = products.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
                return
            }
            var product = products[index]
            product.quantity = quantity
            products[index] = product
        }
        
        func removeProduct(id: String, skuID: String) {
            guard let index = products.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
                return
            }
            products.remove(at: index)
        }
    }
}
