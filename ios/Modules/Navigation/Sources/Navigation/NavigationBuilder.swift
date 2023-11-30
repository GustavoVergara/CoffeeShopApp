import SwiftUI

public struct NavigationBuilder<Root: ViewBuilding>: ViewBuilding {
    private let stackObject = NavigationStackObject()

    public var id: String { "root" }
    private let view: NavigationView<Root>

    public init(root: @escaping (ViewStacking) -> Root) {
        view = NavigationView(navStack: stackObject, root: root)
    }
    
    public func build() -> some View {
        view
    }
}
