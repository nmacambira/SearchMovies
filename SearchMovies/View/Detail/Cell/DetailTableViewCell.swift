//
//  DetailTableViewCell.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var buttonBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonBackground.roundView()
    }
    
    func setDetailMovie(_ movie: Movie, with gesture: UITapGestureRecognizer, isFeatured: Bool){
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.posterImageView.image = UIImage(named: "poster")
        
        let imageUrl = movie.poster
        let url = URL(string: imageUrl)
        self.posterImageView.kf.indicatorType = .activity
        self.posterImageView.kf.setImage(with: url)
        
        self.posterImageView.addGestureRecognizer(gesture)
        self.posterImageView.isUserInteractionEnabled = true
        
        self.titleLabel.text = movie.title
        self.synopsisLabel.text = movie.synopsis
        if isFeatured {
            self.startButton.setImage(#imageLiteral(resourceName: "star_on"), for: .normal)
        } else {
            self.startButton.setImage(#imageLiteral(resourceName: "star_off"), for: .normal)
        }
    }

    func startButton(_ isFeatured: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (true) in
            self.startButtonAnimated(isFeatured)
        }
    }
    
    private func startButtonAnimated(_ isFeatured: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.startButton.transform = .identity
        }) { (true) in
            if isFeatured {
                self.startButton.setImage(#imageLiteral(resourceName: "star_on"), for: .normal)
            } else {
                self.startButton.setImage(#imageLiteral(resourceName: "star_off"), for: .normal)
            }
        }
    }   
}
