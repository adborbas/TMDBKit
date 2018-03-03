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

public struct Movie: Decodable {
    public let adult: Bool
    public let backdropPath: String
    public let collection: CollectionInfo?
    public let budget: Int
    public let genres: [GenreInfo]
    public let homepage: URL?
    public let id: Int
    public let imdbId: String?
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String?
    public let popularity: Double
    public let posterPath: String?
    public let productionCompanies: [CompanyInfo]
    public let productionCountries: [CountryInfo]
    public let releaseDate: Date
    public let revenue: Int
    public let runtime: Int?
    public let spokenLanguages: [LanguageInfo]
    public let status: Status
    public let tagline: String?
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int
    
    // QueryMethos
    public let credits: MovieCredits?
    public let alternativeTitles: [AlternativeTitle]?
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case collection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
        // QueryMethos
        case credits
        case alternativeTitles = "alternative_titles"
    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.adult = try values.decode(Bool.self, forKey: .adult)
//        self.backdropPath = try values.decode(String.self, forKey: .backdropPath)
//        self.collection = try values.decode(CollectionInfo.self, forKey: .collection)
//        self.budget = try values.decode(Int.self, forKey: .budget)
//        self.genres = try values.decode(GenreInfo.self, forKey: .genres)
//        self.homepage = try values.decode(URL.self, forKey: .homepage)
//        self.id = try values.decode(Int.self, forKey: .id)
//        self.imdbId = try values.decode(String.self, forKey: .imdbId)
//        self.originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
//        self.originalTitle = try values.decode(String.self, forKey: .originalTitle)
//        self.overview = try values.decode(String.self, forKey: .overview)
//        self.popularity = try values.decode(Double.self, forKey: .popularity)
//        self.posterPath = try values.decode(String.self, forKey: .posterPath)
//        self.productionCompanies = try values.decode(CompanyInfo.self, forKey: .productionCompanies)
//        self.productionCountries = try values.decode(CountryInfo.self, forKey: .productionCountries)
//        self.releaseDate = try values.decode(Date.self, forKey: .releaseDate)
//        self.revenue = try values.decode(Int.self, forKey: .revenue)
//        self.runtime = try values.decode(Int.self, forKey: .runtime)
//        self.spokenLanguages = try values.decode(LanguageInfo.self, forKey: .spokenLanguages)
//        self.status = try values.decode(Status.self, forKey: .status)
//        self.tagline = try values.decode(String.self, forKey: .tagline)
//        self.title = try values.decode(String.self, forKey: .title)
//        self.video = try values.decode(Bool.self, forKey: .video)
//        self.voteAverage = try values.decode(Double.self, forKey: .voteAverage)
//        self.voteCount = try values.decode(Int.self, forKey: .voteCount)
//        self.credits = try values.decode(MovieCredits.self, forKey: .credits)
//        self.alternativeTitles = try values.decode(AlternativeTitle.self, forKey: .alternativeTitles)
//
//    }
}
