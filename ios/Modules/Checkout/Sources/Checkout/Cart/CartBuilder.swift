import SwiftUI
import Navigation
import OrderLibrary

public struct CartBuilder: ViewBuilding {
    public var id: String { "cart" }
    
    let draftOrderStore: DraftOrderStoring
    let draftOrderTotalStream: DraftOrderTotalStreaming
    
    public init(draftOrderStore: DraftOrderStoring, draftOrderTotalStream: DraftOrderTotalStreaming) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderTotalStream = draftOrderTotalStream
    }
    
    public func build() -> some View {
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: draftOrderStore, presenter: viewModel)
        return CartView(placeOrderButtonBuilder: PlaceOrderButtonBuilder(draftOrderTotalStream: draftOrderTotalStream), interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewCartBuilder: ViewBuilding {
    var id: String { "preview/cart" }

    var products: [DraftOrderProduct]
    
    func build() -> some View {
        let draftOrderStore = PreviewDraftOrderStore(products: products)
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: draftOrderStore, presenter: viewModel)
        return CartView(placeOrderButtonBuilder: PlaceOrderButtonBuilder(draftOrderTotalStream: draftOrderStore.totalStream), interactor: interactor, viewModel: viewModel)
    }
}
