import SwiftUI

struct ProductDetailBuilder {
    public static let shared = Self.init()
    
    func build() -> some View {
        let viewModel = ProductDetailViewModel.preview
//        let interactor = MenuInteractor(presenter: viewModel)
        return ProductDetailView(interactor: viewModel, viewModel: viewModel)
    }
    
    func buildPreview() -> some View {
        let viewModel = ProductDetailViewModel.preview
//        let interactor = PreviewMenuInteractor(presenter: viewModel)
        return ProductDetailView(interactor: viewModel, viewModel: viewModel)
    }
}
