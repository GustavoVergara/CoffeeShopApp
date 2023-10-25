import SwiftUI
import Core

struct AddToDraftOrderButton: View {
    @State var counter: Int = 1
    @State var price: String = "R$ 12,50"
    
    var body: some View {
        HStack {
            Spacer().frame(maxWidth: 8)
            counterView
            Color.white.frame(maxWidth: 1)
            Button("Adicionar \(price)") {
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
                counter += 1
            } label: {
                Image(systemName: "plus.circle")
                    .padding(.vertical)
            }
            Text("\(counter)")
                .frame(minWidth: 20)
//                .font(.system(size: 20, weight: .bold))
            Button {
                counter -= 1
            } label: {
                Image(systemName: "minus.circle")
                    .padding(.vertical)
            }
        }
    }
}

struct AddToDraftOrderButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToDraftOrderButton()
            .fixedSize()
            .previewLayout(.sizeThatFits)
    }
}
