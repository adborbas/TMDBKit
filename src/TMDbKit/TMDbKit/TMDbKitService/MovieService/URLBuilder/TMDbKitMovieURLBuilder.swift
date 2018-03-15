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

class TMDbKitMovieURLBuilder: TMDbURLBuilder {
    func movieDetailURL(for movieId: Int, language: String? = nil, appending queryMethods: [TMDbMovieServiceQueryMethod] = [TMDbMovieServiceQueryMethod]()) -> URL {
        var components = self.baseURLComponents()
        
        // Append path
        let movieDetailPath = self.movieDetailPath(with: movieId)
        components.path.append(movieDetailPath)
        components.addQueryItem(from: queryMethods.map { $0.rawValue })
        
        // Append language
        if let language = language {
            let languageQueryItem = URLQueryItem(name: TMDbAPI.Key.language, value: language)
            components.queryItems!.append(languageQueryItem)
        }
        
        return components.url!
    }
    
    func movieCreditsURL(for movieId: Int) -> URL {
        var components = self.baseURLComponents()
        
        // Append path
        let movieCreditsPath = self.movieDetailPath(with: movieId, method: TMDbAPI.Movie.credits)
        components.path.append(movieCreditsPath)
        
        return components.url!
    }
    
    func movieAlternativeTitles(for movieId: Int, country: String? = nil) -> URL {
        var components = self.baseURLComponents()
        
        // Append path
        let movieCreditsPath = self.movieDetailPath(with: movieId, method: TMDbAPI.Movie.alternativeTitles)
        components.path.append(movieCreditsPath)
        
        // Append country query
        if let country = country {
            let countryQueryItem = URLQueryItem(name: TMDbAPI.Movie.country, value: country)
            components.queryItems!.append(countryQueryItem)
        }
        
        return components.url!
    }
    
    func movieImages(for movieId: Int) -> URL {
        var components = self.baseURLComponents()
        
        // Append path
        let movieCreditsPath = self.movieDetailPath(with: movieId, method: TMDbAPI.Movie.images)
        components.path.append(movieCreditsPath)
        
        return components.url!
    }
    
    private func movieDetailPath(with movieId: Int, method: String? = nil) -> String {
        var url = URL(string: "/")!.appendingPathComponent(TMDbAPI.Movie.path).appendingPathComponent("\(movieId)")
        if let method = method {
            url.appendPathComponent(method)
        }
        
        return url.absoluteString
    }
}
