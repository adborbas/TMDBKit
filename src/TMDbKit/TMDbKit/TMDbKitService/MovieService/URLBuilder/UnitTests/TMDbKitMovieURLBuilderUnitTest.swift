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
import XCTest
@testable import TMDbKit

class TMDbKitMovieURLBuilderUnitTest: XCTestCase {
    private var movieUrlBuilder: TMDbKitMovieURLBuilder!
    private let apiKey = "APIKey"
    private let language = "en-US"
    private let movieId = 10
    
    override func setUp() {
        super.setUp()
        
        self.movieUrlBuilder = TMDbKitMovieURLBuilder(apiKey: "\(self.apiKey)", language: "\(self.language)")
    }
    
    func test_movieDetailURL() {
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)?api_key=\(self.apiKey)&language=\(self.language)")!
        let actualURL = self.movieUrlBuilder.movieDetailURL(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieCreditsURL() {
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/credits?api_key=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieCreditsURL(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieAlternativeTitlesURL() {
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/alternative_titles?api_key=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieAlternativeTitles(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieAlternativeTitlesURL_wihtCounty() {
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/alternative_titles?api_key=\(self.apiKey)&country=hu")!
        let actualURL = self.movieUrlBuilder.movieAlternativeTitles(for: self.movieId, country: "hu")
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieImagesTitlesURL() {
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/images?api_key=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieImages(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
}
