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
    
    func responseTMDbKitResult<Value: Decodable>(keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (TMDbServiceResult<Value>) -> Void) {
        self.responseDecodableObject(keyPath: keyPath, decoder: decoder) { (response: DataResponse<Value>) in
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
    
    private func isTMDbKitError(_ data: Data) -> TMDbServiceError? {
        return try? JSONDecoder().decode(TMDbServiceError.self, from: data)
    }
}
