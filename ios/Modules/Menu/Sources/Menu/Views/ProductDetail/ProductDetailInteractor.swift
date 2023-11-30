import Combine
import Core

protocol ProductDetailPresenting {
    func presentCustomizationSections(_ sections: [ProductCustomizationSection])
}

final class ProductDetailInteractor: ProductDetailInteracting {
    private let productCustomizationWorker: ProductCustomizationWorking
    private let productCustomizationStream: ProductCustomizationStreaming
    private let presenter: ProductDetailPresenting
    private var cancellables = Set<AnyCancellable>()

    init(productCustomizationWorker: ProductCustomizationWorking,
         productCustomizationStream: ProductCustomizationStreaming,
         presenter: ProductDetailPresenting) {
        self.productCustomizationWorker = productCustomizationWorker
        self.productCustomizationStream = productCustomizationStream
        self.presenter = presenter
        
        productCustomizationStream.publisher().sink(receiveCompletion: doNothing) { [weak self] data in
            guard let self else { return }
            self.presenter.presentCustomizationSections(data.sections)
        }.store(in: &cancellables)
    }
    
    func selectCustomization(_ customizationID: String, inSection sectionID: String) {
        productCustomizationWorker.selectCustomization(customizationID, inSection: sectionID)
    }
}
