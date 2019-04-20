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

        // Do any additional setup after loading the view.
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
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.editButton.title = "Edit"
        self.rowsSelected = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
        selectRows()
    }
    
    func deselectRows() {
        for i in 0..<self.tableView!.numberOfRows(inSection: 0) {
            let cell = self.tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! MemeTableViewCell
            cell.alpha = 0.4
            
        }
    }
    
    func selectRows() {
        for i in 0..<self.tableView!.numberOfRows(inSection: 0) {
            let cell = self.tableView.cellForRow(at: IndexPath(item: i, section: 0)) as! MemeTableViewCell
            cell.alpha = 1
        }
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
        
        // Set the texts and image
        cell.setCell(meme: meme)
        
        return cell
    }

    @IBAction func editTable(_ sender: Any) {
        if self.editButton.title == "Edit" {
            self.editButton.title = "Done"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRows))
            deselectRows()
        } else {
            self.editButton.title = "Edit"
            self.rowsSelected = []
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
            selectRows()
        }
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
        self.tableView.deleteRows(at: self.rowsSelected, with: UITableView.RowAnimation.left)
        self.editButton.title = "Edit"
        self.rowsSelected = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        selectRows()
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
