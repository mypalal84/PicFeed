//
//  HomeViewController.swift
//  PicFeed
//
//  Created by A Cahn on 3/27/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        //method on HomeViewController
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.dismiss(animated: true, completion: nil)
        print("Info: \(info)")
    }
    

    
    @IBAction func imageTapped(_ sender: Any) {
        
        print("User Tapped Image!")
        
        self.presentActionSheet()
    }

    @IBAction func postButtonPressed(_ sender: Any) {

        if let image = self.imageView.image {
            
            let newPost = Post(image: image)
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                
                if success {
                    
                    print("Saved post successfully to CloudKit!")
                    
                } else {
                    
                    print("We did NOT successfully save to CloudKit...")
                    
                }
            })
        }
    }
    
    
    func presentActionSheet() {
        
      
        let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type", preferredStyle: .actionSheet)
        //initializer^ instance of uialertcontroller
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        
//        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//            cameraAction.isEnabled = false
//        }
//        
//        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//            actionSheetController.addAction(cameraAction)
//        }
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 425, y: 425, width: 1.0, height: 1.0)
       
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}
