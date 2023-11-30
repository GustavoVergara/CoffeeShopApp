import SwiftUI
import Core
import Navigation

struct ProductDetailBuilder: ViewBuilding {
    var id: String { "productDetail/\(product.id)" }
    
    let navigationStack: ViewStacking
    let cartBuilder: any ViewBuilding
    let product: ProductResponse
    
    func build() -> some View {
        let customizationStream = ProductCustomizationStream()
        let customizationWorker = ProductCustomizationWorker(productCustomizationStream: customizationStream, product: product)
        let addToDraftOrderButtonBuilder = AddToDraftOrderButtonBuilder(productCustomizationWorker: customizationWorker,
                                                                        productCustomizationStream: customizationStream,
                                                                        navigationStack: navigationStack,
                                                                        cartBuilder: cartBuilder,
                                                                        product: product)
        
        let viewModel = ProductDetailViewModel(product: product, customizationSections: customizationStream.data!.sections)
        let interactor = ProductDetailInteractor(productCustomizationWorker: customizationWorker, productCustomizationStream: customizationStream, presenter: viewModel)
        return ProductDetailView(interactor: interactor,
                                 viewModel: viewModel,
                                 addToDraftOrderButtonBuilder: addToDraftOrderButtonBuilder)
    }
}

struct PreviewProductDetailBuilder: ViewBuilding {
    var id: String { "productDetail/preview" }
    
    let navigationStack: ViewStacking
    
    func build() -> some View {
        let data = ProductCustomizationData(
            sections: [
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
            selectedQuantity: 1,
            currentPrice: 10,
            hasSelectedAllRequiredCustomizations: false
        )
        let product = ProductResponse(id: "preview-product",
                                      name: "Cappuccino (Preview)",
                                      description: "(Preview) Feito com leite espresso e espuma de leite.",
                                      skus: [],
                                      allAttributes: [])
        
        let stream = ProductCustomizationStream()
        stream.emit(data)
        let customizationWorker = ProductCustomizationWorker(
            productCustomizationStream: stream,
            basePrice: 10
        )
        
        let viewModel = ProductDetailViewModel(
            id: product.id,
            name: product.name,
            description: product.description,
            image: R.image.cappuccino(),
            price: "a partir de R$ 10,00",
            customizationSections: data.sections
        )
        
        let interactor = ProductDetailInteractor(productCustomizationWorker: customizationWorker, productCustomizationStream: stream, presenter: viewModel)
        return ProductDetailView(
            interactor: interactor,
            viewModel: viewModel,
            addToDraftOrderButtonBuilder: AddToDraftOrderButtonBuilder(productCustomizationWorker: customizationWorker,
                                                                       productCustomizationStream: stream,
                                                                       navigationStack: navigationStack,
                                                                       cartBuilder: PreviewViewBuilder(view: Color.blue),
                                                                       product: product)
        )
    }
}

// MARK: Protocols

protocol ProductDetailInteracting {
    func selectCustomization(_ customizationID: String, inSection sectionID: String)
}
