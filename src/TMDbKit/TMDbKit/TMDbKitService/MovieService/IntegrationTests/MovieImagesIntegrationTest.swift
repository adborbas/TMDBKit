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
import TMDbKit

class MovieImagesIntegrationTest: TMDbKitMovieServiceIntegrationTest {
    
    func test_movieImages_existing_shouldSucceed() {
        let expectation = XCTestExpectation()
        _ = self.service.movieImages(for: TestConstants.Movie.existsingId) { result in
            switch result {
            case .failure(let error):
                XCTFail("Requesting movie images for existing movie should not fail: \(error.localizedDescription)")
            case .success(let images):
                XCTAssertTrue(images.backdrops.count > 0)
                XCTAssertTrue(images.posters.count > 0)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_movieImages_nonExisting_shouldReturnError() {
        let expectation = XCTestExpectation()
        _ = self.service.movieImages(for: TestConstants.Movie.notExistsingId) { result in
            switch result {
            case .failure(let error):
                if case TMDbServiceError.failureFromService(.resourceNotFound) = error {} else {
                    XCTFail("Expected resourceNotFound error but got: \(String(describing: error.localizedDescription))")
                }
            case .success:
                XCTFail("Expected resourceNotFound error ")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_movieDetail_appendingImages_shouldSucceed() {
        let expectation = XCTestExpectation()
        _ = self.service.movieDetail(for: TestConstants.Movie.existsingId, appending: [.images]) { result in
            switch result {
            case .failure(let error):
                XCTFail("Request movie details with images should not fail: \(error.localizedDescription)")
            case .success(let movie):
                XCTAssertNotNil(movie.backdrops, "Request movie details with images should return backdrops.")
                XCTAssertNotNil(movie.posters, "Request movie details with images should return posters.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
}

