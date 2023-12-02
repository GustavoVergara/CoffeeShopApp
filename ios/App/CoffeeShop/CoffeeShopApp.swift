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
    
    let draftOrderStream = DraftOrderStream()
    lazy var draftOrderTotalStream = DraftOrderTotalStream(draftOrderStream: draftOrderStream)
    lazy var draftOrderStore = DraftOrderStore(stream: draftOrderStream)
    
    let userSessionStream = UserSessionStream()
    
    var cartBuilder: some ViewBuilding {
        CartBuilder(
            draftOrderStore: Dependencies.shared.draftOrderStore,
            draftOrderTotalStream: Dependencies.shared.draftOrderTotalStream,
            mutableUserSessionStream: Dependencies.shared.userSessionStream,
            draftOrderStream: Dependencies.shared.draftOrderStream
        )
    }
}

@main
struct CoffeeShopApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationBuilder { stack in
                TabBuider(
                    menuBuilder: MenuBuilder(
                        navigationStack: stack,
                        cartBuilder: Dependencies.shared.cartBuilder,
                        draftOrderStore: Dependencies.shared.draftOrderStore
                    ),
                    cartBuilder: Dependencies.shared.cartBuilder
                )
            }.build()
        }
    }
}

struct TabBuider<MenuB: ViewBuilding, CartB: ViewBuilding>: ViewBuilding {
    var id: String { "root/tabs" }
    let menuBuilder: MenuB
    let cartBuilder: CartB
    
    func build() -> some View {
        TabView {
            menuBuilder.build()
            cartBuilder.build()
        }
        .tint(R.color.darkGreen())
    }
}

struct CoffeeShopApp_Previews: PreviewProvider {
    static let draftOrderStore = PreviewDraftOrderStore()
    static let userSessionStream = PreviewUserSessionStream()
    
    static var previews: some View {
        NavigationBuilder { stack in
            TabBuider(
                menuBuilder: MenuBuilder(
                    navigationStack: stack,
                    cartBuilder: CartBuilder(
                        draftOrderStore: draftOrderStore,
                        draftOrderTotalStream: draftOrderStore.totalStream,
                        mutableUserSessionStream: userSessionStream,
                        draftOrderStream: draftOrderStore.stream
                    ),
                    draftOrderStore: Dependencies.shared.draftOrderStore
                ),
                cartBuilder: CartBuilder(
                    draftOrderStore: draftOrderStore,
                    draftOrderTotalStream: draftOrderStore.totalStream,
                    mutableUserSessionStream: userSessionStream,
                    draftOrderStream: draftOrderStore.stream
                )
            )
        }.build()
    }
}
