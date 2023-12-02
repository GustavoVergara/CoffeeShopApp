import SwiftUI
import Navigation
import OrderLibrary

struct PlaceOrderButtonBuilder: ViewBuilding {
    var id: String { "placeOrderButton" }
    
    let draftOrderStream: any DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    
    let viewModel: PlaceOrderButtonViewModel
    let interactor: PlaceOrderInteractor
    
    init(draftOrderStream: any DraftOrderStreaming, draftOrderTotalStream: DraftOrderTotalStreaming, mutableUserSessionStream: MutableUserSessionStreaming) {
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        
        viewModel = PlaceOrderButtonViewModel()
        interactor = PlaceOrderInteractor(draftOrderStream: draftOrderStream, draftOrderTotalStream: draftOrderTotalStream, mutableUserSessionStream: mutableUserSessionStream, presenter: viewModel)
    }
    
    func build() -> some View {
        return PlaceOrderButton(interactor: interactor,
                                viewModel: viewModel)
    }
}

struct PreviewPlaceOrderButtonBuilder: ViewBuilding {
    var id: String { "placeOrderButton/preview" }
    
    func build() -> some View {
        let draftOrderStore = PreviewDraftOrderStore()
        let viewModel = PlaceOrderButtonViewModel()
        let interactor = PlaceOrderInteractor(draftOrderStream: draftOrderStore.stream,
                                              draftOrderTotalStream: draftOrderStore.totalStream,
                                              mutableUserSessionStream: PreviewUserSessionStream(),
                                              presenter: viewModel)
        return PlaceOrderButton(interactor: interactor,
                                viewModel: viewModel)
    }
}
