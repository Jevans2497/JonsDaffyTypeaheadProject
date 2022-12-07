//
//  MovieAPI.swift
//  DaffyTypeaheadProject
//

import Foundation

/// Protocol that designates properties relevant to API endpoints.
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
}

/// API details for the Movie Database.
class MovieAPI: Endpoint {
    
    static let apiKey = "37810fe853d404bfd1382b4420d16a37"
    var pathOption: PathOption?
    var query: String?

    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

    var path: String {
        switch pathOption {
        case .search:
            guard let safeQuery = query else { fatalError("Query was nil in MovieAPI") }
            return "search/movie?api_key=\(MovieAPI.apiKey)&query=\(safeQuery)"
        case .popular:
            return "movie/popular?api_key=\(MovieAPI.apiKey)&language=en-US&page=1"
        case .none:
            fatalError("Failed to set pathOption in MovieAPI")
        }
    }

    var url: URL? {
        let urlString = baseURL + path
        guard let safeURL = URL(string: urlString) else {
            return nil
        }
        return safeURL
    }
}

enum PathOption {
    case search, popular
}













//Search example:
//https://api.themoviedb.org/3/search/movie?api_key=37810fe853d404bfd1382b4420d16a37&query=Jack+Reacher

//Query example
//https://api.themoviedb.org/3/movie/{343611/ID}?api_key=37810fe853d404bfd1382b4420d16a37

//Popular example
//https://api.themoviedb.org/3/movie/popular?api_key=37810fe853d404bfd1382b4420d16a37&language=en-US&page=1

//Get image: (last part is poster path https://image.tmdb.org/t/p/w92/bvYjhsbxOBwpm8xLE5BhdA3a8CZ.jpg


