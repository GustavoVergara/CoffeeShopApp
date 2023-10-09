import SwiftUI
import Core

protocol ProductDetailInteracting: AnyObject {
    func selectCustomization(_ customizationID: String, inSection sectionID: String)
}

final class ProductDetailViewModel: ObservableObject, ProductDetailInteracting {
    var id: String
    var name: String
    var description: String
    var image: any View
    var price: String
    @Published
    var customizationSections: [CustomizationSection]
    
    init(id: String,
         name: String,
         description: String,
         image: any View,
         price: String,
         customizationSections: [ProductDetailViewModel.CustomizationSection]) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.price = price
        self.customizationSections = customizationSections
    }
    
    func selectCustomization(_ customizationID: String, inSection sectionID: String) {
        guard let sectionIndex = customizationSections.firstIndex(where: { $0.id == sectionID }) else {
            return
        }
        var section = customizationSections[sectionIndex]
        section.options = section.options.map { option in
            var modifiableOption = option
            modifiableOption.isSelected = option.id == customizationID
            if modifiableOption.isSelected && option.isSelected {
                modifiableOption.isSelected = false
            }
            return modifiableOption
        }
        customizationSections[sectionIndex] = section
    }
    
    struct CustomizationSection: Identifiable, Hashable {
        var id: String
        var title: String
        var options: [Customization]
    }
    
    struct Customization: Identifiable, Hashable {
        var id: String
        var name: String
        var price: String
        var isSelected: Bool
    }
    
    static let preview = ProductDetailViewModel(
        id: "preview-product",
        name: "Cappuccino (Preview)",
        description: "(Preview) Feito com leite espresso e espuma de leite.",
        image: R.image.cappuccino(),
        price: "a partir de R$ 10,00",
        customizationSections: [
            CustomizationSection(
                id: "preview-tamanho",
                title: "Tamanho",
                options: [
                    Customization(
                        id: "preview-custom-p",
                        name: "Pequeno",
                        price: "R$ 10",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-m",
                        name: "Médio",
                        price: "R$ 12",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-g",
                        name: "Grande",
                        price: "R$ 14",
                        isSelected: false)
                ]
            ),
            CustomizationSection(
                id: "preview-adocante",
                title: "Adoçar?",
                options: [
                    Customization(
                        id: "preview-custom-sem",
                        name: "Sem Açucar",
                        price: "",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-mascavo",
                        name: "Açucar Mascavo",
                        price: "",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-baunilha",
                        name: "Açucar de Baunilha",
                        price: "",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-cristal",
                        name: "Açucar Cristal",
                        price: "",
                        isSelected: false),
                    Customization(
                        id: "preview-custom-sucralose",
                        name: "Sucralose",
                        price: "",
                        isSelected: false)
                ]
            )
        ]
    )
}
