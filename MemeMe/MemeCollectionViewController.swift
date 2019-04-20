//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var itemsSelected = [IndexPath]()
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        selectItems()
    }
    
    func reloadSection() {
        var indexPaths: [NSIndexPath] = []
        for i in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            indexPaths.append(NSIndexPath(item: i, section: 0))
        }
    }
    
    func deselectItems() {
        for i in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! MemeCollectionViewCell
            cell.collectionImage.alpha = 0.4
        }
    }
    
    func selectItems() {
        for i in 0..<self.collectionView!.numberOfItems(inSection: 0) {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! MemeCollectionViewCell
            cell.collectionImage.alpha = 1
        }
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
        
        // Set the image
        cell.setCell(meme: meme)
        
        if self.editButton.title == "Edit" {
            cell.setAlpha(alpha: 1)
        } else {
            cell.setAlpha(alpha: 0.4)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
//        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        if let currentCell = collectionView.cellForItem(at: indexPath) as? MemeCollectionViewCell {
            if self.editButton.title == "Edit" {
                print("Navigate to MemeDetailViewController")
//                self.navigationController!.pushViewController(detailController, animated: true)
                
            } else {
                if currentCell.collectionImage.alpha != 1 {
                    print(indexPath.row)
                    if !(itemsSelected.contains(indexPath)) {
                        itemsSelected.append(indexPath)
                        currentCell.collectionImage.alpha = 1
                    }
                } else {
                    if (itemsSelected.contains(indexPath)) {
                        let foundIndex = itemsSelected.firstIndex(of: indexPath)
                        itemsSelected.remove(at: foundIndex!)
                        currentCell.collectionImage.alpha = 0.4
                    }
                }
            }
        }
    }
    
    @IBAction func editCollection(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))
            deselectItems()
        } else if self.editButton.title == "Done" {
            self.editButton.title = "Edit"
            self.itemsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
            selectItems()
        }
        self.reloadSection()
    }
    
    @objc func deleteItems() {
        self.collectionView.performBatchUpdates({
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            self.itemsSelected = self.itemsSelected.sorted() {
                $0.row > $1.row
            }
            for indexPath in self.itemsSelected {
                appDelegate.memes.remove(at: indexPath.row)
            }
            self.collectionView.deleteItems(at: self.itemsSelected)
            self.editButton.title = "Edit"
            self.itemsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
            selectItems()
            
        }, completion: {_ in})
    }
    
    @objc func addNewMeme() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
