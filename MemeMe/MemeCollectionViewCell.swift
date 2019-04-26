//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 15/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var topLabelView: UILabel!
    @IBOutlet weak var bottomLabelView: UILabel!
    
    // MARK: Cell manipulation methods
    
    func attributeString(_ meme: Meme, label: UILabel, memeText: String) -> NSAttributedString {
        let attrString = NSAttributedString(string: memeText, attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -2, NSAttributedString.Key.font: UIFont(name: meme.textFont.fontName, size: 11)!])
        return attrString
    }
    
    func setCell(meme: Meme) {
        self.topLabelView.attributedText = self.attributeString(meme, label: topLabelView, memeText: meme.topText)
        self.bottomLabelView.attributedText = self.attributeString(meme, label: bottomLabelView, memeText: meme.bottomText)
        self.collectionImageView.image = meme.originalImage
        self.collectionImageView.contentMode = .scaleAspectFill
        self.collectionImageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        self.collectionImageView.clipsToBounds = true
    }
    
    func setAlpha(_ alpha: CGFloat) {
        self.collectionImageView.alpha = alpha
        self.topLabelView.alpha = alpha
        self.bottomLabelView.alpha = alpha
    }
    
}
