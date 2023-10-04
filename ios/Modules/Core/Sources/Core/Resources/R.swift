public struct R {}

import Resourceful

extension R {
    public enum image {}
}

public extension R.image {
    static var cappuccino = ImageResource(name: "Cappuccino", bundle: .module)
}
