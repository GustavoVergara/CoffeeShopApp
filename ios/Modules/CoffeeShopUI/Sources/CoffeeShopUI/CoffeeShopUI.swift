import SwiftUI

public struct ContentView: View {
    @State var searchQuery = ""
    @State var selectedMenuItem: MenuItem?
    @State var navPath = NavigationPath()
    
    public init() {}

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
    var image: ImageKind
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

enum ImageKind: View, Hashable {
    case image(Image)
    case url(URL)
    case system(String)
    
    var body: some View {
        switch self {
        case .image(let image):
            image
                .resizable()
        case .url(let url):
            AsyncImage(url: url)
        case .system(let systemName):
            Image(systemName: systemName)
                .resizable()
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .image(let image):
            hasher.combine(String(describing: image))
        case .url(let url):
            hasher.combine(url)
        case .system(let systemName):
            hasher.combine(systemName)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
