//import Combine
import Navigation
import Foundation

protocol OrderPlacedInteracting {
    func didPressBackButton()
}

class OrderPlacedInteractor: OrderPlacedInteracting {
    let stacker: ViewStacking
    let response: PlaceOrderResponse
    let presenter: OrderPlacedPresenting
    
    init(stacker: ViewStacking, response: PlaceOrderResponse, presenter: OrderPlacedPresenting) {
        self.stacker = stacker
        self.response = response
        self.presenter = presenter
        
        presenter.displayDeliveryDate(response.expectedDeliveryDate)
    }
    
    func didPressBackButton() {
        stacker.popToRoot()
    }
}
