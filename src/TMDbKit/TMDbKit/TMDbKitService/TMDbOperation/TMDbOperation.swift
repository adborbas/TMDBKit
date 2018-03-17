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
    private let urlSession: URLSession
    private let responseDecoder: TMDbServiceResponseDecoder<Value>
    private let completionHandler: (TMDbServiceResult<Value>) -> Void
    private var dataTask: URLSessionDataTask?
    
    init(request: URLRequest,
         urlSession: URLSession = URLSession.shared,
         responseDecoder: TMDbServiceResponseDecoder<Value> = TMDbServiceResponseDecoder<Value>(),
         completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        self.urlRequest = request
        self.urlSession = urlSession
        self.responseDecoder = responseDecoder
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    convenience init(url: URL,
                     urlSession: URLSession = URLSession.shared,
                     responseDecoder: TMDbServiceResponseDecoder<Value> = TMDbServiceResponseDecoder<Value>(),
                     completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        let urlRequest = URLRequest(url: url)
        self.init(request: urlRequest, urlSession: urlSession, responseDecoder: responseDecoder, completionHandler: completionHandler)
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        self.dataTask = self.urlSession.dataTask(with: self.urlRequest) { (data, response, error) in
            defer { semaphore.signal() }
        
            do {
                let value = try self.responseDecoder.process(data, response, error)
                self.completionHandler(.success(value))
            } catch {
                self.completionHandler(.failure(error))
            }
        }
        self.dataTask?.resume()
        // The URLSessionDataTask terminates with error if request timeout. Do not need to check here.
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    override func cancel() {
        super.cancel()
        self.dataTask?.cancel()
    }
}
