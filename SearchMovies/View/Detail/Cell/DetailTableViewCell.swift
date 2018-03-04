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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
