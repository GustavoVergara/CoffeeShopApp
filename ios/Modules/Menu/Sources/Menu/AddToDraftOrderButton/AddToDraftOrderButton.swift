import SwiftUI
import Core

struct AddToDraftOrderButton: View {
    let interactor: AddToDraftOrderInteracting
    @ObservedObject var viewModel: AddToDraftOrderButtonViewModel

    var body: some View {
        HStack(spacing: 0) {
            counterView
            Color.white.frame(maxWidth: 1)
            addToDraftOrderView
        }
        .foregroundColor(.white)
        .cornerRadius(24)
        .frame(idealHeight: 48)
    }
    
    private var counterView: some View {
        ZStack {
            R.color.darkGreen()
            HStack(spacing: 0) {
                Button {
                    interactor.increaseQuantity()
                } label: {
                    Image(systemName: "plus.circle")
                }
                Text("\(viewModel.selectedQuantity)")
                    .frame(minWidth: 20)
                Button {
                    interactor.decreaseQuantity()
                } label: {
                    Image(systemName: "minus.circle")
                }
            }
            .padding([.horizontal], 8)
        }
    }
    
    private var addToDraftOrderView: some View {
        ZStack {
            if viewModel.canAddToDraftOrder {
                R.color.darkGreen()
            } else {
                R.color.lightGreen()
            }
            Button("Adicionar \(viewModel.currentDisplayPrice)") {
                interactor.addToDraftOrder()
            }
            .lineLimit(1)
            .fixedSize()
            .disabled(!viewModel.canAddToDraftOrder)
            .padding([.horizontal], 8)
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
