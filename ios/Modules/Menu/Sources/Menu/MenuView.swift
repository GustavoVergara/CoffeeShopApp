import SwiftUI
import Core

public struct MenuView: View {
    @State var searchQuery = ""
    @State var selectedMenuItem: MenuItem?
    @State var navPath = NavigationPath()
    
    public init() {
        
    }

    public var body: some View {
        NavigationStack(path: $navPath) {
            List(MenuItem.mockedItems) { menuItem in
                MenuItemView(
                    image: menuItem.image,
                    title: menuItem.title,
                    description: menuItem.description
                ).onTapGesture {
                    if let selectedMenuItem, selectedMenuItem == menuItem {
                        self.selectedMenuItem = nil
                    } else {
                        selectedMenuItem = menuItem
                    }
                }
            }
            .searchable(text: $searchQuery)
        }
    }
}

struct MenuItemView: View {
    var image: CoreImage
    var title: String
    var description: String

    var body: some View {
        HStack {
            image
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 64)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                Text(description)
            }
        }
    }

}

struct MenuItem: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var image: ImageKind
    var title: String
    var description: String
    
    static var mockedItems: [MenuItem] = [
        MenuItem(
            image: .system("cup.and.saucer.fill"),
            title: "Flat white",
            description: "Dose dupla de expresso com leite vaporizado"
        ),
        MenuItem(
            image: .system("cup.and.saucer"),
            title: "Cappuchino",
            description: "Dose dupla de expresso com leite vaporizado"
        ),
    ]
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
