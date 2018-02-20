//
//  DetailTableViewController.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 17/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit
import Kingfisher

final class DetailTableViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!    
    
    // MARK: - Instance Properties
    let cellIdentifier = "detailCell"
    let cellIVideoIdentifier = "videoCell"
    var identifier: Int?
    var movie: Movie?
    var isFeatured = false
    
     // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButtonConfig()
        tableViewConfig()
        getMovie()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        persistData()
    }
    
    func closeButtonConfig() {
        closeButton.roundView()
    }
    
    func tableViewConfig() {
        let detailNib = UINib(nibName: "DetailTableViewCell", bundle: nil)
        tableView.register(detailNib, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIVideoIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension        
    }
    
    // MARK: - Instance methods
    func getMovie() {
        guard let id = identifier else { return }
        if let object = NMRealmDatabaseAssistant.queryForSingleObjectFrom(entity: Movie.self, withIdentifier: id) {
            movie = object
            isFeatured = true
        } else {
            requestDetail()
        }
    }
    
    func requestDetail() {
        guard let id = identifier else { return }
        requestActitityIndicatorAnimation(.start)
        let idString = String(id)
        Service.getDetails(idString) { (object, statusCode, error) in
            if let _ = error {
                self.requestActitityIndicatorAnimation(.stop)
                self.alertNMError(statusCode: statusCode, error: error!)
                
            } else {
                if let result = object {
                    self.movie = result
                    self.requestActitityIndicatorAnimation(.stop)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func persistData() {
        guard let mv = movie else { return }
        if !isFeatured && NMRealmDatabaseAssistant.objectExist(id: mv.identifier, inEntity: Movie.self) {
            NMRealmDatabaseAssistant.delete(object: mv)
        } else if isFeatured {
            NMRealmDatabaseAssistant.save(object: mv)
        }
    }
    
    @objc func featuredMovie() {
        isFeatured = !isFeatured
        let indexPath = IndexPath(row: 0, section: 0)
        let detailCell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        detailCell.startButton(isFeatured)
    }
    
    // MARK: - Feedbacks
    func requestActitityIndicatorAnimation(_ value: ActivityIndicator) {
        if value.rawValue == true {
            tableView.backgroundView = nil
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeActionButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (true) in
            self.closeButtonAnimated()
        }        
    }
    
    func closeButtonAnimated() {
        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.transform = .identity
        }) { (true) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - Tableview datasource and delegate
extension DetailTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 1
        if let mv = movie,  mv.videos.count > 0 {
            numberOfSections = 2
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if let mv = movie {
            if section == 0 {
                numberOfRows = 1
            } else {
                numberOfRows = mv.videos.count
            }
            tableView.backgroundView = nil
            
        } else {
            let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "Movie preview error")
            tableView.backgroundView = noResultLabel
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if let mv = movie {
            if indexPath.section == 0 {
                let detailCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailTableViewCell
                detailCell.selectionStyle = UITableViewCellSelectionStyle.none
                detailCell.posterImageView.image = UIImage(named: "poster")
                
                let imageUrl = mv.poster
                let url = URL(string: imageUrl)
                detailCell.posterImageView.kf.indicatorType = .activity
                detailCell.posterImageView.kf.setImage(with: url)
                
                detailCell.titleLabel.text = mv.title
                detailCell.synopsisLabel.text = mv.synopsis
                if isFeatured {
                    detailCell.startButton.setImage(#imageLiteral(resourceName: "star_on"), for: .normal)
                } else {
                    detailCell.startButton.setImage(#imageLiteral(resourceName: "star_off"), for: .normal)
                }
                detailCell.startButton.addTarget(self, action: #selector(featuredMovie), for: UIControlEvents.touchUpInside)
                
                cell = detailCell
            } else {
                let videoCell = tableView.dequeueReusableCell(withIdentifier: cellIVideoIdentifier, for: indexPath)
                let video = mv.videos[indexPath.row]
                videoCell.textLabel?.text = video.name
                videoCell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 16)
                videoCell.accessoryType = .disclosureIndicator
                cell = videoCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 33))
        label.font = UIFont(name: "Pacifico-Regular", size: 20)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Trailers"
        view.addSubview(label)
        view.backgroundColor = UIColor.pink()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if let mv = movie {
                let video = mv.videos[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
                showVideoWith(video.key)
            }
        }
    }
    
    func showVideoWith(_ key: String)  {
        // redirect to app
        if let youtubeURL = URL(string: "youtube://\(key)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
            // redirect through safari
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)") {
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
}
