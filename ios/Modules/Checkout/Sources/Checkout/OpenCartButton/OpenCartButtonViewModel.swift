import Combine
import Core

protocol OpenCartButtonPresenter {
    func displayTotal(_ totalPrice: Double)
    func displayProductCount(_ count: Int)
}

class OpenCartButtonViewModel: ObservableObject, OpenCartButtonPresenter {
    let priceFormatter: PriceFormatting
    
    init(priceFormatter: PriceFormatting = PriceFormatter()) {
        self.priceFormatter = priceFormatter
    }
    
    @Published
    var totalPrice: String = ""
    
    @Published
    var productCount: Int = 0
    
    func displayTotal(_ totalPrice: Double) {
        self.totalPrice = priceFormatter.displayPrice(totalPrice)
    }
    
    func displayProductCount(_ count: Int) {
        self.productCount = count
    }
}
