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
import Alamofire

public protocol TMDBService {
    func movieDetail(for movieId: Int, completionHandler: @escaping (Movie?, Error?) -> ())
}

public class TMDBKitService: TMDBService {
    private static let baseURL = "https://api.themoviedb.org/3"

    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func movieDetail(for movieId: Int, completionHandler: @escaping (Movie?, Error?) -> ()) {
        let url = URL(string: "\(TMDBKitService.baseURL)/movie/\(movieId)?api_key=\(self.apiKey)")!
        Alamofire.request(url).responseString { response in
            guard let data = response.result.value?.data(using: .utf8) else {
                completionHandler(nil, nil)
                return
            }
            
            let detail: Movie
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Short)
                detail = try decoder.decode(Movie.self, from: data)
            } catch {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(detail, nil)
        }
    }


}

extension DateFormatter {
    static let iso8601Short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

