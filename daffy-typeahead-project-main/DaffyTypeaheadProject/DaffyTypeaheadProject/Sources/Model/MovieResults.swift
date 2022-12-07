//
//  MovieResults.swift
//  DaffyTypeaheadProject
//

import Foundation

/// Object that stores properties of the movie results we get back from the API.
struct MovieResults: Codable {
    var page: Int
    var results: [Movie]
    var total_pages: Int
    var total_results: Int
}
