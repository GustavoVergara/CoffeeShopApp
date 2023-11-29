public struct DraftOrderProduct: Codable, Hashable {
    var id: String
    var name: String
    var sku: DraftOrderSKU
    var quantity: Int
}

public struct DraftOrderSKU: Codable, Hashable {
    var id: String
    var price: Double
    var attributes: [String: String]
    
    public init(id: String, price: Double, attributes: [String : String]) {
        self.id = id
        self.price = price
        self.attributes = attributes
    }
}

public protocol DraftOrderStoring {
    func addProduct(id: String, name: String, sku: DraftOrderSKU, quantity: Int)
    func updateProductQuantity(id: String, skuID: String, quantity: Int)
}

public class DraftOrderStore: DraftOrderStoring {
    let store: CodableStoring
    let storageKey = "draft-order"
    
    init(store: CodableStoring) {
        self.store = store
    }
    
    public convenience init() {
        self.init(store: DiskStorage())
    }
    
    public func addProduct(id: String, name: String, sku: DraftOrderSKU, quantity: Int) {
        var draftOrderProducts = store.object([DraftOrderProduct].self, forKey: storageKey) ?? []
        if let addedProductIndex = draftOrderProducts.firstIndex(where: { $0.id == id && $0.sku.id == sku.id }) {
            var addedProduct = draftOrderProducts[addedProductIndex]
            addedProduct.quantity += quantity
            draftOrderProducts[addedProductIndex] = addedProduct
        } else {
            draftOrderProducts.append(DraftOrderProduct(id: id, name: name, sku: sku, quantity: quantity))
        }
        store.store(draftOrderProducts, forKey: storageKey)
    }
    
    public func updateProductQuantity(id: String, skuID: String, quantity: Int) {
        guard
            var draftOrderProducts = store.object([DraftOrderProduct].self, forKey: storageKey),
            let addedProductIndex = draftOrderProducts.firstIndex(where: { $0.id == id && $0.sku.id == skuID })
        else {
            return
        }
        
        draftOrderProducts[addedProductIndex].quantity = quantity
        store.store(draftOrderProducts, forKey: storageKey)
    }
}
