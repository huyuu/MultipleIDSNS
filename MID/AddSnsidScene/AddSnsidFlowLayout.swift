//
//  AddSnsidFlowLayout.swift
//  MID
//
//  Created by 江宇揚 on 2019/06/07.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class AddSnsidFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        return self.clipsToCell(proposedContentOffset: proposedContentOffset)
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}



// MARK: - Custom Helper Functions

private extension AddSnsidFlowLayout {
    func clipsToCell(proposedContentOffset: CGPoint) -> CGPoint {
        let layoutAttributes = self.layoutAttributesForElements(in: collectionView!.bounds)!
        let viewCenter = collectionView!.bounds.height / 2
        let proposedContentOffsetCenterOrigin = proposedContentOffset.y + viewCenter
        
        let closetItem = layoutAttributes.sorted { (first, second) -> Bool in
            return abs( first.center.y-proposedContentOffsetCenterOrigin ) < abs( second.center.y-proposedContentOffsetCenterOrigin )
            }.first!
        let targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closetItem.center.y - viewCenter))
        
        return targetContentOffset
    }
}
