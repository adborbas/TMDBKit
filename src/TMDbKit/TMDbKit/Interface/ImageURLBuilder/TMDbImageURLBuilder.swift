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

public class TMDdImageURLBuilder {
    
    public enum Size { } // Only placeholder
    
    public enum Scheme: String {
        case secure = "https://image.tmdb.org/t/p"
        case nonSecure = "http://image.tmdb.org/t/p"
    }
    
    public static let secure = TMDdImageURLBuilder(scheme: .secure)
    public static let nonSecure = TMDdImageURLBuilder(scheme: .nonSecure)
    
    private let baseURL: URL
    
    private init(scheme: Scheme) {
        self.baseURL = URL(string: scheme.rawValue)!
    }
    
    fileprivate func imageURL(size: String, filePath: String) -> URL {
        return self.baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
    }
}

// MARK: - Backdrop
extension TMDdImageURLBuilder.Size {
    public enum Backdrop: String {
        case w300
        case w780
        case w1280
        case original
    }
}

extension TMDdImageURLBuilder {
    public func backdropURL(_ filePath: String, size: Size.Backdrop = .original) -> URL {
        return self.imageURL(size: size.rawValue, filePath: filePath)
    }
}

// MARK: - Poster
extension TMDdImageURLBuilder.Size {
    public enum Poster: String {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
        case original
    }
}

extension TMDdImageURLBuilder {
    public func posterURL(_ filePath: String, size: Size.Poster = .original) -> URL {
        return self.imageURL(size: size.rawValue, filePath: filePath)
    }
}
