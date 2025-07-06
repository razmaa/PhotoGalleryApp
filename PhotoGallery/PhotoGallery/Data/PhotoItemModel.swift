//
//  PhotoItemModel.swift
//  PhotoGallery
//
//  Created by nika razmadze on 06.07.25.
//

import UIKit

struct Photo {
    let image: UIImage
    let title: String
    let date: Date
    var isFavorite: Bool
    
    var year: Int {
        Calendar.current.component(.year, from: date)
    }
}

