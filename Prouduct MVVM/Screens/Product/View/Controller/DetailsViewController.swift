//
//  DetailsViewController.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 03/09/2023.
//

import UIKit

class DetailsViewController:  UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - var
    var product: Product? // This will be set by the prepareForSegue method
      
      override func viewDidLoad() {
          super.viewDidLoad()
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.reloadData()
          if let product = product {
                 // Populate the UI elements with data from the selected product
                 descriptionLabel.text = product.description
                 
                 // Create a system image with the name "star.fill"
                 let starImage = UIImage(systemName: "star.fill")
                 
                 // Create an attributed string with just the star image
                 let attributedString = NSMutableAttributedString(attachment: NSTextAttachment(image: starImage!))
                 
                 // Set the text color of the star to yellow
                 attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 0, length: 1))
                 
                 // Append the rating value with a leading space
                 attributedString.append(NSAttributedString(string: " \(product.rating)"))
                 
                 // Set the attributed string to the label
                 ratingLabel.attributedText = attributedString
                 
                 priceLabel.text = "Price: $\(product.price)"
                 discountPercentageLabel.text = "Discount: \(product.discountPercentage)%"

                 // Load and display the image
                 loadImage(from: product.thumbnail, into: imageView)
             }
      }
      
      // Helper function to load and display an image from a URL
      private func loadImage(from urlString: String, into imageView: UIImageView) {
          if let imageURL = URL(string: urlString) {
              DispatchQueue.global().async {
                  if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                      DispatchQueue.main.async {
                          imageView.image = image
                      }
                  }
              }
          }
      }
  }

  // MARK: - UICollectionViewDataSource
  extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return product?.images.count ?? 0
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCells", for: indexPath) as! ProductPhotoCollectionViewCells
          
          if let imageURLString = product?.images[indexPath.item] {
              loadImage(from: imageURLString, into: cell.ProductPhotos)
          }
          
          return cell
      }
  }

  extension DetailsViewController: UICollectionViewDelegateFlowLayout {
      // Adjust the size of each item (cell) in the collection view
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.width * 0.4)
      }
}
