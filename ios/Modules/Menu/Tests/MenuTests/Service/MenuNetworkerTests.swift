import XCTest
import HTTP
import HTTPTestKit
@testable import Menu

final class MenuNetworkerTests: XCTestCase {
    var jsonEncoder = JSONEncoder()
    var httpClient = HTTPClientSpy()
    lazy var sut = MenuNetworker(
        httpClient: httpClient,
        jsonDecoder: JSONDecoder()
    )
    
    let menuResponseStub = MenuResponse.stub()
    var menuResponseData: Data {
        try! jsonEncoder.encode(menuResponseStub)
    }
    
    func test_getMenu() async throws {
        httpClient.stubbedAsyncRequestResult = HTTPResponse(
            response: HTTPURLResponse(),
            body: menuResponseData
        )
        let menuResponse = try await sut.getMenu()
        XCTAssertEqual(menuResponse, menuResponseStub)
    }
}

extension MenuResponse {
    static func stub(storeID: String = "0", storeName: String = "") -> MenuResponse {
        MenuResponse(
            storeID: storeID,
            storeName: storeName,
            products: [
                .stub()
            ]
        )
    }
}

extension MenuResponse.ProductResponse {
    static func stub(id: String = "0", name: String = "") -> MenuResponse.ProductResponse {
        MenuResponse.ProductResponse(
            id: id,
            name: name,
            description: "Description",
            photo: "",
            skus: [
                MenuResponse.SKUResponse(
                    id: "1",
                    price: 8.3,
                    attributes: ["tamanho": "Grande"]
                )
            ],
            allAttributes: [
                MenuResponse.AttributeResponse(
                    key: "tamanho",
                    description: "Tamanho"
                )
            ]
        )
    }
}
