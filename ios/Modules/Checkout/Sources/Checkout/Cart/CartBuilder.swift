import SwiftUI
import Navigation
import OrderLibrary

public struct CartBuilder: ViewBuilding {
    public var id: String { "cart" }
    
    let draftOrderStore: DraftOrderStoring
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    let draftOrderStream: any DraftOrderStreaming
    let stacker: ViewStacking
    
    let viewModel: CartViewModel
    let interactor: CartInteractor
    let placeOrderButtonBuilder: PlaceOrderButtonBuilder
    
    public init(draftOrderStore: DraftOrderStoring, draftOrderTotalStream: DraftOrderTotalStreaming, mutableUserSessionStream: MutableUserSessionStreaming, draftOrderStream: any DraftOrderStreaming, stacker: ViewStacking) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        self.draftOrderStream = draftOrderStream
        self.stacker = stacker
        
        viewModel = CartViewModel()
        interactor = CartInteractor(draftOrderStore: draftOrderStore, draftOrderStream: draftOrderStream, presenter: viewModel)
        placeOrderButtonBuilder = PlaceOrderButtonBuilder(draftOrderStore: draftOrderStore,
                                                          draftOrderStream: draftOrderStream,
                                                          draftOrderTotalStream: draftOrderTotalStream,
                                                          mutableUserSessionStream: mutableUserSessionStream,
                                                          stacker: stacker)
    }
    
    public func build() -> some View {
        return CartView(placeOrderButtonBuilder: placeOrderButtonBuilder, interactor: interactor, viewModel: viewModel)
    }
}

struct PreviewCartBuilder: ViewBuilding {
    var id: String { "preview/cart" }

    let stacker: ViewStacking
    var products: [DraftOrderProduct]
    
    func build() -> some View {
        let draftOrderStore = PreviewDraftOrderStore(products: products)
        let viewModel = CartViewModel()
        let interactor = CartInteractor(draftOrderStore: draftOrderStore, draftOrderStream: draftOrderStore.stream, presenter: viewModel)
        return CartView(
            placeOrderButtonBuilder: PlaceOrderButtonBuilder(draftOrderStore: draftOrderStore,
                                                             draftOrderStream: draftOrderStore.stream,
                                                             draftOrderTotalStream: draftOrderStore.totalStream,
                                                             mutableUserSessionStream: PreviewUserSessionStream(),
                                                             stacker: stacker),
            interactor: interactor,
            viewModel: viewModel
        )
    }
}
