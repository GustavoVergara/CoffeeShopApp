import Foundation
import Combine
import OrderLibrary
import HTTP
import Navigation

protocol MenuInteracting {
    func didAppear() async
    func didSelectItem(id: String)
}

class MenuInteractor: MenuInteracting {
    let navigationStack: ViewStacking
    let menuNetworker: MenuNetworking
    let cartBuilder: any ViewBuilding
    let draftOrderStore: DraftOrderStoring
    let draftOrderStream: DraftOrderStreaming
    let presenter: MenuPresenting
    
    private var menuResponse: MenuResponse?
    private var cancellables = Set<AnyCancellable>()

    init(
        menuNetworker: MenuNetworking = MenuNetworker(),
        navigationStack: ViewStacking,
        cartBuilder: any ViewBuilding,
        draftOrderStore: DraftOrderStoring,
        draftOrderStream: DraftOrderStreaming,
        presenter: MenuPresenting
    ) {
        self.menuNetworker = menuNetworker
        self.navigationStack = navigationStack
        self.cartBuilder = cartBuilder
        self.draftOrderStore = draftOrderStore
        self.draftOrderStream = draftOrderStream
        self.presenter = presenter
        
        draftOrderStream.publisher().receive(on: DispatchQueue.main).sink { products in
            presenter.presentOpenCartButton(products.count > 0)
        }.store(in: &cancellables)
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
        
        navigationStack.push(ProductDetailBuilder(draftOrderStoring: draftOrderStore, navigationStack: navigationStack, cartBuilder: cartBuilder, product: product))
    }
}
