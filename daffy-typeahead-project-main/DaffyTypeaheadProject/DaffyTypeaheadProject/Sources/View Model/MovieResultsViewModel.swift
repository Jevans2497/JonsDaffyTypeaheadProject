//
//  MovieResultsViewModel.swift
//  DaffyTypeaheadProject
//

import Foundation
import UIKit

/// View model for the movie results screen.
class MovieResultsViewModel {
        
    private let movieDataProvider = MovieDataProvider()
    private let imageLoader = ImageLoader()
    var delegate: MovieResultsViewModelDelegate?
    
    var movieResults: MovieResults? {
        didSet {
            delegate?.movieResultsUpdated()
        }
    }

    init() {
        loadDefaultMovieResults()
    }
    
    private func loadDefaultMovieResults() {
        movieDataProvider.loadPopularMovies { movieResultsResponse, error in
            guard error == nil else {
                self.movieResults = nil
                self.delegate?.movieResultsReturnedWithError()
                return
            }
            self.movieResults = movieResultsResponse
        }
    }
    
    func loadMovies(for query: String) {
        if query == "" { //When the textfield is empty, show default movie list
            loadDefaultMovieResults()
        } else {
            movieDataProvider.loadMovies(query: query) { movieResults, error in
                guard error == nil else {
                    self.movieResults = nil
                    self.delegate?.movieResultsReturnedWithError()
                    return
                }
                self.movieResults = movieResults
            }
        }
    }
    
    func loadPosterImage(posterPath: String, imageSize: ImageLoader.ImageSize, completion: @escaping (UIImage?) -> ()) {
        imageLoader.loadMovieImage(posterPath: posterPath, imageSize: imageSize) { image in
            completion(image)
        }
    }
    
    func cancelCurrentImageRequests() {
        imageLoader.cancelAllCurrentTasks()
    }
}

protocol MovieResultsViewModelDelegate {
    func movieResultsUpdated()
    func movieResultsReturnedWithError()
}
