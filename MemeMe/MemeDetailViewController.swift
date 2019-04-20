//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 21/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
    }
    
    
}
