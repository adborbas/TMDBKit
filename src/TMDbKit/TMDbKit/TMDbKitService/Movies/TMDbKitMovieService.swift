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

public class TMDbKitMovieService: TMDbMovieService {
    public let operationQueue = OperationQueue()
    private let urlBuilder: TMDbKitMovieURLBuilder
    
    private enum TMDbJSONDecoder {
        static var shortDate: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.tmdbShort)
            return decoder
        }()
        
        static var fullDate: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.tmdbFull)
            return decoder
        }()
    }
    
    public init(config: TMDbKitServiceConfig) {
        self.urlBuilder = TMDbKitMovieURLBuilder(apiKey: config.apiKey)
    }
    
    public func detail(for movieId: Int,
                            language: String? = nil,
                            appending queryMethods: [TMDbMovieServiceQueryMethod] = [TMDbMovieServiceQueryMethod](),
                            completionHandler: @escaping (TMDbServiceResult<Movie>) -> ()) -> Operation {
        let url = self.urlBuilder.movieDetailURL(for: movieId, language: language, appending: queryMethods)
        let responseDecoder = TMDbServiceResponseDecoder<Movie>(jsonDecoder: TMDbJSONDecoder.shortDate)
        let operation = TMDbOperation(url: url, responseDecoder: responseDecoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func credits(for movieId: Int,
                             completionHandler: @escaping (TMDbServiceResult<MovieCredits>) -> ()) -> Operation {
        let url = self.urlBuilder.movieCreditsURL(for: movieId)
        
        let operation = TMDbOperation(url: url, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func alternativeTitles(for movieId: Int,
                                       country: String? = nil,
                                       completionHandler: @escaping (TMDbServiceResult<[AlternativeTitle]>) -> Void) -> Operation {
        let url = self.urlBuilder.movieAlternativeTitles(for: movieId, country: country)
        
        let decoder = TMDbServiceResponseDecoder<[AlternativeTitle]>(keyPath: "titles")
        let operation = TMDbOperation(url: url, responseDecoder: decoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func images(for movieId: Int,
                            completionHandler: @escaping (TMDbServiceResult<Images>) -> Void) -> Operation {
        let url = self.urlBuilder.movieImages(for: movieId)
        
        let operation = TMDbOperation(url: url, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func nowPlaying(language: String? = nil,
                           page: Int? = nil,
                           region: String? = nil,
                           completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        return self.serviceList(language, page, region, self.urlBuilder.nowPlaying, completionHandler)
    }
    
    public func popular(language: String? = nil,
                        page: Int? = nil,
                        region: String? = nil,
                        completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        return self.serviceList(language, page, region, self.urlBuilder.popular, completionHandler)
    }
    
    public func topRated(language: String? = nil,
                        page: Int? = nil,
                        region: String? = nil,
                        completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        return self.serviceList(language, page, region, self.urlBuilder.topRated, completionHandler)
    }
    
    public func upcoming(language: String? = nil,
                        page: Int? = nil,
                        region: String? = nil,
                        completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        return self.serviceList(language, page, region, self.urlBuilder.upcoming, completionHandler)
    }
    
    public func releaseDates(for movieId: Int, completionHandler: @escaping (TMDbServiceResult<[Release]>) -> Void) -> Operation {
        let url = self.urlBuilder.releaseDates(for: movieId)
        
        let decoder = TMDbServiceResponseDecoder<[Release]>(jsonDecoder: TMDbJSONDecoder.fullDate, keyPath: "results")
        let operation = TMDbOperation(url: url, responseDecoder: decoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func recommendations(for movieId: Int,
                                language: String? = nil,
                                page: Int? = nil,
                                completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        let url = self.urlBuilder.recommendations(for: movieId, language: language, page: page ?? 1)
        
        let responseDecoder = TMDbServiceResponseDecoder<Page<MovieInfo>>(jsonDecoder: TMDbJSONDecoder.shortDate)
        let operation = TMDbOperation(url: url, responseDecoder: responseDecoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    public func lists(for movieId: Int,
                      language: String? = nil,
                      page: Int? = nil,
                      completionHandler: @escaping (TMDbServiceResult<Page<MovieList>>) -> Void) -> Operation {
        let url = self.urlBuilder.lists(for: movieId, language: language, page: page ?? 1)
        
        let responseDecoder = TMDbServiceResponseDecoder<Page<MovieList>>(jsonDecoder: TMDbJSONDecoder.shortDate)
        let operation = TMDbOperation(url: url, responseDecoder: responseDecoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
    
    // MARK: - Private functions
    
    private func serviceList(_ language: String? = nil,
                         _ page: Int? = nil,
                         _ region: String? = nil,
                         _ urlConstructor: (String?, Int, String?) -> URL,
                         _ completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation {
        let url = urlConstructor(language, page ?? 1, region)
        
        let responseDecoder = TMDbServiceResponseDecoder<Page<MovieInfo>>(jsonDecoder: TMDbJSONDecoder.shortDate)
        let operation = TMDbOperation(url: url, responseDecoder: responseDecoder, completionHandler: completionHandler)
        self.operationQueue.addOperation(operation)
        return operation
    }
}
