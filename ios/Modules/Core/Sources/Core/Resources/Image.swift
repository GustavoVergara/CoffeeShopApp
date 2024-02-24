import Resourceful

extension R {
    public enum image {}
}

public extension R.image {
    static var cappuccino = Resourceful.ImageResource(name: "Cappuccino", bundle: .module)
}
