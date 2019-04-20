//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 15/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImage: UIImageView!
    
    func setCell(meme: Meme) {
        self.collectionImage.image = meme.memedImage
    }
    
    func setAlpha(alpha: CGFloat) {
        self.collectionImage.alpha = alpha
    }
    
}
