//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jeffrey Chau on 17/09/2015.
//  Copyright (c) 2015 Tigerspike. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    var allSavedMemes = [Meme]()
    let reuseIdentifier = "SavedMemes"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // show tab bar
        tabBarController?.tabBar.hidden = false
        let memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        allSavedMemes = memes
        collectionView!.reloadData()
    }
    
    // MARK: Collection View Controller Delegates
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allSavedMemes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        let meme = allSavedMemes[indexPath.item]
        
        // Changing content mode to aspect fill
        let imageView = UIImageView(image: meme.modifiedImage)
        imageView.contentMode = .ScaleAspectFill
        
        cell.backgroundView = imageView
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = allSavedMemes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
}