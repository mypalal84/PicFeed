//
//  GalleryCell.swift
//  PicFeed
//
//  Created by A Cahn on 3/29/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post : Post! {
        
        didSet {
            
            self.imageView.image = post.image
            
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.imageView.image = nil
        
    }
}
