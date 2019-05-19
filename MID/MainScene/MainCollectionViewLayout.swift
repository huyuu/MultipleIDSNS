//
//  MainCollectionViewLayout.swift
//  MID
//
//  Created by 江宇揚 on 2019/05/19.
//  Copyright © 2019 Jiang Yuyang. All rights reserved.
//

import UIKit

class MainCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let dragOffSet = collectionViewContentSize.width/2
        let itemIndex = round( proposedContentOffset.x / dragOffSet )
        let xOffSet = itemIndex * dragOffSet
        return CGPoint(x: xOffSet, y: proposedContentOffset.y)
    }
}



// MARK: - Custom Helper Functions


