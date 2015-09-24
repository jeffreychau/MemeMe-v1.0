//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jeffrey Chau on 15/09/2015.
//  Copyright (c) 2015 Tigerspike. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var displayedMeme: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // hide tab bar
        tabBarController?.tabBar.hidden = true
        displayedMeme.image = meme.modifiedImage;
    }
}
