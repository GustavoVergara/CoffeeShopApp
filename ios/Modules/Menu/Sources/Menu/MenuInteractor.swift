import Foundation
import HTTP

protocol MenuInteracting {
    func didAppear() async
    func didSelectItem(id: String)
}

class MenuInteractor: MenuInteracting {
    let presenter: MenuPresenting
    let menuNetworker: MenuNetworking
    private var menuResponse: MenuResponse?

    init(presenter: MenuPresenting, menuNetworker: MenuNetworking = MenuNetworker()) {
        self.presenter = presenter
        self.menuNetworker = menuNetworker
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
        presenter.presentProduct(product)
    }
}
