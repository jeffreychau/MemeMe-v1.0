//
//  Meme.swift
//  MemeMe
//
//  Created by Jeffrey Chau on 9/09/2015.
//  Copyright (c) 2015 Tigerspike. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let modifiedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, modifiedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.modifiedImage = modifiedImage
    }
}