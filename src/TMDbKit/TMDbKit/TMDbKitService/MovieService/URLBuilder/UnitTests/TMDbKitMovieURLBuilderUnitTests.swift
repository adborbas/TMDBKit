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

class TMDbKitMovieURLBuilderUnitTests: XCTestCase {
    func test_movieDetailURL() {
        let urlBuilder = TMDbKitMovieURLBuilder(apiKey: "API_KEY", language: "de")
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/10?api_key=API_KEY&language=de")!
        let actualURL = urlBuilder.movieDetailURL(for: 10)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_movieCreditsURL() {
        let urlBuilder = TMDbKitMovieURLBuilder(apiKey: "API_KEY", language: "en-US")
        let expectedURL = URL(string: "https://api.themoviedb.org/3/movie/10/credits?api_key=API_KEY&language=en-US")!
        let actualURL = urlBuilder.movieCreditsURL(for: 10)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
}
