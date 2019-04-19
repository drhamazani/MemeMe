//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 14/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowReuseIdentifier")!
        let meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // Set the texts and image
        cell.textLabel?.text = meme.topText + ", " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
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
