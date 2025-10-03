import StateModel
import Combine
import SwiftUI

@ObservableModel(id: 1)
final class Item {

    @Property(id: 1)
    var text: String

    @Property(id: 2, default: false)
    var isCompleted: Bool

    @Property(id: 3)
    var sortIndex: Double
}
