//
//  ImageGalleryViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/31/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import ImagePicker //RE ep.99 0mins
import IDMPhotoBrowser //RE ep.100 0mins for didSelect


protocol ImageGalleryViewControllerDelegate { //RE ep.98 3mins
    func didFinishEditingImages(allImages: [UIImage]) //RE ep.98 3mins method that will pass the remaining images, create the delegate //Everytime we press save, we tell our delegate controller that here is the updated list of images
}


class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ImageGalleryCollectionViewCellDelegate, ImagePickerDelegate { //RE ep.94 1min //RE ep.95 8mins 1-3 is added //RE ep.97 1min 4 is added for delete buttton
    
    var allImages: [UIImage] = [] //RE ep.95 9mins
    var property: Property? //RE ep.95 10mins will be set once we call our image gallery to display
    var delegate: ImageGalleryViewControllerDelegate? //RE ep.98 4mins
    
    @IBOutlet weak var collectionView: UICollectionView! //RE ep.95 5mins
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //RE ep.95 6mins
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if property != nil { //RE ep.97 3mins
            getPropertyImages(property: property!) //RE ep.97 3mins
        }
        
    }
    
    
    
    override func viewWillLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout() //RE ep.95 10mins
    }
    
    
//MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //RE ep.95 8mins
        return allImages.count //RE ep.95 9mins
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //RE ep.95 8mins
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! ImageGalleryCollectionViewCell //RE ep.96 0mins
        
        cell.generateCell(image: allImages[indexPath.row], indexPath: indexPath) //RE ep.97 0mins
        cell.delegate = self //RE ep.97 1mins conform to the protocol
        
        return cell
    }
    
    
//MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //RE ep.97 9mins
        let photos = IDMPhoto.photos(withImages: allImages) //RE ep.100 1min takes our photos
        let browser = IDMPhotoBrowser(photos: photos)! //RE ep.100 1min
        
        browser.setInitialPageIndex(UInt(indexPath.row)) //RE ep.100 2mins set our first image
        
        self.present(browser, animated: true, completion: nil) //RE ep.100 3mins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //RE ep.97 9mins
        return CGSize(width: collectionView.bounds.size.width / 2 - 10, height: CGFloat(150)) //RE ep.97 10mins make the width half of the view's width - 10 for extra space, and a static height
    }
    
//MARK: IBActions
    @IBAction func backButtonTapped(_ sender: Any) { //RE ep.95 6mins
        self.dismiss(animated: true, completion: nil) //RE ep.98 1mins
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) { //RE ep.95 6mins
        delegate!.didFinishEditingImages(allImages: allImages) //RE ep.98 4mins pass our allImages to our Edit Property // Everytime we click our save button, we take our allImages Array and we pass it our delegate view, that this is the updated images list
        self.dismiss(animated: true, completion: nil) //RE ep.98 5mins
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) { //RE ep.95 6mins
        let imagePickerController = ImagePickerController() //RE ep.99 3mins
        imagePickerController.delegate = self  //RE ep.99 3mins will activate our 3 delegate methods for ImagePicker
        imagePickerController.imageLimit = kMAXIMAGENUMBER //RE ep.99 3mins = 10 imageLimit
        present(imagePickerController, animated: true, completion: nil) //RE ep.99 4mins
    }
    
//MARK: ImageGalleryCell Delegate
    func didClickDeleteButton(indexPath: IndexPath) { //RE ep.97 2mins, to delete, we need to remove the image from: allImagesArray followed by refresh so the collecitonView wont show it, save it online, as well as Gallery needs a way to tell Edit Property that image is removed properly
        allImages.remove(at: indexPath.row) //RE ep.98 0mins remove image from all images
        collectionView.reloadData() //RE ep.98 0mins reload our view
        
        
    }
    
//MARK: Helpers
    func getPropertyImages(property: Property) { //RE ep.97 2mins
        if property.imageLinks != "" && property.imageLinks != nil { //RE ep.97 3mins see if we have imageLinks
            
            downloadImages(urls: property.imageLinks!) { (images) in //RE ep.97 5mins download and return our images
                self.allImages = images as! [UIImage] //RE ep.97 5mins
                self.activityIndicator.stopAnimating() //RE ep.97 6mins
                self.activityIndicator.isHidden = true //RE ep.97 6mins
                self.collectionView.reloadData() //RE ep.97 6mins
            }
            
        } else { //RE ep.97 4mins we have no images
            self.activityIndicator.stopAnimating() //RE ep.97 4mins
            self.activityIndicator.isHidden = true //RE ep.97 4mins
            self.collectionView.reloadData() //RE ep.97 4mins referesh
        }
    }
    
    
//MARK: ImagePickerDelegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.99 1min
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.99 1min if successfull, we need to combine the current images and the new images
        
        self.allImages = allImages + images //RE ep.99 6mins add currentImages and the new selected images
        self.collectionView.reloadData() //RE ep.99 6mins refresh our collection view
        
        self.dismiss(animated: true, completion: nil) //RE ep.99 
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) { //RE ep.99 1min
        self.dismiss(animated: true, completion: nil) //RE ep.99 2mins
    }
}
