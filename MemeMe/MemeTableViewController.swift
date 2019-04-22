//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var rowsSelected = [IndexPath]()
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        if appDelegate.memes.count == 0 {
            self.editButton.isEnabled = false
        } else {
            self.editButton.isEnabled = true
        }
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.editButton.title = "Edit"
        self.rowsSelected = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    }
    
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
//        let alpha: CGFloat = self.editButton.title == "Edit" ? 1 : 0.4
        
        // Set the texts and image
        cell.setCell(meme: meme)
//        cell.setAlpha(alpha)
        
        if self.editButton.title == "Edit" {
            print("1111111")
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && (self.rowsSelected.contains(indexPath)) {
            print("222222")
            cell.setAlpha(1)
        } else if (self.editButton.title == "Done") && !(self.rowsSelected.contains(indexPath)) {
            print("3333333")
            cell.setAlpha(0.4)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        if let currentCell = tableView.cellForRow(at: indexPath) as? MemeTableViewCell {
            if self.editButton.title == "Edit" {
                self.navigationController!.pushViewController(detailController, animated: true)
                
            } else {
                if currentCell.tableImageView.alpha != 1 {
                    if !(rowsSelected.contains(indexPath)) {
                        rowsSelected.append(indexPath)
                        currentCell.setAlpha(1)
                    }
                } else {
                    if (rowsSelected.contains(indexPath)) {
                        let foundIndex = rowsSelected.firstIndex(of: indexPath)
                        rowsSelected.remove(at: foundIndex!)
                        currentCell.setAlpha(0.4)
                    }
                }
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
            if let cell = tableView.cellForRow(at: indexPath) as? MemeTableViewCell {
                cell.contentView.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                cell.tableImageView.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                cell.topLabelView.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                cell.bottomLabelView.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = tableView.cellForRow(at: indexPath) as? MemeTableViewCell {
                cell.contentView.backgroundColor = .clear
                cell.tableImageView.backgroundColor = .clear
                cell.topLabelView.backgroundColor = .clear
                cell.bottomLabelView.backgroundColor = .clear
            }
        }
    }

    @IBAction func editTable(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
        } else {
            self.editButton.title = "Edit"
            self.rowsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        }
        self.tableView.reloadData()
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
    
    @objc func addNewMeme() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
