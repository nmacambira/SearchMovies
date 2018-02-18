//
//  SearchViewController.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 16/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instance Properties
    var movies: [Movie] = []
    let cellIdentifier = "searchCell"
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarFont()
        activityIndicatorConfig()
        searchViewConfig()
        tableViewConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    func navigationBarFont() {
        self.title = "Search Movies"
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
    
    func searchViewConfig() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            definesPresentationContext = true

        } else {
            searchController.searchBar.sizeToFit()
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func tableViewConfig() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - Instance methods
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchBarIsEmpty() {
            clearTableView()
        } else {
            requestSearch(searchText.lowercased())
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearTableView()
    }
    
    func clearTableView() {
        movies = []
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Requests
    func requestSearch(_ text: String) {
        requestActitityIndicatorAnimation(.start)
        Service.searchMovies(text) { (list, error) in
            if let _ = error {
                print("Erro na requisiçao")
                self.requestActitityIndicatorAnimation(.stop)
                //TODO: NMError feedback
            } else {
                if let result = list {
                    self.movies = result
                    self.movies.sort(by: { $0.title < $1.title })
                    self.requestActitityIndicatorAnimation(.stop)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Feedbacks
    func requestActitityIndicatorAnimation(_ value: ActivityIndicator) {
        if value.rawValue == true {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = sender as? Int {
            let movie = movies[row]
            if let destination = segue.destination as? DetailTableViewController {
                destination.identifier = movie.identifier
                if #available(iOS 11.0, *) {
                    // Running iOS 11 OR NEWER
                } else {
                    tableView.tableHeaderView = nil
                }
            }
        }
    }  
}

// MARK: - UISearchResultsUpdating Delegate
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: - TableView datasource and delegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = movies.count
        if isFiltering() {
            if numberOfRows == 0 {
                let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No results found")
                tableView.backgroundView = noResultLabel
            } else {
                tableView.backgroundView = nil
            }
        } else {
            let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "Search for your favorite movie")
            tableView.backgroundView = noResultLabel
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
