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

class TMDbKitMovieURLBuilder {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func movieDetailURL(for movieId: Int, language: String? = nil, appending queryMethods: [TMDbMovieServiceQueryMethod] = [TMDbMovieServiceQueryMethod]()) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let movieDetailPath = self.movieMethodPath(with: movieId)
        components.path = movieDetailPath
        components.addQueryItem(from: queryMethods.map { $0.rawValue })
        
        components.language = language
        
        return components.url!
    }
    
    func movieCreditsURL(for movieId: Int) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let movieCreditsPath = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.credits)
        components.path = movieCreditsPath
        
        return components.url!
    }
    
    func movieAlternativeTitles(for movieId: Int, country: String? = nil) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let movieCreditsPath = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.alternativeTitles)
        components.path = movieCreditsPath
        
        components.country = country
        
        return components.url!
    }
    
    func movieImages(for movieId: Int) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let movieCreditsPath = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.images)
        components.path = movieCreditsPath
        
        return components.url!
    }
    
    func nowPlaying(language: String?, page: Int, region: String?) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let nowPlayingPath = self.movieMethodPath(method: TMDbAPI.Movie.nowPlaying)
        components.path = nowPlayingPath
        
        components.language = language
        components.page = page
        if let region = region {
            components.addQueryItem(key: TMDbAPI.Key.region, value: region)
        }
        
        return components.url!
    }
    
    func popular(language: String?, page: Int, region: String?) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let popularPath = self.movieMethodPath(method: TMDbAPI.Movie.popular)
        components.path = popularPath
        
        components.language = language
        components.page = page
        if let region = region {
            components.addQueryItem(key: TMDbAPI.Key.region, value: region)
        }
        
        return components.url!
    }
    
    func releaseDates(for movieId: Int) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let releaseDates = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.releaseDates)
        components.path = releaseDates
        
        return components.url!
    }
    
    func recommendations(for movieId: Int, language: String?, page: Int) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let recommendations = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.recommendations)
        components.path = recommendations
        
        components.language = language
        components.page = page
        
        return components.url!
    }
    
    func lists(for movieId: Int, language: String?, page: Int) -> URL {
        var components = TMDbURLComponents(apiKey: self.apiKey, service: TMDbAPI.Movie.path)
        
        let lists = self.movieMethodPath(with: movieId, method: TMDbAPI.Movie.lists)
        components.path = lists
        
        components.language = language
        components.page = page
        
        return components.url!
    }
    
    // MARK: - Private Functions
    private func movieMethodPath(with movieId: Int? = nil, method: String? = nil) -> String {
        var path = ""
        
        if let movieId = movieId {
            path.append("\(movieId)")
        }
        if let method = method {
            path.append("/\(method)")
        }
        
        return path
    }
}
