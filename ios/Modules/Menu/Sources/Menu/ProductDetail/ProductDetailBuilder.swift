import SwiftUI
import Core

struct ProductDetailBuilder {
    public static let shared = Self.init()
    
    func build(product: ProductResponse) -> some View {
        let customizationWorker = ProductCustomizationWorker(product: product)
        let viewModel = ProductDetailViewModel(product: product, customizationSections: customizationWorker.sections)
        let interactor = ProductDetailInteractor(productCustomizationWorker: customizationWorker, presenter: viewModel)
        return ProductDetailView(interactor: interactor, viewModel: viewModel)
    }
    
    func buildPreview() -> some View {
        let customizationWorker = ProductCustomizationWorker(
            customizationSections: [
                ProductCustomizationSection(
                    id: "preview-tamanho",
                    title: "Tamanho",
                    options: [
                        ProductCustomization(
                            name: "Pequeno",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Médio",
                            additionalPrice: 2,
                            isSelected: false),
                        ProductCustomization(
                            name: "Grande",
                            additionalPrice: 4,
                            isSelected: false)
                    ]
                ),
                ProductCustomizationSection(
                    id: "preview-adocante",
                    title: "Adoçar?",
                    options: [
                        ProductCustomization(
                            name: "Sem Açucar",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar Mascavo",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar de Baunilha",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Açucar Cristal",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductCustomization(
                            name: "Sucralose",
                            additionalPrice: 0,
                            isSelected: false)
                    ]
                )
            ],
            currentPrice: 10
        )
        
        let viewModel = ProductDetailViewModel(
            id: "preview-product",
            name: "Cappuccino (Preview)",
            description: "(Preview) Feito com leite espresso e espuma de leite.",
            image: R.image.cappuccino(),
            price: "a partir de R$ 10,00",
            customizationSections: customizationWorker.sections
        )
        
        let interactor = ProductDetailInteractor(productCustomizationWorker: customizationWorker, presenter: viewModel)
        return ProductDetailView(interactor: interactor, viewModel: viewModel)
    }
}

// MARK: Protocols

protocol ProductDetailInteracting {
    func selectCustomization(_ customizationID: String, inSection sectionID: String)
}
