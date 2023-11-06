protocol ProductDetailPresenting {
    func presentCustomizationSections(_ sections: [ProductCustomizationSection])
}

final class ProductDetailInteractor: ProductDetailInteracting {
    private let productCustomizationWorker: ProductCustomizationWorking
    private let presenter: ProductDetailPresenting
    
    init(productCustomizationWorker: ProductCustomizationWorking, presenter: ProductDetailPresenting) {
        self.productCustomizationWorker = productCustomizationWorker
        self.presenter = presenter
    }
    
    func selectCustomization(_ customizationID: String, inSection sectionID: String) {
        productCustomizationWorker.selectCustomization(customizationID, inSection: sectionID)
        presenter.presentCustomizationSections(productCustomizationWorker.sections)
    }
}
