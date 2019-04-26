//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Global variables
    
    var itemsSelected = [IndexPath]()
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manageFlowLayout()
        recognizeLongPress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setEditButton()
        self.collectionView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.editButton.title = "Edit"
        self.itemsSelected = []
    }
    
    // MARK: CollectionView manipulation methods
    
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
        
        cell.setCell(meme: meme)  // Set texts and image properties
        setCellAlpha(cell, indexPath)  // Control the alpha value for all cells.
        
        return cell
    }
    
    func setCellAlpha(_ cell: MemeCollectionViewCell, _ indexPath: IndexPath) {
        if self.editButton.title == "Edit" {
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && (self.itemsSelected.contains(indexPath)) {
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && !(self.itemsSelected.contains(indexPath)) {
            cell.setAlpha(0.4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
        
        if self.editButton.title == "Edit" {
            self.navigationController!.pushViewController(detailController, animated: true)
        } else if selectedCell.collectionImageView.alpha != 1 && !(self.itemsSelected.contains(indexPath)) {
            self.itemsSelected.append(indexPath)
            selectedCell.setAlpha(1)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else if (self.itemsSelected.contains(indexPath)) {
            let foundIndex = self.itemsSelected.firstIndex(of: indexPath)
            self.itemsSelected.remove(at: foundIndex!)
            selectedCell.setAlpha(0.4)
            if itemsSelected == [] {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            let color = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            
            self.colorHighlight(cell, color: color)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            let cell = collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            
            self.colorHighlight(cell, color: .clear)
        }
    }
    
    func colorHighlight(_ cell: MemeCollectionViewCell, color: UIColor) {
        cell.contentView.backgroundColor = color
    }
    
    func manageFlowLayout() {
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        let space:CGFloat = 2.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - 40 - (5 * space)) / 6.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    
    // MARK: RightBarButton Action methods
    
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
    
    // MARK: LongPress method
    
    func recognizeLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MemeCollectionViewController.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        self.collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        let point = longPress.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let selectedCell = self.collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
            UIView.animate(withDuration: 0.5) {
                self.colorHighlight(selectedCell, color: .clear)
            }
        }
        
        if longPress.state == .began && self.editButton.title == "Edit" {
            if let indexPath = indexPath {
                let selectedCell = self.collectionView.cellForItem(at: indexPath) as! MemeCollectionViewCell
                let color = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                UIView.animate(withDuration: 0.5) {
                    self.colorHighlight(selectedCell, color: color)
                }
                
                editCollection(self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.collectionView(self.collectionView, didSelectItemAt: indexPath)
                })
            }
        }
    }
    
    // MARK: EditButton Enable/Disable method
    
    func setEditButton() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.editButton.isEnabled = appDelegate.memes.count == 0 ? false : true
    }
    
    // MARK: IBAction
    
    @IBAction func editCollection(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItems))
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else if self.editButton.title == "Done" {
            self.editButton.title = "Edit"
            self.itemsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        self.collectionView.reloadData()
    }
}
