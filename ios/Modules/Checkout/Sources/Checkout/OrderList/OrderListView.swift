import SwiftUI
import Core

struct OrderListView: View {
    let interactor: OrderListInteracting
    @ObservedObject var viewModel: OrderListViewModel
    
    var body: some View {
        List(viewModel.orders) { order in
            HStack {
                VStack(alignment: .leading) {
                    Text(order.storeName)
                    Text("\(order.state) - \(order.date)")
                        .font(.footnote)
                }
                Spacer()
                Text(order.totalPrice)
            }
        }
        .navigationTitle("Meus Pedidos")
        .tabItem {
            Image(systemName: "list.bullet")
            Text("Pedidos")
        }
        .onAppear {
            interactor.didAppear()
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewOrderListBuilder().build()
    }
}
