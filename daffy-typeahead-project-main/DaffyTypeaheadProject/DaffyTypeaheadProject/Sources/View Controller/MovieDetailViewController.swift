//
//  MovieDetailViewController.swift
//  DaffyTypeaheadProject
//

import UIKit

/// View controller for the movie detail screen.
class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var posterImage: UIImage? {
        didSet {
            self.posterImageView.image = posterImage
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
        
    var movie: Movie?
    
    override func viewDidLoad() {
        titleLabel.text = movie?.title
        if let releaseDate = movie?.release_date {
            let releaseString = releaseDate == "" ? "unknown" : releaseDate
            yearLabel.text = "released: \(releaseString)"
        }
        descriptionLabel.text = movie?.overview
        activityIndicator.startAnimating()
    }
}
