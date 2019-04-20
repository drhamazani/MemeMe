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
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func attributeString(label: UILabel, memeText: String) -> NSAttributedString {
        let attrString = NSAttributedString(string: memeText, attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -2, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 11)!])
        return attrString
    }
    
    func setCell(meme: Meme) {
        self.topLabel.attributedText = self.attributeString(label: topLabel, memeText: meme.topText)
        self.bottomLabel.attributedText = self.attributeString(label: bottomLabel, memeText: meme.bottomText)
        self.collectionImage.image = meme.originalImage
        self.collectionImage.contentMode = .scaleAspectFill
        self.collectionImage.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        self.collectionImage.clipsToBounds = true
    }
    
    func setAlpha(alpha: CGFloat) {
        self.collectionImage.alpha = alpha
    }
    
}
