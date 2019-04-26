//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 21/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Global variables
    
    var meme: Meme!

    // MARK: View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        attributeImage(meme)
        setAlpha(0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideMainBars(navBar: true, tabBar: true)
    }
    
    // MARK: ImageView manipulation method
    
    func attributeImage(_ meme: Meme) {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        detailImageView.addGestureRecognizer(singleTap)  // Make the imageView clickable.
        detailImageView.image = meme.memedImage
        detailImageView.backgroundColor = meme.backgroundColor
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.clipsToBounds = true
        detailImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapDetected() {
        navBar.isHidden = navBar.isHidden ? false : true
        toolBar.isHidden = navBar.isHidden
    }
    
    // MARK: Bars properties manipulation methods
    
    func setAlpha(_ alpha: CGFloat) {
        navBar.alpha = alpha
        toolBar.alpha = alpha
    }
    
    func hideMainBars(navBar: Bool, tabBar: Bool) {
        self.navigationController?.navigationBar.isHidden = navBar
        self.tabBarController?.tabBar.isHidden = tabBar
    }
    
    // MARK: IBActions
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.hideMainBars(navBar: false, tabBar: false)
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        hideMainBars(navBar: false, tabBar: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorController.meme = self.meme
        self.navigationController!.pushViewController(editorController, animated: true)
    }
}
