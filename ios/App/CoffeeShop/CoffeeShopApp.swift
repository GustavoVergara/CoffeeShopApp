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

@main
struct CoffeeShopApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationBuilder { stack in
                TabBuider(menuBuilder: MenuBuilder(navigationStack: stack, cartBuilder: CartBuilder()),
                          cartBuilder: CartBuilder())
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
    static var previews: some View {
        NavigationBuilder { stack in
            TabBuider(
                menuBuilder: MenuBuilder(navigationStack: stack, cartBuilder: CartBuilder()),
                cartBuilder: CartBuilder()
            )
        }.build()
    }
}
