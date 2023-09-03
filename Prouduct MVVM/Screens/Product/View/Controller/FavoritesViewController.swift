//
//  FavoritesViewController.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 03/09/2023.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favorites: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadFavorites()
        // Add an observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(productAddedToFavorites), name: NSNotification.Name("ProductAddedToFavorites"), object: nil)
    }
    
    // Selector function for the notification
    @objc func productAddedToFavorites() {
        loadFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func loadFavorites() {
        favorites = Array(FavoritesManager.shared.getFavorites())
        print("Favorites count: \(favorites.count)")
        tableView.reloadData()
    }
}

private func saveFavoriteToCoreData(product: Product) {
    CoreDataHelper.shared.saveFavoriteProduct(product: product, isFavorited: true)
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        
        let favoriteProduct = favorites[indexPath.row]
        cell.textLabel?.text = favoriteProduct.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productToRemove = favorites[indexPath.row]
            FavoritesManager.shared.removeFavorite(productToRemove)

            // Update the local data and the table view
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


