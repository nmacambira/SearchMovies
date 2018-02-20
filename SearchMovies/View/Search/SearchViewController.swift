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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationBarFont()
        activityIndicatorConfig()
        searchViewConfig()
        tableViewConfig()
        collectionViewConfig()
        buttonItemConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            searchController.searchBar.sizeToFit()
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func tableViewConfig() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.keyboardDismissMode = .onDrag
    }
    
    func collectionViewConfig() {
        let collectionNib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: collectionCellIdentifier)
    }
    
    func buttonItemConfig() {
        if #available(iOS 11.0, *) {
            let image = UIImage(named: "grid")!
            let barButton = buttonItemWithImage(image, action: #selector(showGrid))
            self.navigationItem.rightBarButtonItem = barButton
            tableView.isHidden = true
            collectionView.isHidden = false
        } else {
            tableView.isHidden = false
            collectionView.isHidden = true
        }
    }
    
    // MARK: - Instance methods
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchBarIsEmpty() {
            clearTableView()
        } else {
//            requestSearch(searchText.lowercased())
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(searchTimer(_:)), userInfo: searchText, repeats: false)
        }
    }
    
    @objc func searchTimer(_ myTimer: Timer) {
        let searchText = myTimer.userInfo as! String
        requestSearch(searchText.lowercased())
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        clearTableView()
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
        requestActitityIndicatorAnimation(.start)
        Service.searchMovies(text) { (list, statusCode, error) in
            if let _ = error {
                self.requestActitityIndicatorAnimation(.stop)
                self.alertNMError(statusCode: statusCode, error: error!)
                
            } else {
                if let result = list {
                    self.movies = result
                    self.movies.sort(by: { $0.title < $1.title })
                    self.requestActitityIndicatorAnimation(.stop)
                    self.reloadData()
                }
            }
        }
    }
    
    // MARK: - Feedbacks
    func requestActitityIndicatorAnimation(_ value: ActivityIndicator) {
        if value.rawValue == true {
            tableView.backgroundView = nil
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    //MARK: Actions
    @objc func showGrid(_ sender: UIBarButtonItem) {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
        
        let image = collectionView.isHidden ? UIImage(named: "list")! : UIImage(named: "grid")!
        let barButton = buttonItemWithImage(image, action: #selector(showGrid))
        self.navigationItem.rightBarButtonItem = barButton
        
        reloadData()
    }
    
    func buttonItemWithImage(_ image: UIImage, action: Selector) -> UIBarButtonItem {
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
extension SearchViewController: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = movies.count
        if isFiltering() {
            if numberOfItems == 0 {
                let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "No featured movie")
                collectionView.backgroundView = noResultLabel
            } else {
                collectionView.backgroundView = nil
            }
        } else {
            let noResultLabel = Utils.noResultsLabel(tableView: tableView, text: "Search for your favorite movie")
            collectionView.backgroundView = noResultLabel
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        
        let imageUrl = movie.poster
        let url = URL(string: imageUrl)
        cell.posterImage.kf.indicatorType = .activity
        cell.posterImage.kf.setImage(with: url)
        
        cell.titleLabel.text = movie.title
        
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

