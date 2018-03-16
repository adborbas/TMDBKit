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
import TMDbKit

class TMDbKitImageURLBuilderUnitTest: XCTestCase {
    private var imageURLBuilder: TMDdImageURLBuilder!
    private let filePath = "/veryniceImage.jpg"
    private let baseURL = URL(string: "https://image.tmdb.org/t/p/")!
    
    override func setUp() {
        super.setUp()
        
        self.imageURLBuilder = TMDdImageURLBuilder.secure
    }
    
    // MARK: - backdropURL
    func test_backdropURL_defaultShouldBeOriginal() {
        let expectedURL = baseURL.appendingPathComponent("original").appendingPathComponent(self.filePath)
        let actualURL = self.imageURLBuilder.backdropURL(self.filePath)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_backdropURL_w300() {
        let expectedURL = baseURL.appendingPathComponent("w300").appendingPathComponent(self.filePath)
        let actualURL = self.imageURLBuilder.backdropURL(self.filePath, size: .w300)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_backdropURL_emptyFilePath() {
        let expectedURL = baseURL.appendingPathComponent("original").appendingPathComponent("")
        let actualURL = self.imageURLBuilder.backdropURL("")
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
     // MARK: - posterURL
    func test_posterURL_defaultShouldBeOriginal() {
        let expectedURL = baseURL.appendingPathComponent("original").appendingPathComponent(self.filePath)
        let actualURL = self.imageURLBuilder.posterURL(self.filePath)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
    
    func test_posterURL_w500() {
        let expectedURL = baseURL.appendingPathComponent("w500").appendingPathComponent(self.filePath)
        let actualURL = self.imageURLBuilder.posterURL(self.filePath, size: .w500)
        
        XCTAssertEqual(expectedURL, actualURL)
    }
}
