//
//  ImageLoader.swift
//  DaffyTypeaheadProject
//
//  Created by Jon Evans on 12/5/22.
//

import Foundation
import UIKit

class ImageLoader {
    
    var currentTasks = [String:URLSessionDataTask]()
    
    func loadMovieImage(posterPath: String, imageSize: ImageSize, completion: @escaping (UIImage?) -> ()) {
        runImageDataTask(posterPath: posterPath, imageSize: imageSize) { image in
            self.currentTasks.removeValue(forKey: posterPath)
            completion(image)
        }
    }
    
    private func runImageDataTask(posterPath: String, imageSize: ImageSize, completion: @escaping (UIImage?) -> ()) {
        guard let url = constructImageURL(posterPath: posterPath, imageSize: imageSize) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("data was nil or error found in loadMovieImage: \(error!)")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Unable to find poster image in loadMovieImage")
                completion(nil)
            }
        }
        currentTasks[posterPath] = task
        task.resume()
    }
    
    private func constructImageURL(posterPath: String, imageSize: ImageSize) -> URL? {
        let urlString = "https://image.tmdb.org/t/p/\(imageSize)/\(posterPath)"
        return URL(string: urlString)
    }
    
    func cancelAllCurrentTasks() {
        for task in currentTasks.values {
            task.cancel()
        }
    }
    
    enum ImageSize {
        case w92, w300
    }
}


