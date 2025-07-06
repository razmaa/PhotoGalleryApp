//
//  photoHeader.swift
//  PhotoGallery
//
//  Created by nika razmadze on 06.07.25.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.frame = bounds
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

