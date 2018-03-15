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

class TMDbOperation<Value>: Operation where Value: Decodable {
    private let urlRequest: URLRequest
    private let decoder: JSONDecoder
    private let urlSession: URLSession
    private let keyPath: String?
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
                self.completionHandler(.failure(error))
                return
            }
            
            guard var data = data else {
                // TODO: implement
                return
            }
            
            if let tmdbError = self.isTMDbKitError(data) {
                self.completionHandler(.failure(tmdbError))
                return
            }
            
            do {
                if let keyPath = self.keyPath {
                    let json = try JSONSerialization.jsonObject(with: data)
                    if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                        data = try JSONSerialization.data(withJSONObject: nestedJson)
                    }
                }
            
                let value = try self.decoder.decode(Value.self, from: data)
                self.completionHandler(.success(value))
            } catch {
                self.completionHandler(.failure(error))
            }
        }
        self.dataTask?.resume()
        let dispatchResult = semaphore.wait(timeout: .distantFuture)
        
        if dispatchResult == DispatchTimeoutResult.timedOut {
            self.completionHandler(.failure(TMDbServiceError.backendServerTimedOut))
        }
    }
    
    override func cancel() {
        super.cancel()
        
        self.dataTask?.cancel()
    }
    
    private func isTMDbKitError(_ data: Data) -> TMDbServiceError? {
        return try? JSONDecoder().decode(TMDbServiceError.self, from: data)
    }
    
}
