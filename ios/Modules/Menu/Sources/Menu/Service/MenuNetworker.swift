import HTTP
import Foundation

protocol MenuNetworking {
    func getMenu() async throws -> MenuResponse
}

class MenuNetworker: MenuNetworking {
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
    
    func getMenu() async throws -> MenuResponse {
        let response = try await httpClient.request(MenuEndpointRoute.getMenu(storeID: "0"))
        let menu = try jsonDecoder.decode(MenuResponse.self, from: response.body)
        return menu
    }
}

enum MenuEndpointRoute: HTTPRoute {
    case getMenu(storeID: String)
    
    var scheme: String { "http" }
    var host: String { "localhost" }
    var port: Int? { 5000 }
    var path: String {
        switch self {
        case .getMenu(let storeID):
            return "/store/\(storeID)/menu"
        }
    }
    var method: HTTP.HTTPMethod { .get }
}
