import SwiftUI
import Core

struct ProductDetailBuilder {
    public static let shared = Self.init()
    
    func build(product: ProductResponse) -> some View {
        let viewModel = ProductDetailViewModel(product: product)
        return ProductDetailView(viewModel: viewModel)
    }
    
    func buildPreview() -> some View {
        let viewModel = ProductDetailViewModel(
            id: "preview-product",
            name: "Cappuccino (Preview)",
            description: "(Preview) Feito com leite espresso e espuma de leite.",
            image: R.image.cappuccino(),
            price: "a partir de R$ 10,00",
            customizationSections: [
                ProductDetailViewModel.CustomizationSection(
                    id: "preview-tamanho",
                    title: "Tamanho",
                    options: [
                        ProductDetailViewModel.Customization(
                            name: "Pequeno",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Médio",
                            additionalPrice: 2,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Grande",
                            additionalPrice: 4,
                            isSelected: false)
                    ]
                ),
                ProductDetailViewModel.CustomizationSection(
                    id: "preview-adocante",
                    title: "Adoçar?",
                    options: [
                        ProductDetailViewModel.Customization(
                            name: "Sem Açucar",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Açucar Mascavo",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Açucar de Baunilha",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Açucar Cristal",
                            additionalPrice: 0,
                            isSelected: false),
                        ProductDetailViewModel.Customization(
                            name: "Sucralose",
                            additionalPrice: 0,
                            isSelected: false)
                    ]
                )
            ]
        )
        return ProductDetailView(viewModel: viewModel)
    }
}
