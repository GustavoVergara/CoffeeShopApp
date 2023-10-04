import XCTest
@testable import Menu

final class MenuResponseTests: XCTestCase {
    let jsonDecoder = JSONDecoder()
    
    func test_decoding() throws {
        let data = GetStoreMenuStubs.storeAJSONData
        let sut = try jsonDecoder.decode(MenuResponse.self, from: data)
        
        XCTAssertEqual(sut.storeID, "0")
        XCTAssertEqual(sut.storeName, "Loja A")
        XCTAssertEqual(sut.products.count, 1)
    }
}
