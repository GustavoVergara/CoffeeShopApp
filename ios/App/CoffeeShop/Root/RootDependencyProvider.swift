import Navigation
import OrderLibrary
import Core
import Checkout
import Menu

protocol RootDependencyProviding {
    var mutableDraftOrderStream: MutableDraftOrderStreaming { get }
    var draftOrderStream: DraftOrderStreaming { get }
    var draftOrderTotalStream: DraftOrderTotalStreaming { get }
    var draftOrderStore: DraftOrderStoring { get }
    
    var mutableUserSessionStream: MutableUserSessionStreaming { get }
    var userSessionStream: UserSessionStreaming { get }
    var userSessionWorker: UserSessionWorker { get }
    
    var mutableOrderHistoryStream: MutableOrderHistoryStreaming { get }
    var orderHistoryStream: OrderHistoryStreaming { get }
    var orderHistoryWorker: OrderHistoryWorker { get }
    
    associatedtype CartBuilding: ViewBuilding
    func cartBuilder(stacker: ViewStacking) -> CartBuilding
}

class RootDependencyProvider: RootDependencyProviding {
    let mutableDraftOrderStream: MutableDraftOrderStreaming = DraftOrderStream()
    var draftOrderStream: DraftOrderStreaming { mutableDraftOrderStream }
    lazy var draftOrderTotalStream: DraftOrderTotalStreaming = DraftOrderTotalStream(draftOrderStream: draftOrderStream)
    lazy var draftOrderStore: DraftOrderStoring = DraftOrderStore(stream: mutableDraftOrderStream)
    
    let mutableUserSessionStream: MutableUserSessionStreaming = UserSessionStream()
    var userSessionStream: UserSessionStreaming { mutableUserSessionStream }
    lazy var userSessionWorker: UserSessionWorker = UserSessionWorker(mutableUserSessionStream: mutableUserSessionStream)
    
    let mutableOrderHistoryStream: MutableOrderHistoryStreaming = OrderHistoryStream()
    var orderHistoryStream: OrderHistoryStreaming { mutableOrderHistoryStream }
    lazy var orderHistoryWorker: OrderHistoryWorker = OrderHistoryWorker(mutableOrderHistoryStream: mutableOrderHistoryStream)
    
    func cartBuilder(stacker: ViewStacking) -> some ViewBuilding {
        CartBuilder(
            draftOrderStore: draftOrderStore,
            draftOrderTotalStream: draftOrderTotalStream,
            mutableUserSessionStream: mutableUserSessionStream,
            draftOrderStream: draftOrderStream,
            mutableOrderHistoryStream: mutableOrderHistoryStream,
            stacker: stacker
        )
    }
}

class PreviewRootDependencyProvider: RootDependencyProviding {
    let previewDraftOrderStore = PreviewDraftOrderStore()
    var mutableDraftOrderStream: MutableDraftOrderStreaming { previewDraftOrderStore.stream }
    var draftOrderStream: DraftOrderStreaming { previewDraftOrderStore.stream }
    var draftOrderTotalStream: DraftOrderTotalStreaming { previewDraftOrderStore.totalStream }
    var draftOrderStore: DraftOrderStoring { previewDraftOrderStore }

    let mutableUserSessionStream: MutableUserSessionStreaming = PreviewUserSessionStream()
    var userSessionStream: UserSessionStreaming { mutableUserSessionStream }
    lazy var userSessionWorker: UserSessionWorker = UserSessionWorker(mutableUserSessionStream: mutableUserSessionStream)
    
    let mutableOrderHistoryStream: MutableOrderHistoryStreaming = PreviewOrderHistoryStream()
    var orderHistoryStream: OrderHistoryStreaming { mutableOrderHistoryStream }
    lazy var orderHistoryWorker: OrderHistoryWorker = OrderHistoryWorker(mutableOrderHistoryStream: mutableOrderHistoryStream)
    
    func cartBuilder(stacker: ViewStacking) -> some ViewBuilding {
        CartBuilder(
            draftOrderStore: draftOrderStore,
            draftOrderTotalStream: draftOrderTotalStream,
            mutableUserSessionStream: mutableUserSessionStream,
            draftOrderStream: draftOrderStream,
            mutableOrderHistoryStream: mutableOrderHistoryStream,
            stacker: stacker
        )
    }
}
