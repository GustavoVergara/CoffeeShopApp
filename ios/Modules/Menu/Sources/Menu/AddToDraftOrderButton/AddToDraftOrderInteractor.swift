protocol AddToDraftOrderInteracting {
    func increaseQuantity()
    func decreaseQuantity()
    func addToDraftOrder()
}

protocol AddToDraftOrderPresenting {
    func displayQuantity(_ quantity: Int)
    func displayPrice(_ price: String)
}

final class AddToDraftOrderInteractor: AddToDraftOrderInteracting {
    private let productCustomizationWorker: ProductCustomizationWorking
    private let presenter: AddToDraftOrderPresenting
    
    init(productCustomizationWorker: ProductCustomizationWorking, presenter: AddToDraftOrderPresenting) {
        self.productCustomizationWorker = productCustomizationWorker
        self.presenter = presenter
    }

    func increaseQuantity() {
        productCustomizationWorker.increaseQuantity()
        presenter.displayQuantity(productCustomizationWorker.selectedQuantity)
        presenter.displayPrice(productCustomizationWorker.currentDisplayPrice)
    }
    
    func decreaseQuantity() {
        productCustomizationWorker.decreaseQuantity()
        presenter.displayQuantity(productCustomizationWorker.selectedQuantity)
        presenter.displayPrice(productCustomizationWorker.currentDisplayPrice)
    }
    
    func addToDraftOrder() {
        // TODO: Implement addToDraftOrder
    }
}
