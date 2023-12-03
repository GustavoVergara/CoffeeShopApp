public protocol OrderHistoryStoring {
    func store(_ order: Order)
    func getOrders() -> [Order]
}

public class OrderHistoryStore: OrderHistoryStoring {
    let store: CodableStoring
    
    private let orderLedgerKey = "order-ledger"
    private var ledger: OrderLedger?
    
    init(store: CodableStoring) {
        self.store = store
    }
    
    public convenience init() {
        self.init(store: DiskStorage())
    }
    
    private func key(id: String) -> String { "order-\(id)" }
    
    private func getLedger() -> OrderLedger {
        if let ledger {
            return ledger
        } else if let ledger = store.object(OrderLedger.self, forKey: orderLedgerKey) {
            self.ledger = ledger
            return ledger
        } else {
            let ledger = OrderLedger(orderIDs: [])
            self.ledger = ledger
            return ledger
        }
    }
    
    public func store(_ order: Order) {
        var ledger = getLedger()
        ledger.orderIDs.append(order.id)
        store.store(ledger, forKey: orderLedgerKey)
        store.store(order, forKey: key(id: order.id))
    }
    
    public func getOrders() -> [Order] {
        let ledger = getLedger()
        var modifiableLedger = ledger

        var orders = [Order]()
        for (index, orderID) in ledger.orderIDs.enumerated() {
            let order = store.object(Order.self, forKey: key(id: orderID))
            
            if let order {
                orders.append(order)
            } else {
                modifiableLedger.orderIDs.remove(at: index)
            }
        }
        
        if ledger != modifiableLedger {
            store.store(modifiableLedger, forKey: orderLedgerKey)
        }
        
        return orders
    }
}

import Foundation

fileprivate struct OrderLedger: Codable, Equatable {
    var orderIDs: [String]
}

public struct Order: Codable, Equatable {
    public var id: String
    public var products: [DraftOrderProduct]
    public var date: Date
    public var estimatedDeliveryDate: Date
    public var user: UserSession
    
    public init(id: String, products: [DraftOrderProduct], date: Date, estimatedDeliveryDate: Date, user: UserSession) {
        self.id = id
        self.products = products
        self.date = date
        self.estimatedDeliveryDate = estimatedDeliveryDate
        self.user = user
    }
}
