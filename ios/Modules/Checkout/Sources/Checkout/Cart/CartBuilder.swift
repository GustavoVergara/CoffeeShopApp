import SwiftUI
import Navigation
import OrderLibrary

public struct CartBuilder: ViewBuilding {
    public var id: String { "cart" }
    
    let draftOrderStore: DraftOrderStoring
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    let draftOrderStream: any DraftOrderStreaming
    
    let viewModel: CartViewModel
    let interactor: CartInteractor
    let placeOrderButtonBuilder: PlaceOrderButtonBuilder
    
    public init(draftOrderStore: DraftOrderStoring, draftOrderTotalStream: DraftOrderTotalStreaming, mutableUserSessionStream: MutableUserSessionStreaming, draftOrderStream: any DraftOrderStreaming) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        self.draftOrderStream = draftOrderStream
        
        viewModel = CartViewModel()
        interactor = CartInteractor(draftOrderStore: draftOrderStore, presenter: viewModel)
        placeOrderButtonBuilder = PlaceOrderButtonBuilder(draftOrderStream: draftOrderStream, draftOrderTotalStream: draftOrderTotalStream, mutableUserSessionStream: mutableUserSessionStream)
    }
    
    public func build() -> some View {
        return CartView(placeOrderButtonBuilder: placeOrderButtonBuilder, interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewCartBuilder: ViewBuilding {
    var id: String { "preview/cart" }

    var products: [DraftOrderProduct]
    
    func build() -> some View {
        let draftOrderStore = PreviewDraftOrderStore(products: products)
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: draftOrderStore, presenter: viewModel)
        return CartView(
            placeOrderButtonBuilder: PlaceOrderButtonBuilder(draftOrderStream: draftOrderStore.stream, draftOrderTotalStream: draftOrderStore.totalStream, mutableUserSessionStream: PreviewUserSessionStream()),
            interactor: interactor,
            viewModel: viewModel
        )
    }
}
