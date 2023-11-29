import Combine
import Core

protocol AddToDraftOrderInteracting {
    func increaseQuantity()
    func decreaseQuantity()
    func addToDraftOrder()
}

protocol AddToDraftOrderPresenting {
    func displayQuantity(_ quantity: Int)
    func displayPrice(_ price: Double)
    func enableAddToDraftOrder(_ enabled: Bool)
}

final class AddToDraftOrderInteractor: AddToDraftOrderInteracting {
    private let productCustomizationWorker: ProductCustomizationWorking
    private let presenter: AddToDraftOrderPresenting
    private let productCustomizationStream: ProductCustomizationStreaming
    private var cancellables = Set<AnyCancellable>()
    
    init(productCustomizationWorker: ProductCustomizationWorking,
         presenter: AddToDraftOrderPresenting,
         productCustomizationStream: ProductCustomizationStreaming) {
        self.productCustomizationWorker = productCustomizationWorker
        self.presenter = presenter
        self.productCustomizationStream = productCustomizationStream
        
        productCustomizationStream.publisher().sink(receiveCompletion: doNothing) { [weak self] data in
            guard let self else { return }
            self.presenter.displayQuantity(data.selectedQuantity)
            self.presenter.displayPrice(data.currentPrice)
            self.presenter.enableAddToDraftOrder(data.hasSelectedAllRequiredCustomizations)
        }.store(in: &cancellables)
    }

    func increaseQuantity() {
        productCustomizationWorker.increaseQuantity()
    }
    
    func decreaseQuantity() {
        productCustomizationWorker.decreaseQuantity()
    }
    
    func addToDraftOrder() {
        // TODO: Implement addToDraftOrder
    }
}
