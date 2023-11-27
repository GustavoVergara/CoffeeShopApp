import Combine
import Core

struct ProductCustomizationData {
    var sections: [ProductCustomizationSection]
    var selectedQuantity: Int
    var currentPrice: Double
    var hasSelectedAllRequiredCustomizations: Bool
}

protocol ProductCustomizationStreaming: Streaming where Output == ProductCustomizationData {}
protocol MutableProductCustomizationStreaming: ProductCustomizationStreaming, MutableStreaming where Output == ProductCustomizationData {}

final class ProductCustomizationStream: MutableProductCustomizationStreaming {
    @Published
    var data: ProductCustomizationData?

    func publisher() -> some Publisher<ProductCustomizationData, Never> {
        $data.compactMap { $0 }
    }
    
    func emit(_ data: ProductCustomizationData) {
        self.data = data
    }
}
