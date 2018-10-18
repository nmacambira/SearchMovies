//
//  MovieViewController.swift
//  SearchMovies
//
//  Created by Natalia Macambira on 20/02/18.
//  Copyright © 2018 Natalia Macambira. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Instance Properties
    var movies: [Movie] = []
    let tableCellIdentifier = "tableCell"
    let collectionCellIdentifier = "collectionCell"
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let searchController = UISearchController(searchResultsController: nil)
    var timer = Timer()
    var tabBarSelectedTag = 1
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarFont()
        activityIndicatorConfig()
        tableViewConfig()
        collectionViewConfig()
        buttonItemConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarSelectedTag = (tabBarController?.tabBar.selectedItem?.tag)!
        self.title = tabBarSelectedTag == 1 ? "Search Movies" : "Featured"
        if tabBarSelectedTag == 1 {
            searchViewConfig()
        } else {
            getMovies()
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            if tabBarSelectedTag == 2 && navigationItem.rightBarButtonItem == nil {
                addNavigationItem()
                tableView.isHidden = true
                collectionView.isHidden = false
            }
        }
    }

    func navigationBarFont() {
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
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            if tableView.tableHeaderView == nil {
                searchController.searchBar.sizeToFit()
                tableView.tableHeaderView = searchController.searchBar
            }
        }
    }
    
    func tableViewConfig() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func collectionViewConfig() {
        let collectionNib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: collectionCellIdentifier)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func buttonItemConfig() {
        if #available(iOS 11.0, *) {
            addNavigationItem()
            tableView.isHidden = true
            collectionView.isHidden = false
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    func addNavigationItem() {
        let image = UIImage(named: "grid")!
        let barButton = barButtonItemWithImage(image, action: #selector(showGrid))
        navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - Instance methods
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchBarIsEmpty() {
            clearTableView()
        } else {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(searchTimer(_:)), userInfo: searchText, repeats: false)
        }
    }
    
    @objc func searchTimer(_ myTimer: Timer) {
        let searchText = myTimer.userInfo as! String
        requestSearch(searchText.lowercased())
    }
    
    func clearTableView() {
        movies = []
        reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func reloadData() {
        if collectionView.isHidden {
            tableView.reloadData()
        } else {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Requests
    func requestSearch(_ text: String) {
        actitityIndicatorAnimation(.start)
        Service.searchMovies(text) { (list, statusCode, error) in
            if let _ = error {
                self.actitityIndicatorAnimation(.stop)
                self.alertNMError(statusCode: statusCode, error: error!)
                
            } else {
                if let result = list {
                    self.movies = result
                    self.movies.sort(by: { $0.title < $1.title })
                    self.actitityIndicatorAnimation(.stop)
                    self.reloadData()
                }
            }
        }
    }
    
    func getMovies() {
        actitityIndicatorAnimation(.start)
        if let movies = NMRealmDatabaseAssistant.queryForAnArrayOf(entity: Movie.self, sortedByKeyPath: "title") {
            self.movies = movies
            actitityIndicatorAnimation(.stop)
            reloadData()
        }
    }
    
    // MARK: - Feedbacks
    func actitityIndicatorAnimation(_ value: ActivityIndicator) {
        if value.rawValue == true {
            if tabBarSelectedTag == 1 {
                tableView.backgroundView = nil
                collectionView.backgroundView = nil
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            
            
        } else {
            if tabBarSelectedTag == 1 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    //MARK: Actions
    @objc func showGrid(_ sender: UIBarButtonItem) {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
        
        let image = collectionView.isHidden ? UIImage(named: "list")! : UIImage(named: "grid")!
        let barButton = barButtonItemWithImage(image, action: #selector(showGrid))
        self.navigationItem.rightBarButtonItem = barButton
        
        reloadData()
    }
    
    func barButtonItemWithImage(_ image: UIImage, action: Selector) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        return UIBarButtonItem(customView: button)
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

// MARK: - UISearchResultsUpdating Delegate
extension MovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            filterContentForSearchText(searchController.searchBar.text!)
            
        } else { //Cancel button action
            Service.cancelAllRequests()
            actitityIndicatorAnimation(.stop)
            clearTableView()
        }        
    }
}

// MARK: - TableView datasource and delegate
extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = movies.count
        if numberOfRows == 0 {
            if tabBarSelectedTag == 1 {
                if isFiltering() {
                    let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No results found")
                    tableView.backgroundView = noResultLabel
                } else {
                    let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "Search for your favorite movie")
                    tableView.backgroundView = noResultLabel
                }
            } else {
                let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No featured movie")
                tableView.backgroundView = noResultLabel
            }
        } else {
            tableView.backgroundView = nil
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath)
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

// MARK: - CollectionView datasource and delegate
extension MovieViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = movies.count
        if numberOfItems == 0 {
            if tabBarSelectedTag == 1 {
                if isFiltering() {
                    let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No results found")
                    collectionView.backgroundView = noResultLabel
                } else {
                    let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "Search for your favorite movie")
                    collectionView.backgroundView = noResultLabel
                }
            } else {
                let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No featured movie")
                collectionView.backgroundView = noResultLabel
            }
        } else {
            collectionView.backgroundView = nil
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.setMovie(movie)        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.7)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
