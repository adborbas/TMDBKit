// Copyright (c) 2018. Adam Borbas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

class TMDbKitServiceOperation<Value>: Operation where Value: Decodable {
    private let urlRequest: URLRequest
    private let urlSession: URLSession
    private let keyPath: String?
    private let decoder: JSONDecoder
    private let completionHandler: (TMDbServiceResult<Value>) -> Void
    private var dataTask: URLSessionDataTask?
    
    init(request: URLRequest, urlSession: URLSession = URLSession.shared, keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        self.urlRequest = request
        self.decoder = decoder
        self.urlSession = urlSession
        self.keyPath = keyPath
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    convenience init(url: URL, urlSession: URLSession = URLSession.shared, keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        let urlRequest = URLRequest(url: url)
        self.init(request: urlRequest, urlSession: urlSession, keyPath: keyPath, decoder: decoder, completionHandler: completionHandler)
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        self.dataTask = self.urlSession.dataTask(with: self.urlRequest) { (data, response, error) in
            defer { semaphore.signal() }
            
            if let error = error {
                self.completionHandler(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                self.completionHandler(.failure(.noDataInResponse))
                return
            }
            
            if let tmdbError = TMDbServiceError.FailureFromServiceReason.isFailure(data) {
                self.completionHandler(.failure(.failureFromService(tmdbError)))
                return
            }
            
            self.performDecoding(on: data, keyPath: self.keyPath)
        }
        self.dataTask?.resume()
        // The URLSessionDataTask terminates with error if request timeout. Do not need to check here.
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    override func cancel() {
        super.cancel()
        
        self.dataTask?.cancel()
    }
    
    /**
     Performs decoding with the `JSONDecoder` on self.
     - Parameters:
        - data: `Data` to decode JSON from.
        - keyPath: Specify where the JSON should be decoded from. Pass `nil` if the JSON object to parse is at root.
     */
    private func performDecoding(on data: Data, keyPath: String?) {
        do {
            if let keyPath = keyPath {
                self.performDecoding(on: try self.extractJSON(from: keyPath, from: data), keyPath: nil)
                return
            }
            
            let value = try self.decoder.decode(Value.self, from: data)
            self.completionHandler(.success(value))
        } catch {
            self.completionHandler(.failure(.failedToParse(.decodeFailed(error))))
        }
    }
    
    /**
     Extracts a JSON object from `Data` at a given keyPath.
     - Parameters:
        - keyPath: Path to extract the JSON object from.
        - data: `Data` that should contain the JSON object.
     - Returns: The extracted JSON in `Data`.
     - Throws:
        - `JSONParsingReasion.jsonForKeyPathNotFound` if a JSON object could not be found at the keyPath.
        - Other error is JSON object found at keyPath could not be parsed.
     */
    private func extractJSON(from keyPath: String, from data: Data) throws -> Data {
        let json = try JSONSerialization.jsonObject(with: data)
        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            throw TMDbServiceError.failedToParse(.jsonForKeyPathNotFound(keyPath))
        }
        return try JSONSerialization.data(withJSONObject: nestedJson)
    }
    
}