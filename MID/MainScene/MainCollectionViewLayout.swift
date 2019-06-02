//
//  MainCollectionViewLayout.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/26.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class MainCollectionViewLayout: UICollectionViewFlowLayout {
    public var resources: ResourcesForMainScrollView! {
        willSet {
            self.configureAscynchronously(from: newValue)
        } didSet {
            self.collectionView?.reloadData()
        }
    }
    
    
    /// Calculations for attributes previously
    override func prepare() {
        super.prepare()
        
        guard let resources = self.resources else { return }
        
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = resources.ownerController.tableView.frame.width - (resources.leadingInset + resources.trailingInset) - (collectionView.contentInset.left + collectionView.contentInset.right)
//        let height = resources.heightForCell - (resources.bottomInset + resources.topInset) - (collectionView.contentInset.bottom + collectionView.contentInset.top)
//        return resources.calculatedItemSize
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: resources.topInset, left: resources.leadingInset, bottom: resources.bottomInset, right: resources.trailingInset)
//    }
    
    
    // do custom actions on item attributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let resources = self.resources else { return nil }
        /// get itemAttributes from super
        guard let itemsAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        return itemsAttributes.map({ (itemAttributes) -> UICollectionViewLayoutAttributes in
//            self.scaleItems(itemAttributes, using: resources)
            return itemAttributes
        })
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}



// MARK: - Custom Helper Functions

extension MainCollectionViewLayout {
    /// clip an item to the center of the screen
    private func scaleItems(_ itemAttributes: UICollectionViewLayoutAttributes, using resources: ResourcesForMainScrollView) {
        let frameHalfWidth = collectionView!.frame.size.width / 2
        let lengthFromItemCenterToEdge = itemAttributes.center.x - collectionView!.contentOffset.x
        
        let maxAcceptableInterItemSpacing = self.itemSize.width + self.minimumInteritemSpacing
        let distanceToCenter = abs( frameHalfWidth - lengthFromItemCenterToEdge )
        let actualInsetFromCenter = min( distanceToCenter, maxAcceptableInterItemSpacing )
        
        // calculate approachingRate and adjust aplha and scale accordingly
        let approachingRate = 1 - actualInsetFromCenter/maxAcceptableInterItemSpacing
        let adjustedAlpha = approachingRate * (resources.dominantAlpha - resources.recessiveAlpha) + resources.recessiveAlpha
        let adjustedScale = approachingRate * (resources.dominantScale - resources.recessiveScale) + resources.recessiveScale
        
        // adopt all changes to itemAttributes
        itemAttributes.alpha = adjustedAlpha
        itemAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, adjustedScale, adjustedScale, 1.0)
    }
    
    
    private func setRecessiveItemSize(using resources: ResourcesForMainScrollView) {
        // calculate item width and height
//        let calculatedItemWidth = tableViewWidth  - (resources.leadingInset + resources.trailingInset) - (collectionView!.contentInset.left + collectionView!.contentInset.right)
//        let calculatedItemHeight = resources.heightForCell - (resources.bottomInset + resources.topInset) - (collectionView!.contentInset.bottom + collectionView!.contentInset.top)
        
        // set dominant item size
//        let dominantItemSize = CGSize(width: calculatedItemWidth, height: calculatedItemHeight)
//        self.itemSize = dominantItemSize
        
        // set recessive item size
        let recessiveWidth = self.itemSize.width * resources.recessiveScale
        let recessiveItemSize = CGSize(width: recessiveWidth, height: self.itemSize.height)
        self.estimatedItemSize = recessiveItemSize
    }
    
    
    /// set resource from delegate
    private func configureAscynchronously(from resources: ResourcesForMainScrollView) {
        // set minInterItemSpacing and lineSpacing
        self.minimumInteritemSpacing = resources.minInterItemSpacing
        self.minimumLineSpacing = resources.minLineSpacing
        // set itemSizes
        self.itemSize = self.itemSize
        self.setRecessiveItemSize(using: resources)
        
        print("itemSize: \(self.itemSize)")

        self.collectionView?.reloadData()
    }
    
    
    private func calculateItemSize(using resources: ResourcesForMainScrollView) -> CGSize {
        /// calculate item width and height
        let width = collectionView!.frame.width - (collectionView!.contentInset.left + collectionView!.contentInset.right)
        let height = collectionView!.frame.height - (collectionView!.contentInset.top + collectionView!.contentInset.bottom)
        
        return CGSize(width: width, height: height)
    }
}
