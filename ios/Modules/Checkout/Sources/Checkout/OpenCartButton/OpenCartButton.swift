import Foundation
import SwiftUI
import Combine
import Core
import OrderLibrary
import Navigation

struct OpenCartButton: View {
    let interactor: OpenCartButtonInteracting
    @ObservedObject var viewModel: OpenCartButtonViewModel
    
    var body: some View {
        Button {
            interactor.didPressButton()
        } label: {
            ZStack {
                Text("Pedir")
                    .font(.system(size: 18, weight: .semibold))
                HStack {
                    Text(viewModel.totalPrice)
                    Spacer()
                    Image(systemName: "\(viewModel.productCount).circle")
                }
            }.padding(4)
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(24)
        .padding(40)
        .tint(R.color.darkGreen())
    }
}

struct OpenCartButton_Previews: PreviewProvider {
    static let draftOrderStore = PreviewDraftOrderStore(products: [
        DraftOrderProduct(id: "0", name: "Capp", imageURL: nil, sku: DraftOrderSKU(id: "sku_0", price: 10, attributes: [:]), quantity: 2)
    ])
    
    static var previews: some View {
        NavigationBuilder { stack in
            OpenCartButtonBuilder(
                draftOrderStream: draftOrderStore.stream,
                draftOrderTotalStream: draftOrderStore.totalStream,
                stacker: stack,
                cartBuilder: PreviewCartBuilder(products: [])
            )
        }.build()
    }
}
