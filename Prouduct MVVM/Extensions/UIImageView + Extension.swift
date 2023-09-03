//
//  UIImageView + Extension.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 02/09/2023.
//

import Kingfisher
import UIKit

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}
