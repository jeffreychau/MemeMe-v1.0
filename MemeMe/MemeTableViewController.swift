//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jeffrey Chau on 15/09/2015.
//  Copyright (c) 2015 Tigerspike. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    
    var allSavedMemes = [Meme]()
    let reuseIdentifier = "SavedMemes"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // show tab bar
        tabBarController?.tabBar.hidden = false
        let memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        allSavedMemes = memes
        tableView.reloadData()
    }
    
    // MARK: Table View Delegates
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSavedMemes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        let meme = allSavedMemes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.modifiedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = allSavedMemes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
}
