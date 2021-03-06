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

class PagingIntegrationTest: TMDbKitMovieServiceIntegrationTest {
    
    // MARK: - Tests
    func test_nowPlaying_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.nowPlaying() { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_popular_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.popular() { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_topRated_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.topRated() { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_upcoming_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.upcoming() { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_recommendations_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.recommendations(for: TestConstants.Movie.existsingId) { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
    
    func test_lists_defaultReturnsFirstPage() {
        let expectation = XCTestExpectation()
        _ = self.service.lists(for: TestConstants.Movie.existsingId) { result in
            XCTAssertNonEmptyFirstPageResult(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: defaultTimeout)
    }
}

// MARK: - Private functions
private func XCTAssertNonEmptyFirstPageResult<Element>(_ result: TMDbServiceResult<Page<Element>>) {
    switch result {
    case .failure(let error):
        XCTFail("Requesting lists should not fail: \(error.localizedDescription)")
    case .success(let page):
        XCTAssertEqual(page.current, 1)
        XCTAssertTrue(page.results.count > 0)
        XCTAssertTrue(page.totalPages > 0)
        XCTAssertTrue(page.totalResults > page.totalPages)
    }
}
