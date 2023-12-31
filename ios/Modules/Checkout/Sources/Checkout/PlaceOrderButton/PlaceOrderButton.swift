import SwiftUI
import Core
import OrderLibrary
import Navigation

struct PlaceOrderButton: View {
    let interactor: PlaceOrderInteractor
    @ObservedObject var viewModel: PlaceOrderButtonViewModel
    
    var body: some View {
        Button {
            interactor.didPressPlaceOrder()
        } label: {
            HStack {
                Text("Pedir")
                    .font(.system(size: 24, weight: .semibold))
                Spacer().frame(maxWidth: 100)
                Text(viewModel.totalPrice)
            }.padding(4)
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(24)
        .padding()
        .tint(R.color.darkGreen())
        .alert("Qual o seu nome?", isPresented: $viewModel.isConfirmationPresented) {
            TextField("Digite seu nome", text: $viewModel.userName)
            AsyncButton {
                await interactor.didConfirmOrder(name: viewModel.userName)
            } label: {
                Text("Fazer o pedido")
            }
            Button(role: .cancel) {
                print("wow")
            } label: {
                Text("Rever pedido")
            }
        } message: {
            Text(viewModel.confirmationMessage)
        }
    }
}

struct PlaceOrderButton_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBuilder { stacker in
            PreviewPlaceOrderButtonBuilder(stacker: stacker)
        }.build()
    }
}
