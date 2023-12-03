import SwiftUI

public struct TabBuider<FBuilder: ViewBuilding, SBuilder: ViewBuilding>: ViewBuilding {
    let firstBuilder: FBuilder
    let secondBuilder: SBuilder
    
    public init(firstBuilder: FBuilder, secondBuilder: SBuilder) {
        self.firstBuilder = firstBuilder
        self.secondBuilder = secondBuilder
    }
    
    public var id: String { "root/tabs" }
    
    public func build() -> some View {
        TabView {
            firstBuilder.build()
            secondBuilder.build()
        }
    }
}
