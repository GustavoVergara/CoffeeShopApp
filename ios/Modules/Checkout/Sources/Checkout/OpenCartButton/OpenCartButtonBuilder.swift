import SwiftUI
import Navigation
import OrderLibrary

public struct OpenCartButtonBuilder: ViewBuilding {
    let draftOrderStream: DraftOrderStreaming
    let draftOrderTotalStream: DraftOrderTotalStreaming
    let stacker: ViewStacking
    let cartBuilder: any ViewBuilding
    
    public init(draftOrderStream: DraftOrderStreaming, draftOrderTotalStream: DraftOrderTotalStreaming, stacker: ViewStacking, cartBuilder: any ViewBuilding) {
        self.draftOrderStream = draftOrderStream
        self.draftOrderTotalStream = draftOrderTotalStream
        self.stacker = stacker
        self.cartBuilder = cartBuilder
    }
    
    public var id: String { "openCartButton" }
    
    public func build() -> some View {
        let viewModel = OpenCartButtonViewModel()
        let interactor = OpenCartButtonInteractor(draftOrderStream: draftOrderStream,
                                                  draftOrderTotalStream: draftOrderTotalStream,
                                                  stacker: stacker,
                                                  cartBuilder: cartBuilder,
                                                  presenter: viewModel)
        return OpenCartButton(
            interactor: interactor,
            viewModel: viewModel
        )
    }
}
