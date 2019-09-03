//
//  ImageGalleryCollectionViewCell.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/1/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

protocol ImageGalleryCollectionViewCellDelegate { //RE ep.96 6mins our cell needs to tell the gallery controller that our user has clicked the delete button, so we create a delegate that the controller needs to conform with
    func didClickDeleteButton(indexPath: IndexPath) //RE ep.96 7mins this one is a required function, so it wont have the @objc optional unlike our Property Cell. So we know which cell is clicked
}

class ImageGalleryCollectionViewCell: UICollectionViewCell { //RE ep.96 0mins
    
    var indexPath: IndexPath! //RE ep.96 5mins need for reference for deleting which cell
    var delegate: ImageGalleryCollectionViewCellDelegate? //RE ep.96 8mins create a delegate and optional
    
    
    @IBOutlet weak var imageView: UIImageView! //RE ep.96 1min
    
    
//MARK: Methods
    func generateCell(image: UIImage, indexPath: IndexPath) { //RE ep.96 4mins
        self.indexPath = indexPath //RE ep.96 6mins
        self.imageView.image = image //RE ep.96 5mins pass our image that we receive in this parameter
    }
    
    
//MARK: IBActions
    @IBAction func deleteButtonTapped(_ sender: Any) { //RE ep.96 2mins
        
        delegate?.didClickDeleteButton(indexPath: self.indexPath) //RE ep.96 9mins pass the indexPath of the cell of the selected deleteButton
    }
    
}
