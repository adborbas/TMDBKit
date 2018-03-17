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

class TMDbServiceResponseDecoderUnitTests: XCTestCase {
    private var decoder: TMDbServiceResponseDecoder<MockJSON>!
    private var jsonData: Data!
    private var invalidJsonData: Data = {
        return "this is an invalid json".data(using: .utf8)!
    }()
    
    override func setUp() {
        self.decoder = TMDbServiceResponseDecoder<MockJSON>()
        self.jsonData = try! JSONEncoder().encode(MockJSON())
    }
    
    func test_process_validKeyPath_shouldSucceed() {
        do {
            let validKeyPathDecoder = TMDbServiceResponseDecoder<MockJSON>(keyPath: "result")
            _ = try validKeyPathDecoder.process(self.jsonData, nil, nil)
        } catch {
            XCTFail(unexpected: error)
        }
    }
    
    func test_process_invalidKeyPath_shouldThrowError() {
        let invalidKeyPath = "invalidKeyPath"
        do {
            let invalidKeyPathDecoder = TMDbServiceResponseDecoder<MockJSON>(keyPath: invalidKeyPath)
            _ = try invalidKeyPathDecoder.process(self.jsonData, nil, nil)
            XCTFail("Should have thrown error.")
        } catch TMDbServiceError.failedToParse(.jsonForKeyPathNotFound(let keypath)){
            XCTAssertEqual(keypath, invalidKeyPath)
        } catch {
            XCTFail("Expected jsonForKeyPathNotFound but got: \(error.localizedDescription)")
        }
    }

    func test_process_validJsonData_shoudSucceed() {
        do {
            _ = try self.decoder.process(self.jsonData, nil, nil)
        } catch {
            XCTFail(unexpected: error)
        }
    }

    func test_performDecoding_invalidJsonData_expectError() {
        do {
            _ = try self.decoder.process(self.invalidJsonData, nil, nil)
            XCTFail("Should have thrown error.")
        } catch {
            // We got the expected error.
        }
    }

    func test_process_notNilError_expectNetworkError() {
        do {
            _ = try self.decoder.process(nil, nil, SomeError.some)
        } catch TMDbServiceError.networkError {
            // This is the expected error
        } catch {
            XCTFail("Expected networkError but got: \(error.localizedDescription)")
        }
    }

    func test_process_notData_expectNoDataInResponse() {
        do {
            _ = try self.decoder.process(nil, nil, nil)
        } catch {
            switch error {
            case TMDbServiceError.noDataInResponse:
                // This is the expected error.
                break
            default:
                XCTFail("Expected noDataInResponse but got: \(error.localizedDescription)")
            }
        }
    }

    func test_process_tmdbError_expectFailureFromService() {
        let tmdbError = """
        {
            "status_message": "The resource you requested could not be found.",
            "status_code": 34
        }
        """.data(using: .utf8)!

        do {
            _ = try self.decoder.process(tmdbError, nil, nil)
        } catch {
            switch error {
            case TMDbServiceError.failureFromService(let reason):
                XCTAssertEqual(error.localizedDescription, reason.description)
            default:
                XCTFail("Expected failureFromService but got: \(error.localizedDescription)")
            }
        }
    }
}
