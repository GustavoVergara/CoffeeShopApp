import Collections
import Core

protocol ProductCustomizationWorking: AnyObject {
    func selectCustomization(_ customizationID: String, inSection sectionID: String)
    func increaseQuantity()
    func decreaseQuantity()
}

final class ProductCustomizationWorker: ProductCustomizationWorking {
    private let basePrice: Double
    private let stream: any MutableProductCustomizationStreaming
    
    init(productCustomizationStream: any MutableProductCustomizationStreaming,
         basePrice: Double) {
        self.stream = productCustomizationStream
        self.basePrice = basePrice
    }
    
    convenience init(productCustomizationStream: any MutableProductCustomizationStreaming,
                     product: ProductResponse) {
        if productCustomizationStream.data == nil {
            let sections = Self.mapSectionsFromProduct(product)
            let data = ProductCustomizationData(
                sections: sections,
                selectedQuantity: 1,
                currentPrice: product.basePrice ?? 0,
                hasSelectedAllRequiredCustomizations: Self.hasSelectedOptionInAllSections(sections)
            )
            productCustomizationStream.emit(data)
        }
        self.init(
            productCustomizationStream: productCustomizationStream,
            basePrice: product.basePrice ?? 0
        )
    }
    
    func selectCustomization(_ customizationID: String, inSection sectionID: String) {
        guard
            var currentData = stream.data,
            let sectionIndex = currentData.sections.firstIndex(where: { $0.id == sectionID })
        else {
            return
        }
        var section = currentData.sections[sectionIndex]
        section.options = section.options.map { option in
            var modifiableOption = option
            modifiableOption.isSelected = option.id == customizationID
            if modifiableOption.isSelected && option.isSelected {
                modifiableOption.isSelected = false
            }
            return modifiableOption
        }
        currentData.sections[sectionIndex] = section
        currentData.currentPrice = basePrice + Self.minPrice(currentData.sections)
        currentData.hasSelectedAllRequiredCustomizations = Self.hasSelectedOptionInAllSections(currentData.sections)
        stream.emit(currentData)
    }
    
    func increaseQuantity() {
        guard var currentData = stream.data else { return }
        currentData.selectedQuantity += 1
        stream.emit(currentData)
    }
    
    func decreaseQuantity() {
        guard var currentData = stream.data, currentData.selectedQuantity > 1 else { return }
        currentData.selectedQuantity -= 1
        stream.emit(currentData)
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
    
    private static func minPrice(_ sections: [ProductCustomizationSection]) -> Double {
        var price = 0.0
        for section in sections {
            for option in section.options {
                if option.isSelected {
                    price += option.additionalPrice
                }
            }
        }
        return price
    }
    
    private static func hasSelectedOptionInAllSections(_ sections: [ProductCustomizationSection]) -> Bool {
        sections.allSatisfy { $0.options.contains(where: \.isSelected) }
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
