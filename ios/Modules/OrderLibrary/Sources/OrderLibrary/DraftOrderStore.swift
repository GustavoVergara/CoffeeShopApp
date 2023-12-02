public protocol DraftOrderStoring {
    func addProduct(_ product: DraftOrderProduct)
    func removeProduct(id: String, skuID: String)
    func updateProductQuantity(id: String, skuID: String, quantity: Int)
    func getProducts() -> [DraftOrderProduct]
}

public class DraftOrderStore: DraftOrderStoring {
    let store: CodableStoring
    let stream: any MutableDraftOrderStreaming

    let storageKey = "draft-order"
    
    init(store: CodableStoring, stream: any MutableDraftOrderStreaming) {
        self.store = store
        self.stream = stream
        
        stream.emit(getProducts())
    }
    
    public convenience init(stream: any MutableDraftOrderStreaming) {
        self.init(store: DiskStorage(), stream: stream)
    }
    
    public func addProduct(_ product: DraftOrderProduct) {
        var draftOrderProducts = stream.data
        if let addedProductIndex = draftOrderProducts.firstIndex(where: { $0.id == product.id && $0.sku.id == product.sku.id }) {
            var addedProduct = draftOrderProducts[addedProductIndex]
            addedProduct.quantity += product.quantity
            draftOrderProducts[addedProductIndex] = addedProduct
        } else {
            draftOrderProducts.append(product)
        }
        store.store(draftOrderProducts, forKey: storageKey)
        stream.emit(draftOrderProducts)
    }
    
    public func removeProduct(id: String, skuID: String) {
        var products = stream.data
        guard let addedProductIndex = products.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
            return
        }
        
        products.remove(at: addedProductIndex)
        store.store(products, forKey: storageKey)
        stream.emit(products)
    }
    
    public func updateProductQuantity(id: String, skuID: String, quantity: Int) {
        var draftOrderProducts = stream.data
        guard
            let addedProductIndex = draftOrderProducts.firstIndex(where: { $0.id == id && $0.sku.id == skuID })
        else {
            return
        }
        
        draftOrderProducts[addedProductIndex].quantity = quantity
        store.store(draftOrderProducts, forKey: storageKey)
        stream.emit(draftOrderProducts)
    }
    
    public func getProducts() -> [DraftOrderProduct] {
        store.object([DraftOrderProduct].self, forKey: storageKey) ?? []
    }
}
