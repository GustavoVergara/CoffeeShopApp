import SwiftUI

struct NavigationView<Root: ViewBuilding>: View {
    @ObservedObject
    var navStack: NavigationStackObject
    
    let root: (ViewStacking) -> Root
    
    var body: some View {
        NavigationStack(path: $navStack.path) {
            root(navStack).build()
                .navigationDestination(for: NavigationItem.self) { hashable in
                    navStack.build(for: hashable)
                }
        }
    }
}
