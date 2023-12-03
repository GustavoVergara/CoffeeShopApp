import SwiftUI

public struct PreviewViewBuilder<Content: View>: ViewBuilding {
    public var id: String { "previewBuilder" }
    var view: Content
    
    public init(view: Content) {
        self.view = view
    }
    
    public func build() -> Content {
        view
    }
}
