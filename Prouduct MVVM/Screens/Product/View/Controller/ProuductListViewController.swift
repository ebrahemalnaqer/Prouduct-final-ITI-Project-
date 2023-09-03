//
//  ProuductListViewController.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import UIKit

class ProuductListViewController: UIViewController {
    
    @IBOutlet weak var productTabelView:UITableView!
    
    private var viewModel = ProuductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
    }
}

extension ProuductListViewController {
    func configuration(){
        productTabelView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        initVireModel()
        observeEvent()
        
    }
    func initVireModel(){
        viewModel.fetchProuduct()
    }
    // Data binding event observe - communication
    func observeEvent(){
        viewModel.eventHandler = { [weak self] event in
            guard let self else {return}
            
            switch event {
            case .loading:
                //indicator show
                print("Product Loading....")
            case .stopLoading:
                // indicator hide kardo
                print("Stop Loading")
            case .dataLoaded:
                print("Data Loaded...")
                DispatchQueue.main.async {
                    //UI Main works well
                    self.productTabelView.reloadData()
                }
            case .error(let error):
                print(error as Any)
            }
        }
        
    }
}

extension ProuductListViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.prouduts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell else {
            return UITableViewCell()
        }

        let product = viewModel.prouduts[indexPath.row]
        cell.product = product

        // Set the tag of the button to the cell's index
        cell.FavBtn.tag = indexPath.row

        // Add the target action to the button
        cell.FavBtn.addTarget(self, action: #selector(addToFavoritesTapped(_:)), for: .touchUpInside)

        // Set the button image based on whether the product is a favorite or not
        let isFavorite = FavoritesManager.shared.isFavorite(product)
        let buttonImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        cell.FavBtn.setImage(buttonImage, for: .normal)

        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.prouduts[indexPath.row]
        performSegue(withIdentifier: "ShowProductDetail", sender: selectedProduct)
    }
    // Prepare data for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductDetail",
           let navViewController = segue.destination as? DetailsViewController,
           let selectedProduct = sender as? Product {
            navViewController.product = selectedProduct
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Show an alert to confirm deletion
            let alertController = UIAlertController(title: "Delete Product", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                // Handle the deletion of the product here
                self.deleteProduct(at: indexPath)
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        // Remove the product from your local array
        viewModel.prouduts.remove(at: indexPath.row)

        // Update the table view
        productTabelView.deleteRows(at: [indexPath], with: .fade)

        // Delete the product from CoreData
        let product = viewModel.prouduts[indexPath.row]
        CoreDataHelper.shared.deleteFavoriteProduct(productId: Int64(product.id))
    }

    
    @objc func addToFavoritesTapped(_ sender: UIButton) {
        // Get the index from the button's tag
        let index = sender.tag

        // Get the associated product
        let product = viewModel.prouduts[index]

        // Use the FavoritesManager to add or remove the product from favorites
        let favoritesManager = FavoritesManager.shared

        if favoritesManager.isFavorite(product) {
            favoritesManager.removeFavorite(product)
            sender.setImage(UIImage(systemName: "heart"), for: .normal)

            // Update the favorited state in CoreData when unliked
            CoreDataHelper.shared.updateFavoriteProduct(productId: Int64(product.id), isFavorited: false)
        } else {
            favoritesManager.addFavorite(product)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)

            // Save the product as a favorite in CoreData when liked
            CoreDataHelper.shared.saveFavoriteProduct(product: product, isFavorited: true)

            // Reload data in FavoritesViewController
            NotificationCenter.default.post(name: NSNotification.Name("ProductAddedToFavorites"), object: nil)
        }
    }

    
    

}
