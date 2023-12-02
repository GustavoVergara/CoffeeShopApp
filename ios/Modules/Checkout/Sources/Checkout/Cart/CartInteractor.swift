import Foundation
import Combine
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
    private let draftOrderStream: DraftOrderStreaming
    private let presenter: CartPresenting
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        draftOrderStore: DraftOrderStoring,
        draftOrderStream: DraftOrderStreaming,
        presenter: CartPresenting
    ) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderStream = draftOrderStream
        self.presenter = presenter
        
        draftOrderStream.publisher().receive(on: DispatchQueue.main).sink { products in
            presenter.displayItems(products)
        }.store(in: &cancellables)
    }
    
    func increaseQuantity(productID: String, skuID: String) {
        guard let product = draftOrderStore.getProducts().first(where: { $0.id == productID && $0.sku.id == skuID }) else {
            return
        }
        draftOrderStore.updateProductQuantity(id: productID, skuID: skuID, quantity: product.quantity + 1)
    }
    
    func decreaseQuantity(productID: String, skuID: String) {
        guard let product = draftOrderStore.getProducts().first(where: { $0.id == productID && $0.sku.id == skuID }) else {
            return
        }
        
        if product.quantity > 1 {
            draftOrderStore.updateProductQuantity(id: productID, skuID: skuID, quantity: product.quantity - 1)
        } else {
            draftOrderStore.removeProduct(id: productID, skuID: skuID)
        }
    }
}
