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

class MovieDetailIntegrationTest: TMDbKitMovieServiceIntegrationTest {
    
    func test_invalidApiKey_shouldReturnError() {
        let invalidApiKeyService = TMDbKitMovieService(config: TestConstants.ServiceConfig.invalidAPIKey)

        let expectation = XCTestExpectation()
        _ = invalidApiKeyService.movieDetail(for: TestConstants.Movie.notExistsingId) { result in
            switch result {
            case .failure(let error):
                if case TMDbServiceError.failureFromService(.invalidAPIKey) = error {
                    XCTAssertEqual(error.localizedDescription, "Invalid API key: You must be granted a valid key.")
                } else {
                    XCTFail("Expected invalidApiKey error but got: \(error.localizedDescription))")
                }
            case .success:
                XCTFail("Requesting movie details with invalid apiKey should have failed.")
            }
            expectation.fulfill()
        }
    }
    
    func test_movieDetail_existing_shouldSucceed() {
        let expectation = XCTestExpectation()
        _ = _ = self.service.movieDetail(for: TestConstants.Movie.existsingId) { result in
            switch result {
            case .failure(let error):
                XCTFail("Requesting details for an existing movie should not fail: \(error.localizedDescription)")
            case .success:
                break
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_movieDetail_nonExisting_shouldReturnError() {
        let expectation = XCTestExpectation()
        _ = _ = self.service.movieDetail(for: TestConstants.Movie.notExistsingId) { result in
            
            switch result {
            case .failure(let error):
                if case TMDbServiceError.failureFromService(.resourceNotFound) = error {} else {
                    XCTFail("Expected resourceNotFound error but got: \(error.localizedDescription)")
                }
            case .success:
                XCTFail("Requesting details for a nonExisting movie should have failed")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_movieDetail_appendingCreditsImagesAlternativeTitles_shouldSucceed() {
        let expectation = XCTestExpectation()
        _ = _ = self.service.movieDetail(for: TestConstants.Movie.existsingId, appending: [.credits, .images, .alternativeTitles]) { result in
            switch result {
            case .failure(let error):
                XCTFail("Request movie details with credentials should not fail: \(error.localizedDescription)")
            case .success(let movie):
                XCTAssertNotNil(movie.credits, "Request movie details with credentials should return credentials.")
                XCTAssertNotNil(movie.images, "Request movie details with images should return credentials.")
                XCTAssertNotNil(movie.alternativeTitles, "Request movie details with alternative titles should return credentials.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }

}
