import Combine
import Core

struct ProductCustomizationData {
    var sections: [ProductCustomizationSection]
    var selectedQuantity: Int
    var currentPrice: Double
    var hasSelectedAllRequiredCustomizations: Bool
}

protocol ProductCustomizationStreaming {
    var data: ProductCustomizationData? { get }
    
    func publisher() -> any Publisher<ProductCustomizationData, Never>
}

protocol MutableProductCustomizationStreaming: ProductCustomizationStreaming {
    func emit(_ data: ProductCustomizationData)
}

final class ProductCustomizationStream: MutableProductCustomizationStreaming, ObservableObject {
    @Published
    var data: ProductCustomizationData?

    func publisher() -> any Publisher<ProductCustomizationData, Never> {
        $data.compactMap { $0 }
    }
    
    func emit(_ data: ProductCustomizationData) {
        self.data = data
    }
}
