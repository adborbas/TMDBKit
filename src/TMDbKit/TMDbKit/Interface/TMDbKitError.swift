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

public enum TMDbKitError: Int, Error {
    case invalidApiKey = 7
    case failed = 15
    case resourceNotFound = 34
}

extension TMDbKitError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidApiKey:
            return "Invalid API key: You must be granted a valid key."
        case .failed:
            return "Failed."
        case .resourceNotFound:
            return "The resource you requested could not be found."
        }
    }
}

extension TMDbKitError: Decodable {
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let statusCode = try values.decode(Int.self, forKey: CodingKeys.statusCode)
        
        self = TMDbKitError(rawValue: statusCode) ?? .failed
    }
}
