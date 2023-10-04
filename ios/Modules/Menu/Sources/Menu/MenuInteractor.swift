import Foundation
import HTTP

public struct MenuInteractor {
    public private(set) var text = "Hello, World!"
    
    let menuNetworker = MenuNetworker(
        httpClient: HTTPClient(),
        jsonDecoder: JSONDecoder()
    )

    public init() {
    }
    
    public func didAppear() {
        Task {
            let menuResponse = try? await menuNetworker.getMenu()
            if let menu = menuResponse {
                print("Got menu for store with id: '\(menu.storeID)'")
            }
        }
    }
}
