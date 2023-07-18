import Foundation

public protocol Networking {
    func execute<T: NetworkResponseSerializing>(
        request: URLRequest,
        responseSerializer: T,
        completion: @escaping (NetworkResponse<T.SerializedObject>) -> Void
    )
}

public struct NetworkResponse<Body> {
    public let httpURLResponse: HTTPURLResponse?
    public let result: Result<Body, Error>

    public init(httpURLResponse: HTTPURLResponse?, result: Result<Body, Error>) {
        self.httpURLResponse = httpURLResponse
        self.result = result
    }
}
