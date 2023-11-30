import Foundation
import HTTP
import Navigation

protocol MenuInteracting {
    func didAppear() async
    func didSelectItem(id: String)
}

class MenuInteractor: MenuInteracting {
    let navigationStack: ViewStacking
    let menuNetworker: MenuNetworking
    let presenter: MenuPresenting
    private var menuResponse: MenuResponse?

    init(menuNetworker: MenuNetworking = MenuNetworker(), navigationStack: ViewStacking, presenter: MenuPresenting) {
        self.menuNetworker = menuNetworker
        self.navigationStack = navigationStack
        self.presenter = presenter
    }
    
    func didAppear() async {
        await presenter.presentLoading()
        do {
            let response = try await menuNetworker.getMenu()
            menuResponse = response
            await presenter.presentMenu(response)
        } catch {
            await presenter.presentError(error)
        }
    }
    
    func didSelectItem(id: String) {
        guard let product = menuResponse?.products.first(where: { $0.id == id }) else {
            print("ERROR: Attempting to display unknown product.")
            return
        }
        
        navigationStack.push(ProductDetailBuilder(navigationStack: navigationStack, product: product))
    }
}
