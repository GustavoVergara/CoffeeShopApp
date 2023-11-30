import Core
import OrderLibrary

protocol CartInteracting {
    func increaseQuantity(productID: String, skuID: String)
    func decreaseQuantity(productID: String, skuID: String)
}

protocol CartPresenting {
    func displayItems(_ products: [DraftOrderProduct])
}

class CartInteractor: CartInteracting {
    private let draftOrderStore: DraftOrderStoring
    private let presenter: CartPresenting
    
    init(
        draftOrderStore: DraftOrderStoring,
        presenter: CartPresenting
    ) {
        self.draftOrderStore = draftOrderStore
        self.presenter = presenter
        
        presenter.displayItems(draftOrderStore.getProducts())
    }
    
    func increaseQuantity(productID: String, skuID: String) {
        guard let product = draftOrderStore.getProducts().first(where: { $0.id == productID && $0.sku.id == skuID }) else {
            return
        }
        draftOrderStore.updateProductQuantity(id: productID, skuID: skuID, quantity: product.quantity + 1)
        presenter.displayItems(draftOrderStore.getProducts())
    }
    
    func decreaseQuantity(productID: String, skuID: String) {
        guard let product = draftOrderStore.getProducts().first(where: { $0.id == productID && $0.sku.id == skuID }) else {
            return
        }
        
        if product.quantity > 1 {
            draftOrderStore.updateProductQuantity(id: productID, skuID: skuID, quantity: product.quantity - 1)
        } else {
            
        }
        presenter.displayItems(draftOrderStore.getProducts())
    }
}
