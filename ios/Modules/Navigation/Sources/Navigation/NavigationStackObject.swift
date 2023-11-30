import SwiftUI

public protocol ViewStacking {
    func push(_ viewBuilder: any ViewBuilding)
}

class NavigationStackObject: ObservableObject, ViewStacking {
    @Published
    var path: [NavigationItem] = [] {
        didSet {
            print("Navigation stack was updated to `\(path.map(\.id))`")
        }
    }
    
    func build(for path: NavigationItem) -> some View {
        AnyView(path.builder.build())
    }
    
    func push(_ viewBuilder: any ViewBuilding) {
        path.append(NavigationItem(id: viewBuilder.id, builder: viewBuilder))
    }
}

struct NavigationItem: Hashable {
    var id: String
    var builder: any ViewBuilding
    
    init(id: String, builder: any ViewBuilding) {
        self.id = id
        self.builder = builder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
