import SwiftUI

struct NavigationView<Root: ViewBuilding>: View {
    @ObservedObject
    var navStack: NavigationStackObject
    
    let rootBuilder: Root
    
    var body: some View {
        NavigationStack(path: $navStack.path) {
            rootBuilder.build()
                .navigationDestination(for: NavigationItem.self) { hashable in
                    navStack.build(for: hashable)
                }
        }
    }
}
