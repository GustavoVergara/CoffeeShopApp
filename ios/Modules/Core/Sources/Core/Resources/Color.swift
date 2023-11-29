import Resourceful

public extension R {
    enum color {}
}

public extension R.color {
    static let darkGreen = ColorResource(name: "DarkGreen", bundle: .module)
    static let lightGreen = ColorResource(name: "LightGreen", bundle: .module)
}
