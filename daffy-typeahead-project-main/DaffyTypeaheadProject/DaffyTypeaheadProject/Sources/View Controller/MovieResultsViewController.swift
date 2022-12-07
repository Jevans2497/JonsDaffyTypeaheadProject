//
//  MovieResultsViewController.swift
//  DaffyTypeaheadProject
//

import UIKit
import TMDb

/// View controller for the movie results screen.
class MovieResultsViewController: UIViewController, MovieResultsViewModelDelegate {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer: Timer?
    
    var viewModel = MovieResultsViewModel()
    
    override func viewDidLoad() {
        viewModel.delegate = self
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func movieResultsUpdated() {
        DispatchQueue.main.async {
            self.viewModel.movieResults == nil ? self.resetViewForEmptyMovieResults() : self.resetViewForNewMovieResults()
        }
    }
    
    func movieResultsReturnedWithError() {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.tableview.reloadData()
        }
    }
    
    private func resetViewForEmptyMovieResults() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.tableview.reloadData()
    }
    
    private func resetViewForNewMovieResults() {
        self.errorLabel.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.tableview.reloadData()
    }
}

extension MovieResultsViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange() {
        timer?.invalidate()
        viewModel.cancelCurrentImageRequests()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(loadNewQuery), userInfo: nil, repeats: false)
    }
    
    @objc func loadNewQuery() {
        let text = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        self.viewModel.movieResults = nil
        self.viewModel.loadMovies(for: text)
    }
}

extension MovieResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieResults?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath as IndexPath) as! MovieTableViewCell
        guard let movieResults = viewModel.movieResults, indexPath.row < movieResults.results.count else { return MovieTableViewCell() }
        let movie = movieResults.results[indexPath.row]
        
        //Set labels
        cell.titleLabel.text = movie.title
        let releaseDate = movie.release_date?.isolateYearFromReleaseDate() ?? ""
        cell.releaseYearLabel.text = releaseDate
        cell.descriptionLabel.text = movie.overview == "" ? "No description" : movie.overview
        
        //Retrieve and set the poster image. If the movie has no image, set the "noImage" asset as the image
        if let safePosterPath = movie.poster_path {
            setPosterImageOnCell(cell: cell, posterPath: safePosterPath)
        } else {
            cell.posterImageView.image = UIImage(named: "noImage")
            cell.imageWasSet()
        }
        
        return cell
    }
    
    private func setPosterImageOnCell(cell: MovieTableViewCell, posterPath: String) {
        self.viewModel.loadPosterImage(posterPath: posterPath, imageSize: .w92, completion: { image in
            DispatchQueue.main.async {
                if image != nil {
                    cell.posterImageView.image = image
                    cell.imageWasSet()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetail") as? MovieDetailViewController else { return }
        
        let movie = viewModel.movieResults?.results[indexPath.row]
        movieDetailVC.movie = movie
        self.present(movieDetailVC, animated: true)
        
        //Set image after presenting, otherwise posterImageView may be nil
        if let posterPath = movie?.poster_path {
            viewModel.loadPosterImage(posterPath: posterPath, imageSize: .w300) { image in
                DispatchQueue.main.async {
                    movieDetailVC.posterImage = image
                }
            }
        } else {
            movieDetailVC.posterImage = UIImage(named: "noImage")
        }
    }
}
