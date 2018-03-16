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

class TMBdKitServiceOperationUnitTests: XCTestCase {
    private var operation: TMDbKitServiceOperation<MockJSON>!
    private let mockCompletionHandler: (TMDbServiceResult<MockJSON>) -> Void = { result in }
    private var jsonData: Data!
    private var invalidJsonData: Data = {
        return "this is an invalid json".data(using: .utf8)!
    }()
    
    override func setUp() {
        self.operation = TMDbKitServiceOperation(url: URL(string: "http://host.com")!, completionHandler: self.mockCompletionHandler)
        self.jsonData = try! JSONEncoder().encode(MockJSON())
    }
    
    // MARK: - extractJSON
    func test_extractJSON_validKeyPath_shouldSucceed() {
        do {
            _ = try self.operation.extractJSON(at: "result", from: self.jsonData)
        } catch {
            XCTFail(unexpected: error)
        }
    }
    
    func test_extractJSON_invalidKeyPath_shouldThrowError() {
        let invalidKeyPath = "invalidKeyPath"
        do {
            _ = try self.operation.extractJSON(at: invalidKeyPath, from: self.jsonData)
            XCTFail("Should have thrown error.")
        } catch TMDbServiceError.failedToParse(.jsonForKeyPathNotFound(let keypath)){
            XCTAssertEqual(keypath, invalidKeyPath)
        } catch {
            XCTFail("Expected jsonForKeyPathNotFound but got: \(error.localizedDescription)")
        }
    }
    
    // MARK: - performDecoding
    func test_performDecoding_validJsonData_shoudSucceed() {
        do {
            _ = try self.operation.performDecoding(on: self.jsonData, keyPath: nil)
        } catch {
            XCTFail(unexpected: error)
        }
    }
    
    func test_performDecoding_invalidJsonData_expectError() {
        do {
            _ = try self.operation.performDecoding(on: self.invalidJsonData, keyPath: nil)
            XCTFail("Should have thrown error.")
        } catch {
            // We got the expected error.
        }
    }
    
    // MARK: - process
    func test_process_notNilError_expectNetworkError() {
        do {
            _ = try self.operation.process(nil, nil, SomeError.some)
        } catch TMDbServiceError.networkError(let error) {
            XCTAssertEqual(error.localizedDescription, "Some error.")
        } catch {
            XCTFail("Expected networkError but got: \(error.localizedDescription)")
        }
    }
    
    func test_process_notData_expectNoDataInResponse() {
        do {
            _ = try self.operation.process(nil, nil, nil)
        } catch {
            switch error {
            case TMDbServiceError.noDataInResponse:
                XCTAssertEqual(error.localizedDescription, "Service returned no data.")
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
            _ = try self.operation.process(tmdbError, nil, nil)
        } catch {
            switch error {
            case TMDbServiceError.failureFromService(let reason):
                XCTAssertEqual(error.localizedDescription, reason.description)
            default:
                XCTFail("Expected failureFromService but got: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - cancellation
    func test_cancel_completionHandlerIsNotCalled() {
        let semaphore = DispatchSemaphore(value: 0)
        let operation = TMDbKitServiceOperation(url: URL(string: "http://host.com")!) { (result: TMDbServiceResult<MockJSON>) in
            XCTFail("completionHandler should not be called")
            semaphore.signal()
        }
        operation.cancel()
        OperationQueue().addOperation(operation)
        let timeoutResult = semaphore.wait(timeout: DispatchTime.now() + 0.1)
        XCTAssertEqual(timeoutResult, DispatchTimeoutResult.timedOut)
    }
}

// MARK: - MockJSON
fileprivate struct MockJSON: Codable {
    let vote: Int = 1
    let result: MockJSONResult = MockJSONResult()
}

fileprivate struct MockJSONResult: Codable {
    let id: Int = 1
}

// MARK: - SomeError
fileprivate enum SomeError: Error, LocalizedError {
    case some
    
    var errorDescription: String? {
        switch self {
        case .some:
            return "Some error."
        }
    }
}
