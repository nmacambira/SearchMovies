//
//  MovieCollectionViewCell.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 19/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setMovie(_ movie: Movie){
        let imageUrl = movie.poster
        let url = URL(string: imageUrl)
        self.posterImage.kf.indicatorType = .activity
        self.posterImage.kf.setImage(with: url)
        self.titleLabel.text = movie.title
    }
}
