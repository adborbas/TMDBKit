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

public class PageResult<Value>: Decodable where Value: Decodable {
    public internal(set) var results: [Value]
    public internal(set) var current: Int
    public let totalPages: Int
    public let totalResults: Int
    
    // TODO: why is this needed?
    fileprivate init() {
        self.results = [Value]()
        self.current = 1
        self.totalPages = 1
        self.totalResults = 1
    }
}

extension PageResult {
    enum CodingKeys: String, CodingKey {
        case results
        case current = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//public class TimeFramePageResult<Value: Decodable>: PageResult<Value> {
//    public let fromDate: Date
//    public let toDate: Date
//
//    // TODO: why is this needed?
//    private override init() {
//        super.init()
//        self.fromDate = Date()
//        self.toDate = Date()
//    }
//
//    required public init(from decoder: Decoder) throws {
//        try super.init(from: decoder)
//    }
//}

