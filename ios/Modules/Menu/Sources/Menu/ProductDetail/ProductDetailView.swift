import SwiftUI
import Core

struct ProductDetailView: View {
    var interactor: ProductDetailInteracting
    @StateObject var viewModel: ProductDetailViewModel
    
    var body: some View {
            List {
                header
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                ForEach(viewModel.customizationSections) { section in
                    Section(section.title) {
                        ForEach(section.options) { option in
                            customizationOption(option, sectionID: section.id)
                        }
                    }
                }
            }.headerProminence(.increased)
            .listStyle(.plain)
            .ignoresSafeArea(.container, edges: .top)
    }
    
    var header: some View {
        Group {
            R.image.cappuccino()
                .resizable()
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.name)
                    .font(.system(size: 24, weight: .semibold))
                Text(viewModel.description)
                HStack {
                    Spacer()
                    Text(viewModel.price)
                        .fontWeight(.semibold)
                }
            }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
    
    func customizationOption(_ option: ProductDetailViewModel.Customization, sectionID: String) -> some View {
        Button {
            interactor.selectCustomization(option.id, inSection: sectionID)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(option.name)
                    if !option.price.isEmpty {
                        Text(option.price)
                    }
                }
                Spacer()
                checkmark(isOn: option.isSelected)
            }

        }
    }
    
    func checkmark(isOn: Bool) -> some View {
        let image: Image
        if isOn {
            image = Image(systemName: "checkmark.circle.fill")
        } else {
            image = Image(systemName: "circle")
        }
        return image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 32)
    }
    
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailBuilder.shared.build()
            .previewDisplayName("Live")
        ProductDetailBuilder.shared.buildPreview()
            .previewDisplayName("Mocked")
    }
}
