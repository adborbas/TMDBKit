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

class ReleaseDatesIntegrationTest: TMDbKitMovieServiceIntegrationTest {
    func test_releaseDates_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.releaseDates(for: TestConstants.Movie.existsingId) { result in
            switch result {
            case .failure(let error):
                XCTFail("Requesting release dates for existing movie should not fail: \(error.localizedDescription)")
            case .success(let releases):
                XCTAssertFalse(releases.isEmpty, "Movie should have been release at least once")
                XCTAssertFalse(releases[0].releaseDates.isEmpty, "Movie should have been release at least once")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
}
