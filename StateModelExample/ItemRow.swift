import SwiftUI
import SFSafeSymbols

struct ItemRow: View {

    @ObservedObject
    var item: Item

    var body: some View {
        HStack {
            Image(systemSymbol: item.isCompleted ? .circleFill : .circle)
                .onTapGesture { item.isCompleted.toggle() }
            TextField("", text: $item.text, prompt: Text("New item"))
            Spacer()
            Image(systemSymbol: .line3Horizontal)
        }
    }
}
