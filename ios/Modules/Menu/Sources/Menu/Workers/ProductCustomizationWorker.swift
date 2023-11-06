import Collections

protocol ProductCustomizationWorking: AnyObject {
    func selectCustomization(_ customizationID: String, inSection sectionID: String)
    func increaseQuantity()
    func decreaseQuantity()
    
    var sections: [ProductCustomizationSection] { get }
    var selectedQuantity: Int { get }
    var currentPrice: Double { get }
    var currentDisplayPrice: String { get }
}

final class ProductCustomizationWorker: ProductCustomizationWorking {
    var sections: [ProductCustomizationSection]
    var selectedQuantity: Int = 1
    var currentPrice: Double
    var currentDisplayPrice: String {
        priceFormatter.displayPrice(currentPrice)
    }
    
    private let priceFormatter: PriceFormatting
    
    init(priceFormatter: PriceFormatting = PriceFormatter(),
         customizationSections: [ProductCustomizationSection],
         currentPrice: Double,
         selectedQuantity: Int = 1) {
        self.priceFormatter = priceFormatter
        self.sections = customizationSections
        self.selectedQuantity = selectedQuantity
        self.currentPrice = currentPrice
    }
    
    convenience init(priceFormatter: PriceFormatting = PriceFormatter(), product: ProductResponse) {
        self.init(
            priceFormatter: priceFormatter,
            customizationSections: Self.mapSectionsFromProduct(product),
            currentPrice: 0,
            selectedQuantity: 1
        )
    }
    
    func selectCustomization(_ customizationID: String, inSection sectionID: String) {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == sectionID }) else {
            return
        }
        var section = sections[sectionIndex]
        section.options = section.options.map { option in
            var modifiableOption = option
            modifiableOption.isSelected = option.id == customizationID
            if modifiableOption.isSelected && option.isSelected {
                modifiableOption.isSelected = false
            }
            return modifiableOption
        }
        sections[sectionIndex] = section
    }
    
    func increaseQuantity() {
        selectedQuantity += 1
    }
    
    func decreaseQuantity() {
        guard selectedQuantity > 1 else { return }
        selectedQuantity -= 1
    }
    
    private static func mapSectionsFromProduct(_ product: ProductResponse) -> [ProductCustomizationSection] {
        guard let basePrice = product.basePrice else {
            return []
        }
        
        var sections = product.allAttributes.reduce(into: OrderedDictionary<String, ProductCustomizationSection>()) { partialResult, attribute in
            partialResult[attribute.key] = ProductCustomizationSection(id: attribute.key, title: attribute.name, options: [])
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
                
                section.options.append(ProductCustomization(name: attributeKV.value,
                                                     additionalPrice: additionalPrice,
                                                     isSelected: false))
                sections[attributeKV.key] = section
            }
        }
        
        return sections.values.filter { !$0.options.isEmpty }
    }
    
}

struct ProductCustomizationSection: Identifiable, Hashable {
    var id: String
    var title: String
    var options: [ProductCustomization]
}

struct ProductCustomization: Identifiable, Hashable {
    var id: String { name }
    var name: String
    var additionalPrice: Double
    var isSelected: Bool
    
    func displayAdditionalPrice(priceFormatter: PriceFormatting = PriceFormatter()) -> String {
        priceFormatter.displayPrice(additionalPrice)
    }
}
