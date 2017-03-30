//
//  HomeViewController.swift
//  PicFeed
//
//  Created by A Cahn on 3/27/17.
//  Copyright © 2017 A Cahn. All rights reserved.
//

import UIKit

import Social

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let filterNames = [FilterName.backAndWhite, FilterName.chrome, FilterName.fade, FilterName.invertColors, FilterName.vintage]
    
    let constraintConstant : CGFloat = 8
    
    let animationDuration = 1.0
    
    //creating new instance of UIImagePickerController to access it's methods
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    
    //overriding from super
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        setupGalleryDelegate()
        
    }
    
    func setupGalleryDelegate() {
        
        if let tabBarController = self.tabBarController {
            
            guard let viewControllers = tabBarController.viewControllers else { return }
            
            guard let galleryController = viewControllers[1] as? GalleryViewController else { return }
            
            galleryController.delegate = self
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        filterButtonTopConstraint.constant = constraintConstant
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
     
        postButtonBottomConstraint.constant = constraintConstant
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
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
//        print("Info: \(info)")
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {

        self.imageView.image = originalImage
            
        Filters.originalImage = originalImage
            
        self.collectionView.reloadData()
            
        }
        
        self.dismiss(animated: true, completion: nil)

    }
    

    
    @IBAction func imageTapped(_ sender: Any) {
        
        print("User Tapped Image!")
        
        self.presentActionSheet()
    }

    @IBAction func postButtonPressed(_ sender: Any) {

        if let image = self.imageView.image {
            
            let newPost = Post(image: image, date: nil)
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                
                if success {
                    
                    print("Saved post successfully to CloudKit!")
                    
                } else {
                    
                    print("We did NOT successfully save to CloudKit...")
                    
                }
            })
        }
    }
    
    @IBAction func fitlerButtonPressed(_ sender: Any) {
        
        guard self.imageView.image != nil else { return }
        
        self.collectionViewHeightConstraint.constant = 150
        
        UIView.animate(withDuration: 0.5) {
            
            self.view.layoutIfNeeded()
            
        }
    }
    
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
            
            composeController.add(self.imageView.image)
            
            self.present(composeController, animated: true, completion: nil)
            
        }
        
    }
    
    
//        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle: .alert)
//        
//        let blackAndWhiteAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
//            Filters.filter(name: .backAndWhite, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
//            Filters.filter(name: .vintage, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let chromeAction = UIAlertAction(title: "Chrome", style: .default) { (action) in
//            Filters.filter(name: .chrome, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let invertAction = UIAlertAction(title: "Invert Colors", style: .default) { (action) in
//            Filters.filter(name: .invertColors, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let fadeAction = UIAlertAction(title: "Fade", style: .default) { (action) in
//            Filters.filter(name: .fade, image: image, completion: { (filteredImage) in
//                self.imageView.image = filteredImage
//            })
//        }
//        
//        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
//            self.imageView.image = Filters.originalImage
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        alertController.addAction(blackAndWhiteAction)
//        alertController.addAction(vintageAction)
//        alertController.addAction(chromeAction)
//        alertController.addAction(invertAction)
//        alertController.addAction(fadeAction)
//        alertController.addAction(resetAction)
//        alertController.addAction(cancelAction)
//        
//        
//        self.present(alertController, animated: true, completion: nil)
        
    
    
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
        
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 425, y: 425, width: 1.0, height: 1.0)
       
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}

//MARK: UICollectionView DataSource
extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell
        
        guard let originalImage = Filters.originalImage else { return filterCell }
        
        guard let resizedImage = originalImage.resize(size: CGSize(width: 150, height: 150)) else { return filterCell}
                
        let filterName = self.filterNames[indexPath.row]
        
        Filters.filter(name: filterName, image: resizedImage) { (filteredImage) in
            
            filterCell.imageView.image = filteredImage
            
        }
        
        return filterCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filterNames.count
    }
}

extension HomeViewController : GalleryViewControllerDelegate {
    
    func galleryController(didSelect image: UIImage) {
        
        self.imageView.image = image
        
        self.tabBarController?.selectedIndex = 0
    }
}
