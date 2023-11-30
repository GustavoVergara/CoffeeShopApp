import SwiftUI
import Core
import OrderLibrary

struct CartView: View {
    let interactor: CartInteracting
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        List(viewModel.items) { item in
            CartItemView(
                data: item,
                increaseQuantity: {
                    interactor.increaseQuantity(productID: item.productID, skuID: item.skuID)
                },
                decreaseQuantity: {
                    interactor.decreaseQuantity(productID: item.productID, skuID: item.skuID)
                }
            )
                .buttonStyle(PlainButtonStyle())
        }
        .navigationTitle("Carrinho")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Image(systemName: "\(viewModel.items.count).circle")
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                print("Tapped place order button")
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
        }
        .tabItem {
            Label("Carrinho", systemImage: "cart.fill")
        }
    }
}

struct CartItemView: View {
    let data: CartItemData
    let increaseQuantity: () -> ()
    let decreaseQuantity: () -> ()
    
    var body: some View {
        HStack {
            data.image
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 64)
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.system(size: 18, weight: .bold))
                Text(data.price)
                    .bold()
                    .foregroundColor(Color(uiColor: .systemGray))
            }
            Spacer()
            HStack(spacing: 0) {
                Button {
                    increaseQuantity()
                } label: {
                    Image(systemName: "plus.circle")
                }
                Text("\(data.quantity)")
                    .frame(minWidth: 20)
                Button {
                    decreaseQuantity()
                } label: {
                    Image(systemName: "minus.circle")
                }
            }
            .foregroundColor(R.color.darkGreen())
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabView {
                CartBuilder().build()
            }
        }.previewDisplayName("Live")

        NavigationStack {
            TabView {
                PreviewCartBuilder(products: [
                    DraftOrderProduct(id: "prod-id-capp", name: "Capp", imageURL: nil,
                                      sku: DraftOrderSKU(id: "sku-id", price: 10, attributes: [:]),
                                      quantity: 1),
                    DraftOrderProduct(id: "prod-id-expr", name: "Espresso", imageURL: nil,
                                      sku: DraftOrderSKU(id: "sku-id", price: 5, attributes: [:]),
                                      quantity: 1),
                ]).build()
            }
        }.previewDisplayName("Preview")
    }
}
