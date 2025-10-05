import StateModel
import Combine
import SwiftUI

@Model(id: 1)
final class Item {

    @Property(id: 1)
    var text: String

    @Property(id: 2)
    var isCompleted: Bool = false

    @Property(id: 3)
    var sortIndex: Double
}
