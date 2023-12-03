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

@main
struct CoffeeShopApp: App {
    let dependencies = RootDependencyProvider()
    
    var body: some Scene {
        dependencies.userSessionWorker.start()
        dependencies.orderHistoryWorker.start()
        return WindowGroup {
            RootBuilder(dependencies: dependencies).build()
        }
    }
}

struct CoffeeShopApp_Previews: PreviewProvider {
    static var previews: some View {
        RootBuilder(dependencies: PreviewRootDependencyProvider()).build()
    }
}
