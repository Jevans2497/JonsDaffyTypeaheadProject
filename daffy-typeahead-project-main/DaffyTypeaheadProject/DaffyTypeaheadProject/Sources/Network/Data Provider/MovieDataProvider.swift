//
//  MovieDataProvider.swift
//  DaffyTypeaheadProject
//

import Foundation
import UIKit

/// Movie data provider, responsible for setting up and kicking off requests to the API.
class MovieDataProvider {

    let movieAPI = MovieAPI()
    let decoder = JSONDecoder()
    
    func loadPopularMovies(completion: @escaping (MovieResults?, Error?) -> Void) {
        movieAPI.pathOption = .popular
        if let url = movieAPI.url {
            loadAndDecode(url: url) { movieResults, error in
                if error != nil {
                    error?.displayError()
                }
                completion(movieResults, error)
            }
        }
    }
    
    func loadMovies(query: String, completion: @escaping (MovieResults?, Error?) -> Void) {
        movieAPI.pathOption = .search
        movieAPI.query = query
        if let url = movieAPI.url {
            loadAndDecode(url: url) { movieResults, error in
                if error != nil {
                    error?.displayError()
                }
                completion(movieResults, error)
            }
        }
    }
    
    private func loadAndDecode<D: Decodable>(url: URL, completion: @escaping (D?, MovieError?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil, MovieError(movieErrorType: .apiError, error: error))
                return
            }
            
            guard let data = data else {
                completion(nil, MovieError(movieErrorType: .noData, error: error))
                return
            }
            
            do {
                let decoded = try self.decoder.decode(D.self, from: data)
                    completion(decoded, nil)
            } catch {
                completion(nil, MovieError(movieErrorType: .decoderError, error: error))
            }
        }.resume()
    }
}

struct MovieError: Error {
    var movieErrorType: MovieErrorType
    var error: Error?
    
    func displayError() {
        print("\(movieErrorType.description): \n\(error.debugDescription)")
    }
}

enum MovieErrorType: Error {
    case apiError, noData, decoderError

    var description: String {
        switch self {
        case .apiError:
            return "API sent back an error"
        case .noData:
            return "No data was found"
        case .decoderError:
            return "Decoder failed to properly decode"
        }
    }
}
