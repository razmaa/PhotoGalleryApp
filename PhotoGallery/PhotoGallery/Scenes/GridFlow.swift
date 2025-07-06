//
//  GridFlow.swift
//  PhotoGallery
//
//  Created by nika razmadze on 06.07.25.
//

import UIKit

class SnappingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0,
                                width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        guard let layoutAttributes = layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        for layoutAttr in layoutAttributes {
            let itemOffset = layoutAttr.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

