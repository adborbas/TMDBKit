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

public class TMDbKitMovieService: TMDbMovieService {
    private let urlBuilder: TMDbURLBuilder
    
    public init(config: TMDbKitServiceConfig) {
        self.urlBuilder = TMDbURLBuilder(apiKey: config.apiKey, language: config.language)
    }
    
    public func movieDetail(for movieId: Int, appending queryMethods: [TMDbMovieServiceQueryMethod] = [TMDbMovieServiceQueryMethod](), completionHandler: @escaping (TMDbServiceResult<Movie>) -> ()) {
        let url = self.urlBuilder.movieDetailURL(for: movieId, appending: queryMethods)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Short)
        
        Alamofire.request(url).responseTMDbKitResult(decoder: decoder, completionHandler: completionHandler)
    }
    
    //    public func movieCredits(for movieId: Int, completionHandler: @escaping (MovieCredit?, Error?) -> ()) {
    //        let url = self.urlBuilder.movieCreditsURL(for: movieId)
    //        Alamofire.request(url).responseDecodable(completionHandler: completionHandler)
    //    }
    public func movieCredits(for movieId: Int, completionHandler: @escaping (TMDbServiceResult<MovieCredit>) -> ()) {
        let url = self.urlBuilder.movieCreditsURL(for: movieId)
        Alamofire.request(url).responseTMDbKitResult(completionHandler: completionHandler)
    }
}
