import SwiftUI
import Core

class ProductDetailViewModel: ObservableObject, ProductDetailPresenting {
    var id: String
    var name: String
    var description: String
    var image: CoreImage
    var price: String
    @Published var customizationSections: [ProductCustomizationSection]
    
    init(
         id: String,
         name: String,
         description: String,
         image: CoreImage,
         price: String,
         customizationSections: [ProductCustomizationSection]) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.price = price
        self.customizationSections = customizationSections
    }
    
    convenience init(priceFormatter: PriceFormatting = PriceFormatter(), product: ProductResponse, customizationSections: [ProductCustomizationSection]) {
        self.init(
            id: product.id,
            name: product.name,
            description: product.description,
            image: product.photo.flatMap { URL(string: $0) }.map { CoreImage.url($0) } ?? CoreImage.system("cup.and.saucer.fill"),
            price: priceFormatter.minimunDisplayPrice(in: product.skus),
            customizationSections: customizationSections
        )
    }
    
    func presentCustomizationSections(_ sections: [ProductCustomizationSection]) {
        customizationSections = sections
    }
}
