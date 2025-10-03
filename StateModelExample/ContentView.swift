import SwiftUI
import SFSafeSymbols
import StateModel

struct ContentView: View {

    /**
     The database of the app.

     It is used here to add new items.
     */
    @EnvironmentObject
    private var database: ObservableDatabase

    /**
     Indicator for item filtering.

     Allows the user to choose if finished items should be shown in the list
    */
    @State
    var showCompletedItemsInList = false

    /**
     Stores the user setting for item sorting.

     If set to `true`, then the items are sorted by name,
     otherwise they are sorted using the `sortIndex`
     */
    @State
    var sortListByName = false

    /**
     The sort and filtering options for the list view.

     This property is updated when the user changes the viewing options
     */
    @State
    private var descriptor: QueryDescriptor<Item> =
        .init(filter: { !$0.isCompleted },
              sortBy: { $0.sortIndex })

    private var filterButtonImage: SFSymbol {
        showCompletedItemsInList ? .line3HorizontalDecreaseCircle : .line3HorizontalDecreaseCircleFill
    }

    private var sortButtonImage: SFSymbol {
        sortListByName ? .textBadgeCheckmark : .textBadgeXmark
    }

    private var filterFunction: ((Item) -> Bool)? {
        if showCompletedItemsInList {
            return nil
        }
        return { !$0.isCompleted }
    }

    private var sortFunction: ((Item, Item) -> Bool) {
        if sortListByName {
            return { $0.text < $1.text }
        }
        return { $0.sortIndex < $1.sortIndex }
    }

    var body: some View {
        NavigationStack {
            SortedItemList(descriptor: $descriptor)
            .toolbar {
                ToolbarItem {
                    Button("Add", action: addItem)
                }
                ToolbarItem {
                    Button(action: toggleCompletedItems) {
                        Image(systemSymbol: filterButtonImage)
                    }
                }
                ToolbarItem {
                    Button(action: toggleSortingByName) {
                        Image(systemSymbol: sortButtonImage)
                    }
                }
            }
            .navigationTitle("TODO List")
        }
    }

    private func addItem() {
        let newId = Int.random(in: 0...Int.max)
        let newItem = database.create(id: newId, of: Item.self)
        // The items are sorted by their sortIndex,
        // which is initially set to a timestamp
        // This allows new elements to appear at the bottom of the list
        // For later sorting, the sortIndex is recomputed,
        // see SortedItemList for the update process
        newItem.sortIndex = Date().timeIntervalSinceReferenceDate
    }

    private func toggleCompletedItems() {
        showCompletedItemsInList.toggle()
        updateQueryDescriptor()
    }

    private func toggleSortingByName() {
        sortListByName.toggle()
        updateQueryDescriptor()
    }

    private func updateQueryDescriptor() {
        self.descriptor = .init(
            filter: filterFunction,
            sort: sortFunction)
    }
}

#Preview {
    let database = ObservableDatabase(wrapping: InMemoryDatabase())
    ContentView()
        .environmentObject(database)
}

extension Int {

    static func random() -> Int {
        .random(in: Int.min...Int.max)
    }
}
