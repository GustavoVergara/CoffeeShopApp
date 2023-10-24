import XCTest
import CoreTestKit
@testable import OrderLibrary

class DiskStorageTests: XCTestCase {
    let fileManager = FileManager.default
    let cacheDirectory = "coffeshoptest"
    
    lazy var sut = DiskStorage(fileManager: fileManager, cacheDirectoyName: cacheDirectory)
    
    let key = "daskj"
    var rng = SeededRandomNumberGenerator(101)
    
    lazy var cacheURL = fileManager
        .urls(for: .cachesDirectory, in: .userDomainMask).first!
        .appendingPathComponent(cacheDirectory)
    lazy var keyFileURL = cacheURL.appendingPathComponent(key, isDirectory: false)
    
    override func setUpWithError() throws {
        try deleteCache()
    }
    
    override func tearDownWithError() throws {
        try deleteCache()
    }
    
    func test_store_savesToFile() {
        let object = CodableStub.random(using: &rng)
        let storedSuccessfully = sut.store(object, forKey: key)
        
        XCTAssert(storedSuccessfully)
        XCTAssert(fileManager.fileExists(atPath: keyFileURL.path))
    }
    
    func test_object_restoresStoredObject() {
        let expectedObject = CodableStub.random(using: &rng)
        sut.store(expectedObject, forKey: key)
        
        let receivedObject = sut.object(CodableStub.self, forKey: key)
        XCTAssertEqual(receivedObject, expectedObject)
    }
    
    func test_object_whenNoObjectWasStored_returnsNil() {
        let value = sut.object(CodableStub.self, forKey: key)
        XCTAssertNil(value)
    }
    
    func test_removeObject_removesOnlyTheObjectRelatedToTheKey() {
        let secondKey = key + "keyB"
        let secondKeyURL = cacheURL.appendingPathComponent(secondKey, isDirectory: false)
        let object = CodableStub.random(using: &rng)
        sut.store(object, forKey: key)
        sut.store(object, forKey: secondKey)

        let removedSuccessfully = sut.removeObject(forKey: key)
        
        XCTAssert(removedSuccessfully)
        XCTAssertFalse(fileManager.fileExists(atPath: keyFileURL.path))
        XCTAssert(fileManager.fileExists(atPath: secondKeyURL.path))
    }
    
    func test_removeObject_whenNoObjectIsStoredForTheKey_returnsSuccess() {
        let removedSuccessfully = sut.removeObject(forKey: key)
        
        XCTAssert(removedSuccessfully)
    }
    
    func test_removeAllObjects_deletesDirectory() {
        sut.store(CodableStub.random(using: &rng), forKey: key)

        let removedSuccessfully = sut.removeAllObjects()
        
        XCTAssert(removedSuccessfully)
        XCTAssertFalse(fileManager.fileExists(atPath: cacheURL.path))
    }

    private func deleteCache() throws {
        guard fileManager.fileExists(atPath: cacheURL.path) else {
            return
        }
        
        try fileManager.removeItem(at: cacheURL)
    }
}

private struct CodableStub: Codable, Hashable {
    var number: Int
    var text: String
    var textArray: [String]
    
    static func random<T: RandomNumberGenerator>(using generator: inout T) -> CodableStub {
        CodableStub(
            number: .random(in: 0...999, using: &generator),
            text: String(String(describing: Self.self).shuffled(using: &generator)),
            textArray: (1...10).map { "\($0) " + String(String(describing: Self.self).shuffled(using: &generator)) }
        )
    }
}

//func object<T: Decodable>(forKey key: String) -> T?
//func store<T: Encodable>(_ obj: T, forKey key: String) -> Bool
//@discardableResult
//func removeObject(forKey key: String) -> Bool
//@discardableResult
//func removeAllObjects() -> Bool

//class CacheOnDiskTests: XCTestCase {
//
//    var sut: CacheOnDiskProtocol!
//
//    let key = "key"
//
//    override func setUp() {
//        super.setUp()
//
//        sut = CacheOnDisk(fileManager: FileManagerMock())
//    }
//
//    override func tearDown() {
//        super.tearDown()
//    }
//
//    func testValueNotExists() {
//        let value = sut.object(forKey: key)
//
//        XCTAssertNil(value)
//    }
//
//    func testStoreValue() {
//        let object = CacheResponse(headers: [:], data: Data(), lastModified: Date(), maxAge: 2)
//        _ = sut.setObject(object, forKey: key)
//        let value = sut.object(forKey: key)
//
//        XCTAssertNotNil(value)
//    }
//
//    func testRetriveValue() {
//        let object = CacheResponse(headers: [:], data: Data(), lastModified: Date(), maxAge: 2)
//        _ = sut.setObject(object, forKey: key)
//        let value = sut.object(forKey: key)
//
//        XCTAssertEqual(value!.maxAge, 2)
//    }
//
//    func testRemoveValue() {
//        let object = CacheResponse(headers: [:], data: Data(), lastModified: Date(), maxAge: 2)
//        _ = sut.setObject(object, forKey: key)
//
//        _ = sut.removeObject(forKey: key)
//
//        let valueRemoved = sut.object(forKey: key)
//
//        XCTAssertNil(valueRemoved)
//    }
//
//    func testRemoveAllValues() {
//        let object1 = CacheResponse(headers: [:], data: Data(), lastModified: Date(), maxAge: 1)
//        let object2 = CacheResponse(headers: [:], data: Data(), lastModified: Date(), maxAge: 2)
//
//        _ = sut.setObject(object1, forKey: "key1")
//        _ = sut.setObject(object2, forKey: "key2")
//
//        _ = sut.removeAllObjects()
//
//        let valueRemoved1 = sut.object(forKey: "key1")
//        let valueRemoved2 = sut.object(forKey: "key2")
//
//        XCTAssertNil(valueRemoved1)
//        XCTAssertNil(valueRemoved2)
//    }
//
//}
