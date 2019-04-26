//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: Global variables
    
    var rowsSelected = [IndexPath]()
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: View controller lifecycle methods

    override func viewWillAppear(_ animated: Bool) {
        setEditButton()
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.editButton.title = "Edit"
        self.rowsSelected = []
    }
    
    // MARK: TableView manipulation methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowReuseIdentifier") as! MemeTableViewCell
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.setCell(meme: meme)  // Set texts and image properties
        setCellAlpha(cell, indexPath)  // Control the alpha value for all cells.
        
        return cell
    }
    
    func setCellAlpha(_ cell: MemeTableViewCell, _ indexPath: IndexPath) {
        if self.editButton.title == "Edit" {
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && (self.rowsSelected.contains(indexPath)) {
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && !(self.rowsSelected.contains(indexPath)) {
            cell.setAlpha(0.4)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! MemeTableViewCell
        
        if self.editButton.title == "Edit" {
            self.navigationController!.pushViewController(detailController, animated: true)
        } else if selectedCell.tableImageView.alpha != 1 && !(rowsSelected.contains(indexPath)) {
                    rowsSelected.append(indexPath)
                    selectedCell.setAlpha(1)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else if (rowsSelected.contains(indexPath)) {
            let foundIndex = rowsSelected.firstIndex(of: indexPath)
            rowsSelected.remove(at: foundIndex!)
            selectedCell.setAlpha(0.4)
            if self.rowsSelected == [] {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        if (editingStyle == .delete) {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            self.editButton.isEnabled = appDelegate.memes.count == 0 ? false : true
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            let cell = tableView.cellForRow(at: indexPath) as! MemeTableViewCell
            let color = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            
            self.colorHighlight(cell, color: color)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            let cell = tableView.cellForRow(at: indexPath) as! MemeTableViewCell
            
            self.colorHighlight(cell, color: .clear)
        }
    }
    
    func colorHighlight(_ cell: MemeTableViewCell, color: UIColor) {
        cell.contentView.backgroundColor = color
        cell.topLabelView.backgroundColor = color
        cell.bottomLabelView.backgroundColor = color
    }
    
    // MARK: RightBarButton Action methods
    
    @objc func addNewMeme() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func deleteRows() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        self.rowsSelected = self.rowsSelected.sorted() {
            $0.row > $1.row
        }
        
        for indexPath in self.rowsSelected {
            appDelegate.memes.remove(at: indexPath.row)
        }
        
        editTable(self)
        
        self.tableView.deleteRows(at: self.rowsSelected, with: UITableView.RowAnimation.left)
        
        self.editButton.isEnabled = appDelegate.memes.count == 0 ? false : true
    }
    
    // MARK: EditButton Enable/Disable method
    
    func setEditButton() {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        self.editButton.isEnabled = appDelegate.memes.count == 0 ? false : true
    }
    
    // MARK: IBAction

    @IBAction func editTable(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.editButton.title = "Edit"
            self.rowsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        self.tableView.reloadData()
    }
}
