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

struct TMDbURLComponents {
    private var urlComponents: URLComponents
    private let method: String
    
    var path: String = ""
    var language: String?
    var country: String?
    var region: String?
    var page: Int?
    
    var url: URL? {
        var components = self.urlComponents
        
        // Path
        var computedPath = URL(string: "/")!
        computedPath.appendPathComponent(TMDbAPI.version)
        computedPath.appendPathComponent(method)
        computedPath.appendPathComponent(path)
        components.path = computedPath.absoluteString
        
        
        if let language = self.language {
            components.queryItems!.append(URLQueryItem(name: TMDbAPI.Key.language, value: language))
        }
        
        if let country = country {
            components.queryItems!.append(URLQueryItem(name: TMDbAPI.Key.country, value: country))
        }
        
        if let region = region {
            components.queryItems!.append(URLQueryItem(name: TMDbAPI.Key.region, value: region))
        }
        
        if let page = self.page {
            components.queryItems!.append(URLQueryItem(name: TMDbAPI.Key.page, value: "\(page)"))
        }
        
        return components.url
    }
    
    init(apiKey: String, method: String) {
        var components = URLComponents()
        components.scheme = TMDbAPI.scheme
        components.host = TMDbAPI.host
        
        let apiKeyQueryItem = URLQueryItem(name: TMDbAPI.Key.apiKey, value: apiKey)
        components.queryItems = [apiKeyQueryItem]
        self.urlComponents = components
        
        self.method = method
    }
    
    mutating func addQueryItem(from queryMethods: [String]) {
        guard !queryMethods.isEmpty else { return }
        
        self.urlComponents.queryItems!.append(URLQueryItem(from: queryMethods))
    }
    
    mutating func addQueryItem(key: String, value: String) {
        let queryItem = URLQueryItem(name: key, value: value)
        self.urlComponents.queryItems!.append(queryItem)
    }
}

fileprivate extension URLQueryItem {
    init(from queryMethods: [String]) {
        let queryValue = queryMethods.joined(separator: ",")
        self.init(name: TMDbAPI.Key.appendToResponse, value: queryValue)
    }
}
