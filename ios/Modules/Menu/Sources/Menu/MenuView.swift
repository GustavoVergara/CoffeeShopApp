import SwiftUI
import Core

struct MenuView: View {
    let interactor: MenuInteracting
    @StateObject var viewModel: MenuViewModel
    
    @State var searchQuery = ""
    @State var navPath = NavigationPath()
    
    init(interactor: MenuInteracting, viewModel: MenuViewModel) {
        self.interactor = interactor
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $navPath) {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let viewData):
                MenuProductListView(items: filterItems(viewData.items))
                    .searchable(text: $searchQuery)
                    .navigationTitle(viewData.storeName)
            case .failed:
                ScrollView {
                    Color.red
                }
            }
        }
        .refreshable {
            await interactor.didAppear()
        }
        .task {
            await interactor.didAppear()
        }
    }
    
    private var title: String {
        switch viewModel.state {
        case .loading:
            return "Carregando..."
        case .failed:
            return "Erro"
        case .loaded(let menu):
            return menu.storeName
        }
    }
    
    private func filterItems(_ items: [MenuItemViewData]) -> [MenuItemViewData] {
        guard searchQuery.isEmpty == false else {
            return items
        }
        let query = searchQuery.lowercased()
        return items.filter { $0.name.lowercased().contains(query) || $0.description.lowercased().contains(query) }
    }
}

struct MenuProductListView: View {
    var items: [MenuItemViewData]
    
    var body: some View {
        List(items) { menuItem in
            MenuItemView(
                image: menuItem.imageURL.map { CoreImage.url($0) } ?? .system("cup.and.saucer.fill"),
                title: menuItem.name,
                description: menuItem.description
            )
        }
//        .refreshable {
//            await interactor.didAppear()
//        }
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

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuBuilder.build()
            .previewDisplayName("Live")
        MenuBuilder().buildPreview()
            .previewDisplayName("Mocked")
    }
}
