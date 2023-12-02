import Foundation
import Combine
import Navigation
import OrderLibrary

protocol OpenCartButtonInteracting {
    func didPressButton()
}

class OpenCartButtonInteractor: OpenCartButtonInteracting {
    let draftOrderStream: DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let stacker: ViewStacking
    let cartBuilder: any ViewBuilding
    let presenter: OpenCartButtonPresenter
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        draftOrderStream: DraftOrderStreaming,
        draftOrderTotalStream: DraftOrderTotalStreaming,
        stacker: ViewStacking,
        cartBuilder: any ViewBuilding,
        presenter: OpenCartButtonPresenter
    ) {
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.stacker = stacker
        self.cartBuilder = cartBuilder
        self.presenter = presenter
        
        draftOrderStream.publisher().receive(on: DispatchQueue.main).sink { [weak self] products in
            self?.presenter.displayProductCount(products.count)
        }.store(in: &cancellables)
        
        draftOrderTotalStream.publisher().receive(on: DispatchQueue.main).sink { [weak self] totalPrice in
            self?.presenter.displayTotal(totalPrice)
        }.store(in: &cancellables)
    }
    
    func didPressButton() {
        stacker.push(cartBuilder)
    }
}
