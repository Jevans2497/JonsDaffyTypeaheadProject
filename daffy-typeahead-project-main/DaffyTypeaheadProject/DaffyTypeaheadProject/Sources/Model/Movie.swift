//
//  Movie.swift
//  DaffyTypeaheadProject
//

import Foundation

/// Object that stores properties of an individual movie we get back from the API.
struct Movie: Codable {
    var adult: Bool
    var overview: String
    var release_date: String?
    var id: Int
    var original_title: String
    var original_language: String
    var title: String
    var popularity: Float
    var vote_count: Float
    var video: Bool
    var vote_average: Float
    var poster_path: String?
}


