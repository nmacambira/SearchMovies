//
//  FeatureViewController.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 18/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instance Properties
    var movies: [Movie] = []
    let cellIdentifier = "searchCell"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFont()
        activityIndicatorConfig()
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMovies()
    }
    
    func navigationBarFont() {
        self.title = "Features"
        let attributes = [
            NSAttributedStringKey.font: UIFont(name: "Pacifico-Regular", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.pink()
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    func activityIndicatorConfig() {
        activityIndicator.isHidden = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.color = UIColor.pink()
    }
    
    func tableViewConfig() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func getMovies() {
        actitityIndicatorAnimation(.start)
       if let movies = NMRealmDatabaseAssistant.queryForAnArrayOf(entity: Movie.self, sortedByKeyPath: "title") {
            self.movies = movies
        actitityIndicatorAnimation(.stop)
            tableView.reloadData()
        }
    }
    
    // MARK: - Feedbacks
    func actitityIndicatorAnimation(_ value: ActivityIndicator) {
        if value.rawValue == true {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = sender as? Int {
            let movie = movies[row]
            if let destination = segue.destination as? DetailTableViewController {
                destination.identifier = movie.identifier
            }
        }
     }
}

// MARK: - TableView datasource and delegate
extension FeatureViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = movies.count
        if numberOfRows == 0 {
            let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No featured movie")
            tableView.backgroundView = noResultLabel
        } else {
            tableView.backgroundView = nil
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 16)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
