//
//  Filters.swift
//  PicFeed
//
//  Created by A Cahn on 3/28/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

typealias FilterCompletion = (UIImage?) -> ()

enum FilterName : String {
    
    case vintage = "CIPhotoEffectTransfer"
    case backAndWhite = "CIPhotoEffectMono"
    case chrome = "CIPhotoEffectChrome"
    case invertColors = "CIColorInvert"
    case fade = "CIPhotoEffectFade"
    //more cases here
}

class Filters {
   
    //singleton
    static let shared = Filters()
    
    let filterNames = ["Black & White", "Chrome", "Fade", "Invert Colors", "Vintage"]
    
    static var originalImage : UIImage?
    // ^ access with Filters.originalImage
    
    var ciContext: CIContext
    
    //true singleton
    private init() {
        
        //GPU context to draw filters on, always the same 3 lines
        let options = [kCIContextWorkingColorSpace: NSNull()]
        
        guard let eaglContext = EAGLContext(api: .openGLES2) else { fatalError("Failed to create EAGLContext") }
        
        self.ciContext = CIContext(eaglContext: eaglContext, options: options)
 
        
    }
    
    class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion) {
     
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name.rawValue) else { fatalError("Failed to create CIFilter.") }
            
            let coreImage = CIImage(image: image)
            
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            
            //Get final image using GPU
            guard let outputImage = filter.outputImage else { fatalError("Failed to get output image from filter.") }
            
            if let cgImage = Filters.shared.ciContext.createCGImage(outputImage, from: outputImage.extent) {
                
                let finalImage = UIImage(cgImage: cgImage)
                
                OperationQueue.main.addOperation {
                    
                    completion(finalImage)
                    
                }
                
            } else {
                
                OperationQueue.main.addOperation {
                    
                    completion(nil)
                }
            }
        }
    }
}
