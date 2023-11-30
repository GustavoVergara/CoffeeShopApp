import SwiftUI

public protocol ViewBuilding {
    associatedtype Content: View

    var id: String { get }
    func build() -> Content
}
