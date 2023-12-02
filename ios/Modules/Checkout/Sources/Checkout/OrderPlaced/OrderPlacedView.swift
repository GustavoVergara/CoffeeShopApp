import SwiftUI
import Core

struct OrderPlacedView: View {
    let interactor: OrderPlacedInteracting
    @ObservedObject var viewModel: OrderPlacedViewModel
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.palette)
                .foregroundStyle(R.color.darkGreen(), .white)
                .padding(.horizontal, 80)
                .padding(.vertical, 20)
                .scaleEffect(self.isAnimating ? 0.95: 1)
                .animation(.linear(duration: 1).repeatForever(), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
            Text("Pedido feito com sucesso!")
                .font(.title)
                .foregroundColor(.white)
            HStack {
                Text("Previsão de entrega de:")
                Text(viewModel.timeToDeliver)
                    .bold()
            }.font(.title2)
                .foregroundColor(.white)
            Spacer()
            Button {
                interactor.didPressBackButton()
            } label: {
                HStack {
                    Spacer()
                    Text("Voltar para o inicio")
                        .foregroundColor(R.color.darkGreen())
                    Spacer()
                }
            }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .padding(20)
        }
        .background {
            R.color.darkGreen()
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
    }
}

import Navigation

struct OrderPlacedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBuilder { stacker in
            OrderPlacedBuilder(
                stacker: stacker,
                response: PlaceOrderResponse(orderID: "", date: Date(), expectedDeliveryDate: Date().addingTimeInterval(60))
            )
        }.build()
    }
}
