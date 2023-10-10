import XCTest
import CoreTestKit
import HTTP
import HTTPTestKit
@testable import Menu

final class MenuNetworkerTests: XCTestCase {
    var httpClientSpy = HTTPClientSpy()
    lazy var sut = MenuNetworker(
        httpClient: httpClientSpy,
        jsonDecoder: JSONDecoder()
    )
        
    override func setUp() {
        
    }
    
    func test_getMenu_whenRequestSucceeds_returnsParsedResponse() async throws {
        httpClientSpy.stubbedAsyncRequestResult = Value.successfulMenuResponse
        let menuResponse = try await sut.getMenu()
        XCTAssertEqual(menuResponse, Value.menuResponseStub)
    }
    
    func test_getMenu_whenRequestFails_throwsError() async {
        httpClientSpy.stubbedAsyncRequestError = URLError(.badURL)
        await AssertThrowsAsyncError(try await sut.getMenu()) { error in
            XCTAssertEqual(error as? URLError, httpClientSpy.stubbedAsyncRequestError as? URLError)
        }
    }
    
    enum Value {
        static var menuResponseStub = MenuResponse.stub()
        static var successfulMenuResponse: HTTPResponse {
            HTTPResponse(
                response: HTTPURLResponse(),
                body: try! JSONEncoder().encode(menuResponseStub)
            )
        }
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

extension ProductResponse {
    static func stub(id: String = "0", name: String = "") -> ProductResponse {
        ProductResponse(
            id: id,
            name: name,
            description: "Description",
            photo: "",
            skus: [
                SKUResponse(
                    id: "1",
                    price: 8.3,
                    attributes: ["tamanho": "Grande"]
                )
            ],
            allAttributes: [
                AttributeResponse(
                    key: "tamanho",
                    name: "Tamanho"
                )
            ]
        )
    }
}
