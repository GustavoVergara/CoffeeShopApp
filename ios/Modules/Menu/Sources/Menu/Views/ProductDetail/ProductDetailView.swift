import SwiftUI
import Core

struct ProductDetailView<AddToDraftOrderButtonBuild: AddToDraftOrderButtonBuilding>: View {
    let interactor: ProductDetailInteracting
    @ObservedObject var viewModel: ProductDetailViewModel
    let addToDraftOrderButtonBuilder: AddToDraftOrderButtonBuild
    
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom) {
            addToDraftOrderButtonBuilder.build()
                .shadow(radius: 4)
                .fixedSize()
        }
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
    
    func customizationOption(_ option: ProductCustomization, sectionID: String) -> some View {
        Button {
            interactor.selectCustomization(option.id, inSection: sectionID)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(option.name)
                    if option.additionalPrice > 0 {
                        Text(option.displayAdditionalPrice())
                            .fontWeight(.semibold)
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
        NavigationStack {
            ProductDetailBuilder.shared.buildPreview()
        }.previewDisplayName("Mocked")
    }
}