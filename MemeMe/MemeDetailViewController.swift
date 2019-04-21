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
        detailImageView.backgroundColor = .red
        navBar.alpha = 0.6
        toolBar.alpha = 0.6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailImageView.image = meme.memedImage
        detailImageView.contentMode = .scaleAspectFit
        detailImageView.clipsToBounds = true
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        detailImageView.isUserInteractionEnabled = true
        detailImageView.addGestureRecognizer(singleTap)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let editorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
//        editorController.editTopTextField.text = meme.topText
//        editorController.editBottomTextField.text = meme.bottomText
//        editorController.editImagePickerView.image = meme.originalImage
        self.navigationController!.pushViewController(editorController, animated: true)
    }
    
    @objc func tapDetected() {
        navBar.isHidden = navBar.isHidden ? false : true
        toolBar.isHidden = navBar.isHidden
    }
    
}
