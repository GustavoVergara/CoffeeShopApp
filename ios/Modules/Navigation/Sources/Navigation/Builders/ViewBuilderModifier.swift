import Foundation
import SwiftUI

struct ViewBuilderModifier<ContentBuilder: ViewBuilding, Content: View>: ViewBuilding {
    private let uuid = UUID()

    let builder: ContentBuilder
    let modify: (ContentBuilder.Content) -> Content
    
    var id: String { "modified/\(builder.id)/\(uuid.uuidString)" }
    
    func build() -> some View {
        modify(builder.build())
    }
}

public extension ViewBuilding {
    func modify<ResultContent: View>(_ handler: @escaping (Content) -> ResultContent) -> some ViewBuilding {
        ViewBuilderModifier(builder: self, modify: handler)
    }
}
