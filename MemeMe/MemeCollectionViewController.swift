//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var itemsSelected = [IndexPath]()
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        let space:CGFloat = 2.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - 40 - (5 * space)) / 6.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MemeCollectionViewController.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if appDelegate.memes.count == 0 {
            self.editButton.isEnabled = false
        } else {
            self.editButton.isEnabled = true
        }
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.editButton.title = "Edit"
        self.itemsSelected = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
//        selectItems()
        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemReuseIdentifier", for: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
//        let alpha: CGFloat = self.editButton.title == "Edit" ? 1 : 0.4
        
        // Set the image
        cell.setCell(meme: meme)
//        cell.setAlpha(alpha)
        if self.editButton.title == "Edit" {
            print("1111111")
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && (self.itemsSelected.contains(indexPath)) {
            print("222222")
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && !(self.itemsSelected.contains(indexPath)) {
            print("3333333")
            cell.setAlpha(0.4)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MemeCollectionViewCell {
            if self.editButton.title == "Edit" {
                self.navigationController!.pushViewController(detailController, animated: true)
                
            } else {
                if currentCell.collectionImageView.alpha != 1 {
                    print(indexPath.row)
                    if !(self.itemsSelected.contains(indexPath)) {
                        self.itemsSelected.append(indexPath)
                        currentCell.setAlpha(1)
                        print(currentCell.topLabelView.text!)
                    }
                } else {
                    if (self.itemsSelected.contains(indexPath)) {
                        let foundIndex = self.itemsSelected.firstIndex(of: indexPath)
                        self.itemsSelected.remove(at: foundIndex!)
                        currentCell.setAlpha(0.4)
                        print(currentCell.bottomLabelView.text!)
                    }
                }
            }
        }
    }
    
    @IBAction func editCollection(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))
//            deselectItems()
        } else if self.editButton.title == "Done" {
            self.editButton.title = "Edit"
            self.itemsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
//            selectItems()
        }
//        self.reloadSection()
        self.collectionView.reloadData()
    }
    
    @objc func deleteItems() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.itemsSelected = self.itemsSelected.sorted() {
            $0.row > $1.row
        }
        for indexPath in self.itemsSelected {
            appDelegate.memes.remove(at: indexPath.row)
        }
        self.editCollection(self)
        self.collectionView.deleteItems(at: self.itemsSelected)
        self.editButton.isEnabled = appDelegate.memes.count == 0 ? false : true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    }
    
    @objc func addNewMeme() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        let point = longPress.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if longPress.state == .began {
            //            return
            if let indexPath = indexPath {
                if let _ = self.collectionView.cellForItem(at: indexPath) as? MemeCollectionViewCell {
                    if self.editButton.title == "Edit" {
                        editCollection(self)
                        print(indexPath)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            self.collectionView(_: self.collectionView, didSelectItemAt: indexPath)
                        })
                    }
                }
            }
        }
    }

}
