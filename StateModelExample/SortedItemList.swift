import SwiftUI
import StateModel


struct SortedItemList: View {

    @Query
    var items: [Item]

    @Binding
    var descriptor: QueryDescriptor<Item>

    init(descriptor: Binding<QueryDescriptor<Item>>) {
        self._items = Query(descriptor: descriptor.wrappedValue)
        self._descriptor = descriptor
    }

    var body: some View {
        List {
            ForEach(items) { (item: Item) in
                ItemRow(item: item)
            }
            .onMove(perform: move)
        }
    }

    /**
     Moves items to a new position.

     This function works by updating the `sortIndex` property on `Item`,
     so that the elements receive the correct order.

     - Note: Only the sort indices of the moved elements are updated, to fit them into the remaining elements.
     If items are moved often in particular patterns, there could be issues related to `Double` precision.
     */
    private func move(indices: IndexSet, to index: Int) {
        guard !indices.isEmpty else { return }

        // Case 1: Movement to last position
        guard index < items.count else {
            // Move all elements to the end
            // Take the sortIndex of the last element
            // and add 1 for each item to add after it
            // Keep the elements to move in the order they appear in
            var endValue = (items.last?.sortIndex ?? 0) + 1
            for indexToMove in indices.sorted() {
                items[indexToMove].sortIndex = endValue
                endValue += 1
            }
            return
        }

        let valueAtIndex = items[index].sortIndex
        let indexBefore = index - 1
        // Case 2: Move to the front
        guard indexBefore >= 0 else {
            // Move all elements to the start
            // Take the sortIndex of the first element,
            // and subtract 1 for each item to add before
            // Keep the elements to move in the order they appear in
            var startValue = (items.first?.sortIndex ?? Double(indices.count)) - 1
            for indexToMove in indices.sorted().reversed() {
                items[indexToMove].sortIndex = startValue
                startValue -= 1
            }
            return
        }

        // Case 3: Inserting between two items
        // We take the sort indices of the two items,
        // and update the items to move so that their sort indices
        // are equally spaced between the two values
        let valueBeforeIndex = items[indexBefore].sortIndex
        // Create the sort indices equally spaced between the two existing values
        let step = (valueAtIndex - valueBeforeIndex) / Double(indices.count + 1)
        var value = valueBeforeIndex + step
        for indexToMove in indices.sorted() {
            items[indexToMove].sortIndex = value
            value += step
        }
    }
}
