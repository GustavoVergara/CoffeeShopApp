public protocol DraftOrderStoring {
    func addProduct(_ product: DraftOrderProduct)
    func removeProduct(id: String, skuID: String)
    func updateProductQuantity(id: String, skuID: String, quantity: Int)
    func getProducts() -> [DraftOrderProduct]
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
    
    public func addProduct(_ product: DraftOrderProduct) {
        var draftOrderProducts = store.object([DraftOrderProduct].self, forKey: storageKey) ?? []
        if let addedProductIndex = draftOrderProducts.firstIndex(where: { $0.id == product.id && $0.sku.id == product.sku.id }) {
            var addedProduct = draftOrderProducts[addedProductIndex]
            addedProduct.quantity += product.quantity
            draftOrderProducts[addedProductIndex] = addedProduct
        } else {
            draftOrderProducts.append(product)
        }
        store.store(draftOrderProducts, forKey: storageKey)
    }
    
    public func removeProduct(id: String, skuID: String) {
        var products = store.object([DraftOrderProduct].self, forKey: storageKey) ?? []
        guard let addedProductIndex = products.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
            return
        }
        
        products.remove(at: addedProductIndex)
        store.store(products, forKey: storageKey)
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
    
    public func getProducts() -> [DraftOrderProduct] {
        store.object([DraftOrderProduct].self, forKey: storageKey) ?? []
    }
}
