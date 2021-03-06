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

class TMDbServiceResponseDecoder<Value: Decodable>: ResponseDecoding {
    typealias DecodedValue = Value
    
    private let jsonDecoder: JSONDecoder
    private let keyPath: String?
    
    init(jsonDecoder: JSONDecoder = JSONDecoder(), keyPath: String? = nil) {
        self.jsonDecoder = jsonDecoder
        self.keyPath = keyPath
    }
    
    func process(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Value {
        if let error = error {
            throw TMDbServiceError.networkError(error)
        }
        
        guard let data = data else {
            throw TMDbServiceError.noDataInResponse
        }
        
        if let tmdbError = TMDbServiceError.FailureFromServiceReason.isFailure(data) {
            throw TMDbServiceError.failureFromService(tmdbError)
        }
        
        do {
            return try self.performDecoding(on: data, keyPath: self.keyPath)
        } catch let error as TMDbServiceError {
            throw error
        } catch {
            throw TMDbServiceError.failedToParse(.decodeFailed(error))
        }
    }
    
    /**
     Performs decoding with the `JSONDecoder` on self.
     - Parameters:
     - data: `Data` to decode JSON from.
     - keyPath: Specify where the JSON should be decoded from. Pass `nil` if the JSON object to parse is at root.
     */
    private func performDecoding(on data: Data, keyPath: String?) throws -> Value {
        if let keyPath = keyPath {
            let jsonAtKeyPath = try self.extractJSON(at: keyPath, from: data)
            return try self.performDecoding(on: jsonAtKeyPath, keyPath: nil)
        }
        
        return try self.jsonDecoder.decode(Value.self, from: data)
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
    private func extractJSON(at keyPath: String, from data: Data) throws -> Data {
        let json = try JSONSerialization.jsonObject(with: data)
        guard let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) else {
            throw TMDbServiceError.failedToParse(.jsonForKeyPathNotFound(keyPath))
        }
        return try JSONSerialization.data(withJSONObject: nestedJson)
    }
}
