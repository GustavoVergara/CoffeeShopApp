import SwiftUI
import Navigation
import OrderLibrary

struct PlaceOrderButtonBuilder: ViewBuilding {
    var id: String { "placeOrderButton" }
    
    let draftOrderTotalStream: DraftOrderTotalStreaming
    
    func build() -> some View {
        let viewModel = PlaceOrderButtonViewModel()
        let interactor = PlaceOrderInteractor(draftOrderTotalStream: draftOrderTotalStream, presenter: viewModel)
        return PlaceOrderButton(interactor: interactor,
                                viewModel: viewModel,
                                userName: "")
    }
}
