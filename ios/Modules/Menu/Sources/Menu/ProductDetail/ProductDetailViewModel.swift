import SwiftUI
import Combine
import Collections
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
    
    convenience init(product: ProductResponse) {
        self.init(
            id: product.id,
            name: product.name,
            description: product.description,
            image: product.photo.flatMap { URL(string: $0) }.map { CoreImage.url($0) },
            price: product.displayPrice(),
            customizationSections: Self.mapSectionsFromProduct(product)
        )
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
    
    static func mapSectionsFromProduct(_ product: ProductResponse) -> [CustomizationSection] {
        guard let basePrice = product.basePrice() else {
            return []
        }
        
        var sections = product.allAttributes.reduce(into: OrderedDictionary<String, CustomizationSection>()) { partialResult, attribute in
            partialResult[attribute.key] = CustomizationSection(id: attribute.key, title: attribute.name, options: [])
        }
        
        for sku in product.skus {
            attributeLoop: for attributeKV in sku.attributes {
                guard var section = sections[attributeKV.key] else { continue }
                let additionalPrice = sku.price - basePrice
                
                for (existingOptionIndex, existingOption) in section.options.enumerated() where existingOption.name == attributeKV.value {
                    if existingOption.additionalPrice < additionalPrice {
                        continue attributeLoop
                    } else {
                        section.options.remove(at: existingOptionIndex)
                        break
                    }
                }
                
                section.options.append(Customization(name: attributeKV.value,
                                                     additionalPrice: additionalPrice,
                                                     isSelected: false))
                sections[attributeKV.key] = section
            }
        }
        
        return sections.values.filter { !$0.options.isEmpty }
    }
    
    struct CustomizationSection: Identifiable, Hashable {
        var id: String
        var title: String
        var options: [Customization]
    }
    
    struct Customization: Identifiable, Hashable {
        var id: String { name }
        var name: String
        var additionalPrice: Double
        var isSelected: Bool
        
        var displayAdditionalPrice: String {
            additionalPrice > 0 ? "+\(NumberFormatter.brlCurrencyFormatter.string(for: additionalPrice) ?? "??")" : ""
        }
    }
}
