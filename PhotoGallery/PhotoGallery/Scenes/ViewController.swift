//
//  ViewController.swift
//  PhotoGallery
//
//  Created by nika razmadze on 06.07.25.
//

import UIKit

class ViewController: UIViewController {
    
    var photos: [Photo] = []
    var groupedPhotos: [Int: [Photo]] = [:]
    var years: [Int] = []
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo Gallery"
        view.backgroundColor = .white
        
        photos = generateSamplePhotos()
        groupPhotos()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func groupPhotos() {
        groupedPhotos = Dictionary(grouping: photos, by: { $0.year })
        years = groupedPhotos.keys.sorted(by: >)
    }
    
    func reloadData() {
        groupPhotos()
        collectionView.reloadData()
    }
    
    func generateSamplePhotos() -> [Photo] {
        let titles = [
            "Sunset", "Mountain", "Ocean", "Forest", "River", "Sky",
            "Night", "Field", "Desert", "Bridge", "Clouds", "Road",
            "Stars", "Snow", "Rain", "City", "Lake", "Trail", "Sun", "Moon"
        ]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let imageNames = ["img1", "img2", "img3", "img4"]
        
        var photos: [Photo] = []
        
        for _ in 0..<25 {
            let title = titles.randomElement()!
            let year = Int.random(in: 2021...2023)
            let month = Int.random(in: 1...12)
            let day = Int.random(in: 1...28)
            let dateString = String(format: "%d/%02d/%02d", year, month, day)
            let date = formatter.date(from: dateString)!
            let imageName = imageNames.randomElement()!
            let isFavorite = false
            
            if let image = UIImage(named: imageName) {
                let photo = Photo(image: image, title: title, date: date, isFavorite: isFavorite)
                photos.append(photo)
            }
        }
        
        return photos
    }
    
    func deletePhoto(_ photo: Photo) {
        if let index = photos.firstIndex(where: { $0.title == photo.title && $0.date == photo.date }) {
            photos.remove(at: index)
            reloadData()
        }
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        years.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let year = years[section]
        return groupedPhotos[year]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let year = years[indexPath.section]
        var photo = groupedPhotos[year]![indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.configure(with: photo)
        
        cell.favoriteAction = {
            photo.isFavorite.toggle()
            self.updatePhoto(photo)
            cell.configure(with: photo)
            
            let message = photo.isFavorite ? "Marked \(photo.title) as Favorite!" : "Removed \(photo.title) from Favorites."
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        
        return cell
    }
    
    func updatePhoto(_ updated: Photo) {
        if let index = photos.firstIndex(where: { $0.title == updated.title && $0.date == updated.date }) {
            photos[index] = updated
            reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = UIDevice.current.orientation.isPortrait ? 3 : 5
        let spacing: CGFloat = 10 * (columns + 1)
        let width = floor((collectionView.frame.width - spacing) / columns)
        return CGSize(width: width, height: width + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.identifier,
            for: indexPath) as! HeaderView
        
        header.titleLabel.text = "\(years[indexPath.section])"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let year = years[indexPath.section]
        let photo = groupedPhotos[year]![indexPath.item]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deletePhoto(photo)
            }
            return UIMenu(title: "", children: [delete])
        }
    }
}


