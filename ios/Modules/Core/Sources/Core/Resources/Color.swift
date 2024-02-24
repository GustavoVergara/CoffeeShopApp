import Resourceful

public extension R {
    enum color {}
}

public extension R.color {
    static let darkGreen = Resourceful.ColorResource(name: "DarkGreen", bundle: .module)
    static let lightGreen = Resourceful.ColorResource(name: "LightGreen", bundle: .module)
}
