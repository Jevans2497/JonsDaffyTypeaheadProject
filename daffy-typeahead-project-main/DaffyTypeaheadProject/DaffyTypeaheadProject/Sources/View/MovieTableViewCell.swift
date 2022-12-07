//
//  MovieResultsTableViewCell.swift
//  DaffyTypeaheadProject
//

import UIKit

/// Custom cell class for the movie table view.
class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterImageViewLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    override func prepareForReuse() {
        posterImageView.image = nil
        posterImageViewLoadingIndicator.startAnimating()
        posterImageViewLoadingIndicator.isHidden = false
    }
    
    func imageWasSet() {
        posterImageViewLoadingIndicator.stopAnimating()
        posterImageViewLoadingIndicator.isHidden = true
    }
}
