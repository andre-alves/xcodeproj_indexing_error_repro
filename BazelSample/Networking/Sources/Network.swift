import Foundation
import NetworkInterface

public final class Network: Networking {
    private let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func execute<T>(
        request: URLRequest,
        responseSerializer: T,
        completion: @escaping (NetworkResponse<T.SerializedObject>) -> Void
    ) where T: NetworkResponseSerializing {
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.init(httpURLResponse: nil, result: .failure(error)))
            }

            guard let response = response as? HTTPURLResponse else {
                return completion(.init(httpURLResponse: nil, result: .failure(NetworkError.invalidResponseType)))
            }

            do {
                let value = try responseSerializer.serialize(request: request, response: response, data: data)
                completion(.init(httpURLResponse: response, result: .success(value)))
            } catch let error {
                completion(.init(httpURLResponse: response, result: .failure(error)))
            }
        }
        task.resume()
    }
}

public enum NetworkError: Error {
    case invalidResponseType
}
