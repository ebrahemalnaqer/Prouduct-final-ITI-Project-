//
//  ProductCell.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import UIKit

class ProductCell: UITableViewCell {
    //MARK: - outlet
    
    
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var ProuductBackgrond: UIView!
    @IBOutlet weak var ProuductTitle: UILabel!
    @IBOutlet weak var ProuductBrand: UILabel!
    @IBOutlet weak var ProductStock: UILabel!
    @IBOutlet weak var ProductPrice: UILabel!
    @IBOutlet weak var FavBtn: UIButton!
    
    
    var product : Product?{
        didSet { // property Observer
            productDetailConfiguration()
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        ProuductBackgrond.clipsToBounds = false
        ProuductBackgrond.layer.cornerRadius = 15

        ProductImageView.layer.cornerRadius = 10

        self.ProuductBackgrond.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func productDetailConfiguration(){
        guard let product else {return}
        ProuductTitle.text = product.title
        ProuductBrand.text = product.brand
        ProductStock.text = "\(product.stock)"
        ProductPrice.text = "$\(product.price)"
        ProductImageView.setImage(with: product.thumbnail)
   
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        print("Heart button tapped!")
    }
 
    
}
