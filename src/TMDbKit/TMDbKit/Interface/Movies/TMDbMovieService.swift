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


public protocol TMDbMovieService {
    func detail(for movieId: Int,
                     language: String?,
                     appending: [TMDbMovieServiceQueryMethod],
                     completionHandler: @escaping (TMDbServiceResult<Movie>) -> Void) -> Operation
    
    func credits(for movieId: Int,
                      completionHandler: @escaping (TMDbServiceResult<MovieCredits>) -> Void) -> Operation
    
    func alternativeTitles(for movieId: Int,
                                country: String?,
                                completionHandler: @escaping (TMDbServiceResult<[AlternativeTitle]>) -> Void) -> Operation
    
    func images(for movieId: Int,
                     completionHandler: @escaping (TMDbServiceResult<Images>) -> Void) -> Operation
    
    func nowPlaying(language: String?,
                    page: Int?,
                    region: String?,
                    completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation
    
    func popular(language: String?,
                    page: Int?,
                    region: String?,
                    completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation
    
    func releaseDates(for movieId: Int,
                      completionHandler: @escaping (TMDbServiceResult<[Release]>) -> Void) -> Operation
    
    func recommendations(for movieId: Int,
                         language: String?,
                         page: Int?,
                         completionHandler: @escaping (TMDbServiceResult<Page<MovieInfo>>) -> Void) -> Operation
    
    func lists(for movieId: Int,
                         language: String?,
                         page: Int?,
                         completionHandler: @escaping (TMDbServiceResult<Page<MovieList>>) -> Void) -> Operation
}
