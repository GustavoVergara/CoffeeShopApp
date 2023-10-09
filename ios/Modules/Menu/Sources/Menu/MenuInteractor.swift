import Foundation
import HTTP

protocol MenuInteracting {
    func didAppear() async
}

class MenuInteractor: MenuInteracting {
    let presenter: MenuPresenting
    let menuNetworker: MenuNetworking

    init(presenter: MenuPresenting, menuNetworker: MenuNetworking = MenuNetworker()) {
        self.presenter = presenter
        self.menuNetworker = menuNetworker
    }
    
    func didAppear() async {
        await presenter.presentLoading()
        do {
            let menuResponse = try await menuNetworker.getMenu()
            await presenter.presentMenu(menuResponse)
        } catch {
            await presenter.presentError(error)
        }
    }
}
