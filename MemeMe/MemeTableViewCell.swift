//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 19/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var topLabelView: UILabel!
    @IBOutlet weak var bottomLabelView: UILabel!
    
    func setCell(meme: Meme) {
        self.topLabelView.text = meme.topText
        self.bottomLabelView.text = meme.bottomText
        self.tableImageView.image = meme.originalImage
        self.tableImageView.contentMode = .scaleAspectFill
        self.tableImageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        self.tableImageView.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
