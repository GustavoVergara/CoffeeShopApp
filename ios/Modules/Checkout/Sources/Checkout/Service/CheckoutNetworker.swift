import Foundation
import HTTP

protocol CheckoutNetworking {
    func placeOrder(_ order: OrderNetworkObject) async throws
    func getOrders(userID: String) async throws -> [OrderNetworkObject]
}

struct CheckoutNetworker: CheckoutNetworking {
    let httpClient: HTTPClientProtocol
    let jsonDecoder: JSONDecoder
    
    init(
        httpClient: HTTPClientProtocol = HTTPClient(
            urlSession: URLSession(configuration: .ephemeral),
            logger: HTTPLogger(level: .outgoing)
        ),
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.jsonDecoder = jsonDecoder
    }
    
    func placeOrder(_ order: OrderNetworkObject) async throws {
        let response = try await httpClient.request(CheckoutEndpointRoute.placeOrder(storeID: "0", order: order))
        guard 200 <= response.response.statusCode || response.response.statusCode < 300 else {
            throw CheckoutError.unknowError
        }
    }
    
    func getOrders(userID: String) async throws -> [OrderNetworkObject] {
        let response = try await httpClient.request(CheckoutEndpointRoute.getOrders(storeID: "0", userID: userID))
        return try jsonDecoder.decode([OrderNetworkObject].self, from: response.body)
    }
}

enum CheckoutError: Error {
    case unknowError
}

enum CheckoutEndpointRoute: HTTPRoute {
    case placeOrder(storeID: String, order: OrderNetworkObject)
    case getOrders(storeID: String, userID: String)
    
    var scheme: String { "http" }
    var host: String { "localhost" }
    var port: Int? { 5000 }
    var path: String {
        switch self {
        case .placeOrder(let storeID, _):
            return "/store/\(storeID)/order"
        case .getOrders(let storeID, _):
            return "/store/\(storeID)/orders"
        }
    }
    var method: HTTP.HTTPMethod {
        switch self {
        case .placeOrder:
            return .post
        case .getOrders:
            return .get
        }
    }
    
    var query: [String : String] {
        switch self {
        case .getOrders(_, let userID):
            return ["userID": userID]
        default:
            return [:]
        }
    }
    
    var body: HTTPBody? {
        switch self {
        case .placeOrder(_, let order):
            return JSONBody(encodable: order)
        default:
            return nil
        }
    }
}
