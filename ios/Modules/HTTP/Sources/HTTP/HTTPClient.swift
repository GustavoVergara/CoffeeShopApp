import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

public protocol HTTPClientProtocol {
    @available(swift, deprecated: 5.5, message: "This will be removed in future releases; please migrate to the async alternative `request(_ route: HTTPRoute)`.")
    func request(_ route: HTTPRoute, returnQueue: DispatchQueue?, completion: @escaping (HTTPResult) -> Void)
    @available(iOS 15.0.0, macOS 12.0.0, tvOS 15.0, watchOS 8.0, *)
    func request(_ route: HTTPRoute) async throws -> HTTPResponse
}

public extension HTTPClientProtocol {
    @available(swift, deprecated: 5.5, message: "This will be removed in future releases; please migrate to the async alternative `request(_ route: HTTPRoute)`.")
    func request(_ route: HTTPRoute, completion: @escaping (HTTPResult) -> Void) {
        request(route, returnQueue: nil, completion: completion)
    }
}

public struct HTTPClient: HTTPClientProtocol {
    let urlSession: URLSessionProtocol
    let routeMapper: RouteMapperProtocol
    let logger: HTTPLoggerProtocol
    
    init(
        urlSession: URLSessionProtocol = URLSession.shared,
        routeMapper: RouteMapperProtocol,
        logger: HTTPLoggerProtocol
    ) {
        self.urlSession = urlSession
        self.routeMapper = routeMapper
        self.logger = logger
    }
    
    public init(
        urlSession: URLSession = URLSession.shared,
        logger: HTTPLoggerProtocol = HTTPLogger(level: .none)
    ) {
        self = HTTPClient(urlSession: urlSession,
                          routeMapper: RouteMapper(),
                          logger: logger)
    }
    
    public func request(_ route: HTTPRoute, returnQueue: DispatchQueue?, completion: @escaping (HTTPResult) -> Void) {
        guard let request = try? routeMapper.map(route) else {
            returnQueue.execute(
                completion,
                with: .failure(HTTPError(code: .invalidRequest, response: nil))
            )
            return
        }
        logger.logRequest(request)
        let dataTask = urlSession.dataTask(with: request) { [self] (data, urlResponse, error) in
            logger.logResponse(data: data, response: urlResponse, error: error)
            let result = self.result(data: data, response: urlResponse, error: error)
            returnQueue.execute(completion, with: result)
        }
        dataTask.resume()
    }
    
    private func result(data: Data?, response: URLResponse?, error: Error?) -> HTTPResult {
        guard let data = data, let response = response as? HTTPURLResponse else {
            return .failure(HTTPError(code: .invalidResponse, response: nil))
        }
        
        let apiResponse = HTTPResponse(response: response, body: data)
        guard error == nil else {
            return .failure(HTTPError(code: .unknown, response: apiResponse))
        }
        
        return .success(apiResponse)
    }
    
    @available(iOS 15.0.0, macOS 12.0.0, tvOS 15.0, watchOS 8.0, *)
    public func request(_ route: HTTPRoute) async throws -> HTTPResponse {
        guard let request = try? routeMapper.map(route) else {
            throw HTTPError(code: .invalidRequest, response: nil)
        }
        logger.logRequest(request)
        
        do {
            let (data, urlResponse) = try await urlSession.data(for: request)
            logger.logResponse(data: data, response: urlResponse, error: nil)
            return try result(data: data, response: urlResponse)
        } catch {
            switch error {
            case let httpError as HTTPError:
                throw httpError
            default:
                logger.logResponse(data: nil, response: nil, error: error)
                throw HTTPError(code: .unknown, response: nil)
            }
        }
    }
    
    private func result(data: Data?, response: URLResponse?) throws -> HTTPResponse {
        if let data = data, let response = response as? HTTPURLResponse {
            return HTTPResponse(response: response, body: data)
        } else {
            throw HTTPError(code: .invalidResponse, response: nil)
        }
    }
    
}

extension Optional where Wrapped == DispatchQueue {
    
    fileprivate func execute<T>(_ closure: @escaping (T) -> Void, with value: T) {
        if let queue = self {
            queue.async { closure(value) }
        } else {
            closure(value)
        }
    }
    
}
