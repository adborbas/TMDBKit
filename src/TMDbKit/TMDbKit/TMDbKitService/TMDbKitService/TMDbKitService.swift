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

public class TMDbKitService: TMDbService {
    private let urlBuilder: TMDbURLBuilder

    public init(config: TMDbKitServiceConfig) {
        self.urlBuilder = TMDbURLBuilder(apiKey: config.apiKey, language: config.language)
    }
}

// MARK: - Movie
extension TMDbKitService {
    public func movieDetail(for movieId: Int, completionHandler: @escaping (Movie?, Error?) -> ()) {
        let url = self.urlBuilder.movieDetailURL(for: movieId)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Short)
        
        self.requestDecodable(url, decoder: decoder, completionHandler: completionHandler)
    }
    
    public func movieCredits(for movieId: Int, completionHandler: @escaping (MovieCredit?, Error?) -> ()) {
        let url = self.urlBuilder.movieCreditsURL(for: movieId)
        self.requestDecodable(url, completionHandler: completionHandler)
    }
}

// MARK: - Parsing
fileprivate extension TMDbKitService {
    
    func requestDecodable<Entity: Decodable>(_ url: URL, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (Entity?, Error?) -> Void) {
        Alamofire.request(url).responseData { response in
            switch response.result {
            case .failure(let error):
                completionHandler(nil, error)
                return
                
            case .success(let data):
                if let tmdbError = self.isTMDbError(data) {
                    completionHandler(nil, tmdbError)
                    return
                }
                
                do {
                    let entity = try decoder.decode(Entity.self, from: data)
                    completionHandler(entity, nil)
                } catch {
                    completionHandler(nil, error)
                    return
                }
            }
        }
    }
    
    private func isTMDbError(_ data: Data) -> TMDbKitError? {
        return try? JSONDecoder().decode(TMDbKitError.self, from: data)
    }
}
