import SwiftUI
import Navigation
import OrderLibrary

struct PlaceOrderButtonBuilder: ViewBuilding {
    var id: String { "placeOrderButton" }
    
    let draftOrderStore: DraftOrderStoring
    let draftOrderStream: any DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let mutableUserSessionStream: MutableUserSessionStreaming
    let mutableOrderHistoryStream: MutableOrderHistoryStreaming
    let stacker: ViewStacking
    
    let viewModel: PlaceOrderButtonViewModel
    let interactor: PlaceOrderInteractor
    
    init(
        draftOrderStore: DraftOrderStoring,
        draftOrderStream: any DraftOrderStreaming,
        draftOrderTotalStream: DraftOrderTotalStreaming,
        mutableUserSessionStream: MutableUserSessionStreaming,
        mutableOrderHistoryStream: MutableOrderHistoryStreaming,
        stacker: ViewStacking
    ) {
        self.draftOrderStore = draftOrderStore
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.mutableUserSessionStream = mutableUserSessionStream
        self.mutableOrderHistoryStream = mutableOrderHistoryStream
        self.stacker = stacker
        
        viewModel = PlaceOrderButtonViewModel()
        interactor = PlaceOrderInteractor(draftOrderStore: draftOrderStore,
                                          draftOrderStream: draftOrderStream,
                                          draftOrderTotalStream: draftOrderTotalStream,
                                          mutableUserSessionStream: mutableUserSessionStream,
                                          mutableOrderHistoryStream: mutableOrderHistoryStream,
                                          stacker: stacker,
                                          presenter: viewModel)
    }
    
    func build() -> some View {
        return PlaceOrderButton(interactor: interactor,
                                viewModel: viewModel)
    }
}

struct PreviewPlaceOrderButtonBuilder: ViewBuilding {
    var id: String { "placeOrderButton/preview" }
    
    let stacker: ViewStacking
    
    func build() -> some View {
        let draftOrderStore = PreviewDraftOrderStore()
        let viewModel = PlaceOrderButtonViewModel()
        let interactor = PlaceOrderInteractor(draftOrderStore: draftOrderStore,
                                              draftOrderStream: draftOrderStore.stream,
                                              draftOrderTotalStream: draftOrderStore.totalStream,
                                              mutableUserSessionStream: PreviewUserSessionStream(),
                                              mutableOrderHistoryStream: PreviewOrderHistoryStream(),
                                              stacker: stacker,
                                              presenter: viewModel)
        return PlaceOrderButton(interactor: interactor,
                                viewModel: viewModel)
    }
}
