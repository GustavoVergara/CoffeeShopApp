import Combine
import Core
import Navigation
import OrderLibrary

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
    private let productCustomizationStream: ProductCustomizationStreaming
    private let draftOrderStore: DraftOrderStoring
    private let navigationStack: ViewStacking
    private let cartBuilder: any ViewBuilding
    private let presenter: AddToDraftOrderPresenting
    private let product: ProductResponse
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedSKU: DraftOrderSKU?
    
    init(productCustomizationWorker: ProductCustomizationWorking,
         productCustomizationStream: ProductCustomizationStreaming,
         draftOrderStore: DraftOrderStoring,
         navigationStack: ViewStacking,
         cartBuilder: any ViewBuilding,
         presenter: AddToDraftOrderPresenting,
         product: ProductResponse) {
        self.productCustomizationWorker = productCustomizationWorker
        self.productCustomizationStream = productCustomizationStream
        self.draftOrderStore = draftOrderStore
        self.navigationStack = navigationStack
        self.cartBuilder = cartBuilder
        self.presenter = presenter
        self.product = product
        
        productCustomizationStream.publisher().sink(receiveCompletion: doNothing) { [weak self] data in
            guard let self else { return }
            self.presenter.displayQuantity(data.selectedQuantity)
            self.presenter.displayPrice(data.currentPrice)
            self.presenter.enableAddToDraftOrder(data.hasSelectedAllRequiredCustomizations)
            if data.hasSelectedAllRequiredCustomizations {
                self.selectedSKU = self.mapSelectedSKU(data: data)
            } else {
                self.selectedSKU = nil
            }
        }.store(in: &cancellables)
    }

    func increaseQuantity() {
        productCustomizationWorker.increaseQuantity()
    }
    
    func decreaseQuantity() {
        productCustomizationWorker.decreaseQuantity()
    }
    
    func addToDraftOrder() {
        guard let selectedSKU else { return }
        draftOrderStore.addProduct(DraftOrderProduct(id: product.id, name: product.name, imageURL: product.photo, sku: selectedSKU, quantity: productCustomizationStream.data?.selectedQuantity ?? 1))
        navigationStack.push(cartBuilder)
        navigationStack.pop(id: "productDetail/\(product.id)")
    }
    
    func mapSelectedSKU(data: ProductCustomizationData) -> DraftOrderSKU? {
        var selectedOptionsPerSection = [String: String]()
        for section in data.sections {
            for option in section.options where option.isSelected {
                selectedOptionsPerSection[section.id] = option.id
                break
            }
        }
        return product.skus
            .first { $0.attributes == selectedOptionsPerSection }
            .map { DraftOrderSKU(id: $0.id, price: $0.price, attributes: $0.attributes) }
    }
}
