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

import XCTest
@testable import TMDbKit

class MovieDetailIntegrationTest: TMDbKitServiceIntegrationTest {
    
    func test_movieDetail_existing_shouldSucceed() {
        let expectation = XCTestExpectation()
        self.service.movieDetail(for: TestConstants.Movie.existsingId) { (movie, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(movie)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TMDbKitServiceIntegrationTest.defaultTimeout)
    }
    
    func test_movieDetail_nonExisting_shouldReturnError() {
        let expectation = XCTestExpectation()
        self.service.movieDetail(for: TestConstants.Movie.notExistsingId) { (movie, error) in
            XCTAssertNotNil(error)
            if let error = error, case TMDbKitError.resourceNotFound = error {} else {
                XCTFail("Expected resourceNotFound error but got: \(String(describing: error?.localizedDescription))")
            }
            XCTAssertNil(movie)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TMDbKitServiceIntegrationTest.defaultTimeout)
    }
    
    func test_movieDetail_appendingCredits_shouldSucceed() {
        let expectation = XCTestExpectation()
        self.service.movieDetail(for: TestConstants.Movie.existsingId, appending: [.credits]) { (movie, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(movie)
            if let movie = movie {
                XCTAssertNotNil(movie.credits)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TMDbKitServiceIntegrationTest.defaultTimeout)
    }
}
