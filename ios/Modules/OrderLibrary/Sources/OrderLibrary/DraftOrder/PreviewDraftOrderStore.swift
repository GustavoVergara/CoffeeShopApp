public class PreviewDraftOrderStore: DraftOrderStoring {
    public let stream = DraftOrderStream()
    public private(set) lazy var totalStream = DraftOrderTotalStream(draftOrderStream: stream)
    
    public init(products: [DraftOrderProduct] = []) {
        stream.emit(products)
    }
    
    public func getProducts() -> [DraftOrderProduct] {
        stream.data
    }
    
    public func addProduct(_ product: DraftOrderProduct) {
        var products = stream.data
        products.append(product)
        stream.emit(products)
    }
    
    public func updateProductQuantity(id: String, skuID: String, quantity: Int) {
        guard let index = stream.data.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
            return
        }
        var product = stream.data[index]
        product.quantity = quantity
        var products = stream.data
        products[index] = product
        stream.emit(products)
    }
    
    public func removeProduct(id: String, skuID: String) {
        guard let index = stream.data.firstIndex(where: { $0.id == id && $0.sku.id == skuID }) else {
            return
        }
        var products = stream.data
        products.remove(at: index)
        stream.emit(products)
    }
    
    public func clear() {
        stream.emit([])
    }
}
