import SwiftUI
import Navigation
import Core
import Checkout
import Menu

struct RootBuilder<DependencyProviding: RootDependencyProviding>: ViewBuilding {
    let dependencies: DependencyProviding
    
    var id: String { "root" }
    
    func build() -> some View {
        TabBuider(
            firstBuilder: NavigationBuilder { stack in
                MenuBuilder(
                    navigationStack: stack,
                    cartBuilder: dependencies.cartBuilder(stacker: stack),
                    openCartButtonBuilder: OpenCartButtonBuilder(
                        draftOrderStream: dependencies.draftOrderStream,
                        draftOrderTotalStream: dependencies.draftOrderTotalStream,
                        stacker: stack,
                        cartBuilder: dependencies.cartBuilder(stacker: stack)
                    ),
                    draftOrderStore: dependencies.draftOrderStore,
                    draftOrderStream: dependencies.draftOrderStream
                )
            }.modify {
                $0
                    .tabItem {
                        Label("Menu", systemImage: "menucard.fill")
                    }
                    .tint(.white)
            },
            secondBuilder: NavigationBuilder { _ in
                OrderListBuilder(orderHistoryStream: dependencies.orderHistoryStream)
            }.modify {
                $0.tabItem {
                    Label("Pedidos", systemImage: "list.bullet")
                }
            }
        )
        .modify { $0.tint(R.color.darkGreen()) }
        .build()
    }
}

