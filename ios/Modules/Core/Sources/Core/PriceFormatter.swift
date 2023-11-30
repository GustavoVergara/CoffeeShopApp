import Foundation

public protocol PriceFormatting {
    func displayPrice(_ price: Double?, hasHigherPrices: Bool) -> String
}

public extension PriceFormatting {
    func displayPrice(_ price: Double?) -> String {
        displayPrice(price, hasHigherPrices: false)
    }
}

public struct PriceFormatter: PriceFormatting {
    let formatter: NumberFormatter
    
    init(formatter: NumberFormatter) {
        self.formatter = formatter
    }
    
    public init() {
        self.init(formatter: NumberFormatter.brlCurrencyFormatter)
    }
    
    public func displayPrice(_ price: Double?, hasHigherPrices: Bool) -> String {
        guard let price else { return "??" }
        if hasHigherPrices {
            return "apartir de \(formatter.string(for: price) ?? "??")"
        } else {
            return formatter.string(for: price) ?? "??"
        }
    }
    
}

extension NumberFormatter {
    static let brlCurrencyFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "BRL"
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }()
}
