import Combine

public class UserSessionWorker {
    private let mutableUserSessionStream: MutableUserSessionStreaming
    private let sessionStore: SessionStoring
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mutableUserSessionStream: MutableUserSessionStreaming, sessionStore: SessionStoring) {
        self.mutableUserSessionStream = mutableUserSessionStream
        self.sessionStore = sessionStore
    }
    
    public convenience init(mutableUserSessionStream: MutableUserSessionStreaming) {
        self.init(mutableUserSessionStream: mutableUserSessionStream, sessionStore: SessionStore())
    }
    
    public func start() {
        mutableUserSessionStream.emit(sessionStore.getCurrent())
        mutableUserSessionStream.publisher().sink { [weak self] session in
            if let session {
                self?.sessionStore.store(session)
            } else {
                self?.sessionStore.eraseCurrent()
            }
        }.store(in: &cancellables)
    }
}
