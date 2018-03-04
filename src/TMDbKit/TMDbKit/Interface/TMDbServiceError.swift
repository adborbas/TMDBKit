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

public enum TMDbServiceError: Int, Error {
    case invalidSerice = 2
    case invalidFormat = 4
    case invalidParameters = 5
    case invalidId = 6
    case invalidAPIKey = 7
    case serviceOffline = 9
    case suspendedAPIKey = 10
    case internalError = 11
    case failed = 15
    case backendServerTimedOut = 24
    case requestCountLimitReached = 25
    case tooManyAppendedResponse = 27
    case resourceNotFound = 34
}

extension TMDbServiceError: LocalizedError {
    
    private static let statusMessages: [TMDbServiceError: String] = [
        .invalidSerice: "Invalid service: this service does not exist.",
        .invalidFormat:"Invalid format: This service doesn't exist in that format.",
        .invalidParameters: "Invalid parameters: Your request parameters are incorrect.",
        .invalidId: "Invalid id: The pre-requisite id is invalid or not found.",
        .invalidAPIKey: "Invalid API key: You must be granted a valid key.",
        .serviceOffline: "Service offline: This service is temporarily offline, try again later.",
        .suspendedAPIKey: "Suspended API key: Access to your account has been suspended, contact TMDb.",
        .internalError: "Internal error: Something went wrong, contact TMDb.",
        .failed: "Failed.",
        .backendServerTimedOut: "Your request to the backend server timed out. Try again.",
        .requestCountLimitReached: "Your request count (#) is over the allowed limit of (40).",
        .tooManyAppendedResponse: "Too many append to response objects: The maximum number of remote calls is 20.",
        .resourceNotFound: "The resource you requested could not be found."
    ]
    
    var localizedDescription: String {
        return TMDbServiceError.statusMessages[self] ?? "Failed."
    }
}

extension TMDbServiceError: Decodable {
    private enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let statusCode = try values.decode(Int.self, forKey: CodingKeys.statusCode)
        
        self = TMDbServiceError(rawValue: statusCode) ?? .failed
    }
}
