//
//  CoffeeShopApp.swift
//  CoffeeShop
//
//  Created by Gustavo Vergara on 29/09/23.
//

import SwiftUI
import Core
import Navigation
import Menu
import Checkout
import OrderLibrary

class Dependencies {
    static let shared = Dependencies()
    
    private init() {}
    
    let draftOrderStream = DraftOrderStream()
    lazy var draftOrderTotalStream = DraftOrderTotalStream(draftOrderStream: draftOrderStream)
    lazy var draftOrderStore = DraftOrderStore(stream: draftOrderStream)
    
    let userSessionStream = UserSessionStream()
    lazy var userSessionWorker = UserSessionWorker(mutableUserSessionStream: userSessionStream)
    
    let orderHistoryStream = OrderHistoryStream()
    lazy var orderHistoryWorker = OrderHistoryWorker(mutableOrderHistoryStream: orderHistoryStream)
    
    func cartBuilder(stacker: ViewStacking) -> some ViewBuilding {
        CartBuilder(
            draftOrderStore: draftOrderStore,
            draftOrderTotalStream: draftOrderTotalStream,
            mutableUserSessionStream: userSessionStream,
            draftOrderStream: draftOrderStream,
            mutableOrderHistoryStream: orderHistoryStream,
            stacker: stacker
        )
    }
}

@main
struct CoffeeShopApp: App {
    let dependencies = Dependencies.shared
    
    var body: some Scene {
        dependencies.userSessionWorker.start()
        dependencies.orderHistoryWorker.start()
        return WindowGroup {
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
                }
            ).build()
        }
    }
}

struct TabBuider<FBuilder: ViewBuilding, SBuilder: ViewBuilding>: ViewBuilding {
    var id: String { "root/tabs" }
    let firstBuilder: FBuilder
    let secondBuilder: SBuilder
    
    func build() -> some View {
        TabView {
            firstBuilder.build()
            secondBuilder.build()
        }
        .tint(R.color.darkGreen())
    }
}

struct CoffeeShopApp_Previews: PreviewProvider {
    static let draftOrderStore = PreviewDraftOrderStore()
    static let userSessionStream = PreviewUserSessionStream()
    static let orderHistoryStream = PreviewOrderHistoryStream()
    
    static func cartBuilder(stack: ViewStacking) -> some ViewBuilding {
        CartBuilder(
            draftOrderStore: draftOrderStore,
            draftOrderTotalStream: draftOrderStore.totalStream,
            mutableUserSessionStream: userSessionStream,
            draftOrderStream: draftOrderStore.stream,
            mutableOrderHistoryStream: orderHistoryStream,
            stacker: stack
        )
    }
    
    static var previews: some View {
        TabBuider(
            firstBuilder: NavigationBuilder { stack in
                MenuBuilder(
                    navigationStack: stack,
                    cartBuilder: cartBuilder(stack: stack),
                    openCartButtonBuilder: OpenCartButtonBuilder(
                        draftOrderStream: draftOrderStore.stream,
                        draftOrderTotalStream: draftOrderStore.totalStream,
                        stacker: stack,
                        cartBuilder: cartBuilder(stack: stack)
                    ),
                    draftOrderStore: draftOrderStore,
                    draftOrderStream: draftOrderStore.stream
                )
            }.modify {
                $0
                    .tabItem {
                        Label("Menu", systemImage: "menucard.fill")
                    }
                    .tint(.white)
            },
            secondBuilder: NavigationBuilder { stack in
                OrderListBuilder(orderHistoryStream: orderHistoryStream)
            }.modify {
                $0.tabItem {
                    Label("Pedidos", systemImage: "list.bullet")
                }
            }
        ).build()
    }
}
