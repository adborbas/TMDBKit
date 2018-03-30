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
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let apiKeyPath = "api_key"
    
    override func setUp() {
        super.setUp()
        
        self.movieUrlBuilder = TMDbKitMovieURLBuilder(apiKey: "\(self.apiKey)")
    }
    
    // MARK: - movieDetail
    func test_movieDetailURL() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)?\(self.apiKeyPath)=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieDetailURL(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieDetailURL_withLanguage() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)?\(self.apiKeyPath)=\(self.apiKey)&language=\(self.language)")!
        let actualURL = self.movieUrlBuilder.movieDetailURL(for: self.movieId, language: self.language)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - movieCredits
    func test_movieCreditsURL() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/credits?\(self.apiKeyPath)=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieCreditsURL(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - movieAlternativeTitles
    func test_movieAlternativeTitlesURL() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/alternative_titles?\(self.apiKeyPath)=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieAlternativeTitles(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieAlternativeTitlesURL_wihtCounty() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/alternative_titles?\(self.apiKeyPath)=\(self.apiKey)&country=hu")!
        let actualURL = self.movieUrlBuilder.movieAlternativeTitles(for: self.movieId, country: "hu")
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - movieImage
    func test_movieImagesURL() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/images?\(self.apiKeyPath)=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.movieImages(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - nowPlaying
    func test_nowPlaying_defautl() {
        let expectedURL = URL(string: "\(self.baseURL)now_playing?\(self.apiKeyPath)=\(self.apiKey)&page=1")!
        let actualURL = self.movieUrlBuilder.nowPlaying(language: nil, page: 1, region: nil)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_nowPlaying_full() {
        let expectedURL = URL(string: "\(self.baseURL)now_playing?\(self.apiKeyPath)=\(self.apiKey)&region=HU&language=hu&page=1")!
        let actualURL = self.movieUrlBuilder.nowPlaying(language: "hu", page: 1, region: "HU")
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - releaseDates
    func test_releaseDates() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/release_dates?\(self.apiKeyPath)=\(self.apiKey)")!
        let actualURL = self.movieUrlBuilder.releaseDates(for: self.movieId)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    // MARK: - recommendations
    func test_recommendations() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/recommendations?\(self.apiKeyPath)=\(self.apiKey)&page=1")!
        let actualURL = self.movieUrlBuilder.recommendations(for: self.movieId, language: nil, page: 1)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_recommendations_full() {
        let expectedURL = URL(string: "\(self.baseURL)\(self.movieId)/recommendations?\(self.apiKeyPath)=\(self.apiKey)&language=hu&page=100")!
        let actualURL = self.movieUrlBuilder.recommendations(for: self.movieId, language: "hu", page: 100)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
}
