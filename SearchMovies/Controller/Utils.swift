//
//  Utils.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

// MARK: - Enums
enum ActivityIndicator {
    case start
    case stop
    
    var rawValue: Bool {
        switch self {
        case .start: return true
        case .stop: return false
        }
    }
}

final class Utils {
    static func noResultsLabel(tableView: UITableView, text: String) -> UIView {
        let noResultLabel = UILabel(frame: tableView.bounds)
        noResultLabel.textColor = UIColor(white: 60.0/255.0, alpha: 1)
        noResultLabel.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        noResultLabel.numberOfLines = 0
        noResultLabel.textAlignment = NSTextAlignment.center
        noResultLabel.font = noResultLabel.font.withSize(14)
        noResultLabel.text = text
        noResultLabel.sizeToFit()
        return noResultLabel
    }
    
    static func noResultText(tabBarSelected: Int, isFiltering: Bool) -> String {
        let searchTabText = isFiltering ? "No results found" : "Search for your favorite movie"
        let featureTabText = "No featured movie"
        return (tabBarSelected == 1) ? searchTabText : featureTabText
    }
    
    static func radians(_ degrees: Double) -> CGFloat {
        return CGFloat (degrees * .pi / 180.0)
    }
}

extension UIViewController {
    func showAlert(withTitle title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(self, animated: true, completion: nil)
    }
}

extension UIView {
    func roundView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}

extension UIColor {
    public class func pink() -> UIColor {
        return UIColor(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1)
    }
}
