import SwiftUI
import Navigation

struct OrderPlacedBuilder: ViewBuilding {
    let stacker: ViewStacking
    let response: PlaceOrderResponse
    
    init(stacker: ViewStacking, response: PlaceOrderResponse) {
        self.stacker = stacker
        self.response = response
    }
    
    var id: String { "orderPlaced" }
    
    func build() -> some View {
        let viewModel = OrderPlacedViewModel()
        let interactor = OrderPlacedInteractor(stacker: stacker, response: response, presenter: viewModel)
        return OrderPlacedView(interactor: interactor, viewModel: viewModel)
    }
}
