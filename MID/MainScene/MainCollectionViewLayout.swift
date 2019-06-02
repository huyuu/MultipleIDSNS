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
        
        
        self.collectionView!.decelerationRate = .fast
    }
    
    
    // do custom actions on item attributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let resources = self.resources else { return nil }
        /// get itemAttributes from super
        guard let itemsAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        return itemsAttributes.map({ (itemAttributes) -> UICollectionViewLayoutAttributes in
            self.scaleItems(itemAttributes, using: resources)
            return itemAttributes
        })
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let layoutAttributes = self.layoutAttributesForElements(in: collectionView!.bounds)!
        let viewCenter = collectionView!.bounds.width / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.x + viewCenter
        
        let closetItem = layoutAttributes.sorted { (first, second) -> Bool in
            return abs( first.center.x-proposedContentOffsetCenterOrigin ) < abs( second.center.x-proposedContentOffsetCenterOrigin )
            }.first!
        let targetContentOffset = CGPoint(x: floor(closetItem.center.x - viewCenter), y: proposedContentOffset.y)
        return targetContentOffset
    }
}



// MARK: - Custom Helper Functions

extension MainCollectionViewLayout {
    /// clip an item to the center of the screen
    private func scaleItems(_ itemAttributes: UICollectionViewLayoutAttributes, using resources: ResourcesForMainScrollView) {
        let frameHalfWidth = collectionView!.frame.size.width / 2
        let lengthFromItemCenterToEdge = itemAttributes.center.x - collectionView!.contentOffset.x
        
        let maxAcceptableInterItemSpacing = self.itemSize.width + self.minimumLineSpacing
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
    
    
    /// set recessive item size
    private func setRecessiveItemSize(using resources: ResourcesForMainScrollView) {
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
        self.itemSize = self.calculateItemSize(using: resources)
        print("itemSize: \(itemSize)")
        self.setRecessiveItemSize(using: resources)
        
        // set sectionInset
        let collectionViewSize = collectionView!.bounds.size
        let xInset = (collectionViewSize.width - self.itemSize.width)/2 + 16*4
        print("xInset: \(xInset)")
        self.sectionInset = UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset)
        
//        print("collectionViewFrame: \(collectionView!.frame.size)")
//        print("collectionViewBounds: \(collectionView!.bounds.size)")
//        print("sizeForCell: \(resources.widthForCell), \(resources.heightForCell)")

        self.collectionView!.reloadData()
    }
    
    
    private func calculateItemSize(using resources: ResourcesForMainScrollView) -> CGSize {
        /// calculate item width and height
        let width = collectionView!.frame.width - (collectionView!.contentInset.left + collectionView!.contentInset.right) - (resources.trailingInset + resources.leadingInset)
        let height = collectionView!.frame.height - (collectionView!.contentInset.top + collectionView!.contentInset.bottom) - (resources.topInset + resources.bottomInset)
        
        return CGSize(width: width, height: height)
    }
}
