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

class TMDbKitServiceIntegrationTest: XCTestCase {
    static let defaultTimeout: TimeInterval = 30
    var service: TMDbKitService!
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        
        self.service = TMDbKitService(config: TestConstants.ServiceConfig.validAPIKey)
    }
    
    func test_invalidApiKey_shouldReturnError() {
        let invalidApiKeyService = TMDbKitService(config: TestConstants.ServiceConfig.invalidAPIKey)
        
        let expectation = XCTestExpectation()
        invalidApiKeyService.movieDetail(for: TestConstants.Movie.notExistsingId) { (movie, error) in
            XCTAssertNotNil(error)
            if let error = error, case TMDbKitError.invalidApiKey = error {} else {
                XCTFail("Expected invalidApiKey error but got: \(String(describing: error?.localizedDescription))")
            }
            XCTAssertNil(movie)
            expectation.fulfill()
        }
    }
}
