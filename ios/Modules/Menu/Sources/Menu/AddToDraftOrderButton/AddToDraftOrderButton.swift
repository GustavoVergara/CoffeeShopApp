import SwiftUI
import Core

struct AddToDraftOrderButton: View {
    let interactor: AddToDraftOrderInteracting
    @ObservedObject var viewModel: AddToDraftOrderButtonViewModel

    var body: some View {
        HStack {
            Spacer().frame(maxWidth: 8)
            counterView
            Color.white.frame(maxWidth: 1)
            Button("Adicionar \(viewModel.currentDisplayPrice)") {
                print("Add product to DraftOrder")
            }
            .lineLimit(1)
            .fixedSize()
            Spacer().frame(maxWidth: 8)
        }
        .background {
            R.color.darkGreen()
        }
        .foregroundColor(.white)
        .cornerRadius(24)
        .frame(idealHeight: 48)
    }
    
    private var counterView: some View {
        HStack(spacing: 0) {
            Button {
                interactor.increaseQuantity()
            } label: {
                Image(systemName: "plus.circle")
                    .padding(.vertical)
            }
            Text("\(viewModel.selectedQuantity)")
                .frame(minWidth: 20)
//                .font(.system(size: 20, weight: .bold))
            Button {
                interactor.decreaseQuantity()
            } label: {
                Image(systemName: "minus.circle")
                    .padding(.vertical)
            }
        }
    }
}

struct AddToDraftOrderButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToDraftOrderButtonBuilderPreview().build()
            .fixedSize()
            .previewLayout(.sizeThatFits)
    }
}
