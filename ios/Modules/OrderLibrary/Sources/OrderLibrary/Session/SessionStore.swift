public protocol SessionStoring {
    func store(_ session: UserSession)
    func eraseCurrent()
    func getCurrent() -> UserSession?
}

class SessionStore: SessionStoring {
    let store: CodableStoring

    let storageKey = "user-session"
    
    init(store: CodableStoring) {
        self.store = store
    }
    
    public convenience init() {
        self.init(store: DiskStorage())
    }
    
    private func key(id: String) -> String {
        "\(storageKey)/\(id)"
    }
    
    public func store(_ session: UserSession) {
        store.store(session, forKey: key(id: "current"))
    }
    
    public func eraseCurrent() {
        store.removeObject(forKey: key(id: "current"))
    }
    
    public func getCurrent() -> UserSession? {
        store.object(UserSession.self, forKey: key(id: "current"))
    }
}

public struct UserSession: Codable {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
