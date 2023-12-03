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
    
    func cartBuilder(stacker: ViewStacking) -> some ViewBuilding {
        CartBuilder(
            draftOrderStore: Dependencies.shared.draftOrderStore,
            draftOrderTotalStream: Dependencies.shared.draftOrderTotalStream,
            mutableUserSessionStream: Dependencies.shared.userSessionStream,
            draftOrderStream: Dependencies.shared.draftOrderStream,
            stacker: stacker
        )
    }
}

@main
struct CoffeeShopApp: App {
    var body: some Scene {
        Dependencies.shared.userSessionWorker.start()
        return WindowGroup {
            NavigationBuilder { stack in
                TabBuider(
                    firstBuilder: MenuBuilder(
                        navigationStack: stack,
                        cartBuilder: Dependencies.shared.cartBuilder(stacker: stack),
                        openCartButtonBuilder: OpenCartButtonBuilder(
                            draftOrderStream: Dependencies.shared.draftOrderStream,
                            draftOrderTotalStream: Dependencies.shared.draftOrderTotalStream,
                            stacker: stack,
                            cartBuilder: Dependencies.shared.cartBuilder(stacker: stack)
                        ),
                        draftOrderStore: Dependencies.shared.draftOrderStore,
                        draftOrderStream: Dependencies.shared.draftOrderStream
                    ),
                    secondBuilder: OrderListBuilder(orderHistoryStore: OrderHistoryStore())
                )
            }.build()
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
    
    static var previews: some View {
        NavigationBuilder { stack in
            MenuBuilder(
                navigationStack: stack,
                cartBuilder: CartBuilder(
                    draftOrderStore: draftOrderStore,
                    draftOrderTotalStream: draftOrderStore.totalStream,
                    mutableUserSessionStream: userSessionStream,
                    draftOrderStream: draftOrderStore.stream,
                    stacker: stack
                ),
                openCartButtonBuilder: OpenCartButtonBuilder(
                    draftOrderStream: draftOrderStore.stream,
                    draftOrderTotalStream: draftOrderStore.totalStream,
                    stacker: stack,
                    cartBuilder: CartBuilder(
                        draftOrderStore: draftOrderStore,
                        draftOrderTotalStream: draftOrderStore.totalStream,
                        mutableUserSessionStream: userSessionStream,
                        draftOrderStream: draftOrderStore.stream,
                        stacker: stack
                    )
                ),
                draftOrderStore: draftOrderStore,
                draftOrderStream: draftOrderStore.stream
            )
        }.build()
    }
}
