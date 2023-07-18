import Foundation

public protocol NetworkResponseSerializing {
    associatedtype SerializedObject
    func serialize(request: URLRequest, response: HTTPURLResponse, data: Data?) throws -> SerializedObject
}

public struct DecodableResponseSerializer<T: Decodable>: NetworkResponseSerializing {
    public let decoder: JSONDecoder

    public init(decoder: JSONDecoder) {
        self.decoder = decoder
    }

    public func serialize(request: URLRequest, response: HTTPURLResponse, data: Data?) throws -> T {
        try decoder.decode(T.self, from: data ?? Data())
    }
}
