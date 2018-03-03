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
import Alamofire

extension DataRequest {
    
    func responseTMDbKitResult2<Value: Decodable>(decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        self.responseDecodableObject(decoder: decoder) { (response: DataResponse<Value>) in
            switch response.result {
            case .failure(let error):
                if let data = response.data, let tmdbError = self.isTMDbKitError(data) {
                    completionHandler(.failure(tmdbError))
                    return
                }

                completionHandler(.failure(error))
                return
                
            case .success(let value):
                completionHandler(.success(value))
            }
        }
    }
    
    func responseTMDbKitResult<Value: Decodable>(decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        self.responseData { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
                
            case .success(let data):
                do {
                    if let error = self.isTMDbKitError(data) {
                        completionHandler(.failure(error))
                        return
                    }
                    
                    let entity = try decoder.decode(Value.self, from: data)
                    completionHandler(.success(entity))
                } catch {
                    completionHandler(.failure(error))
                    return
                }
            }
        }
    }
    
    func responseTMDbServiceArrayResult<Value>(decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceArrayResult<Value>) -> Void) where Value: Decodable {
        self.responseData { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
                
            case .success(let data):
                do {
                    if let error = self.isTMDbKitError(data) {
                        completionHandler(.failure(error))
                        return
                    }
                    
                    let entities = try decoder.decode(TMDbKitServiceArrayResult<Value>.self, from: data)
                    completionHandler(.success(entities.items))
                } catch {
                    completionHandler(.failure(error))
                    return
                }
            }
        }
    }
    
    private func isTMDbKitError(_ data: Data) -> TMDbKitServiceError? {
        return try? JSONDecoder().decode(TMDbKitServiceError.self, from: data)
    }
}

struct TMDbKitServiceArrayResult<Value: Decodable>: Decodable {
    public let items: [Value]
}

fileprivate extension TMDbKitServiceArrayResult {
    enum CodingKeys: String, CodingKey  {
        case items = "results"
    }
}
