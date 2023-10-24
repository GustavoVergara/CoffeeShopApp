import Foundation

protocol CodableStoring {
    func object<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
    @discardableResult
    func store<T: Encodable>(_ obj: T, forKey key: String) -> Bool
    @discardableResult
    func removeObject(forKey key: String) -> Bool
    @discardableResult
    func removeAllObjects() -> Bool
}

class DiskStorage: CodableStoring {
    private let fileManager: FileManager
    private let cacheURL: URL
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(
        fileManager: FileManager = FileManager.default,
        cacheDirectoyName: String = Bundle.main.bundleIdentifier ?? "coffeeapp"
    ) {
        self.fileManager = fileManager
        self.cacheURL = fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent(cacheDirectoyName)
        
        if !fileManager.fileExists(atPath: cacheURL.absoluteString) {
            try? fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func object<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
    
    @discardableResult
    func store<T: Encodable>(_ obj: T, forKey key: String) -> Bool {
        let url = cacheURL.appendingPathComponent(key, isDirectory: false)
        
        do {
            let data = try encoder.encode(obj)
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            return fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            return false
        }
    }
    
    @discardableResult
    func removeObject(forKey key: String) -> Bool {
        let url = cacheURL.appendingPathComponent(key, isDirectory: false)
        guard fileManager.fileExists(atPath: url.path) else {
            return true
        }
        do {
            try fileManager.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func removeAllObjects() -> Bool {
        let url = cacheURL
        guard fileManager.fileExists(atPath: url.path) else {
            return true
        }
        do {
            try fileManager.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    private func data(forKey key: String) -> Data? {
        let url = cacheURL.appendingPathComponent(key, isDirectory: false)
        
        if !fileManager.fileExists(atPath: url.path) {
            return nil
        }
        
        return fileManager.contents(atPath: url.path)
    }
    
    private func storeObject(_ data: Data, forKey key: String) -> Bool {
        let url = cacheURL.appendingPathComponent(key, isDirectory: false)
        
        do {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            return fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            return false
        }
    }
}
