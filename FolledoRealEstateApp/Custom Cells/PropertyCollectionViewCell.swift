//
//  PropertyCollectionViewCell.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit


@objc protocol PropertyCollectionViewCellDelegate { //RE ep.45 1min objc required if we want an optional function
    
    @objc optional func didClickStarButton(property: Property) //RE ep.45 2-3mins 1 of our 2 optional funcs for if user click on the star button
    @objc optional func didClickMenuButton(property: Property) //RE ep.45 4mins Menu Button will allow the seller to mark properties as sold
}


class PropertyCollectionViewCell: UICollectionViewCell { //RE ep.29 5mins
    
    var property: Property! //RE ep.42 1min
    var delegate: PropertyCollectionViewCellDelegate? //RE ep.45 5mins whoever wants to conform to the protocol, they will assign themselves as the delegate
    
    
    @IBOutlet weak var imageView: UIImageView! //RE ep.29 6mis
    @IBOutlet weak var topAdImageView: UIImageView! //RE ep.29 13mins
    @IBOutlet weak var soldImageView: UIImageView! //RE ep.29 14mins
    
    @IBOutlet weak var titleLabel: UILabel! //RE ep.29 7mins
    @IBOutlet weak var starButton: UIButton! //RE ep.29 7mins
    
    @IBOutlet weak var roomLabel: UILabel! //RE ep.29 8mins
    @IBOutlet weak var bathroomLabel: UILabel! //RE ep.29 8mins
    @IBOutlet weak var parkingLabel: UILabel! //RE ep.29 8mins
    @IBOutlet weak var priceLabel: UILabel! //RE ep.29 8mins
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! //RE ep.29 14mins
    
    
    
//generateCell
    func generateCell(property: Property) { //RE ep.30 0mins generate cell will have title, checks if its topAd or Sold property, with image, rooms, bathrooms, parking, and price //RE ep.32 6mins property type changed from String to Property class
        self.property = property //RE ep.42 1min
        
        titleLabel.text = property.title //RE ep.32 7mins
        roomLabel.text = "\(property.numberOfRooms)" //RE ep.32 7mins
        bathroomLabel.text = "\(property.numberOfBathrooms)" //RE ep.32 8mins
        parkingLabel.text = "\(property.parking)" //RE ep.32 8mins
        
        priceLabel.text = "$\(property.price)" //RE ep.32 9mins
        priceLabel.sizeToFit() //RE ep.32 9mins resizes view to fit
        
    //top ad
        if property.inTopUntil != nil && property.inTopUntil! > Date() { //RE ep.42 5mins check if inTopUntil has a value and is greater than the currentDate
            topAdImageView.isHidden = false //RE ep.42 if true, then show the topAd
        } else { //RE ep.42 6mins otherwise not topAd so hide the imageView
            topAdImageView.isHidden = true //RE ep.42 6mins
        }
        
    //like property //RE ep.47 0min
        if self.starButton != nil { //RE ep.47 1min check if it is liked, or star button to prevent error
            if FUser.currentUser() != nil && FUser.currentUser()!.favoriteProperties.contains(property.objectId!) { //RE ep.47 2mins check if we have a user and if user's favoriteProps contains our property's objectId
                self.starButton.setImage(UIImage(named: "starFilled"), for: .normal) //RE ep.47 3mins
            } else { //RE ep.47 3mins
                self.starButton.setImage(UIImage(named: "star"), for: .normal) //RE ep.47 4mins
            }
        }
        
    //check if sold
        if property.isSold { //RE ep.42 2mins
            soldImageView.isHidden = false //RE ep.42 2mins show sold imageView
        } else { //RE ep.42 2mins
            soldImageView.isHidden = true //RE ep.42 3mins
        }
        
    //check image
        if property.imageLinks != "" && property.imageLinks != nil { //RE ep.42 3mins check we have link for our images
        //download images
            downloadImages(urls: property.imageLinks!) { (images) in //RE ep.55 0mins
               
                DispatchQueue.main.async {
                    
                
                    self.loadingIndicator.stopAnimating() //RE ep.55 1mins stop animating after downloading our images
                    self.loadingIndicator.isHidden = true //RE ep.55 1mins
                    self.imageView.image = images.first! //RE ep.55 2mins
                }
            }
            
        } else { //RE ep.42 4mins
            self.imageView.image = UIImage(named: "propertyPlaceholder") //RE ep.42 4mins
            self.loadingIndicator.stopAnimating() //RE ep.42 4mins
            self.loadingIndicator.isHidden = true //RE ep.42 4mins
        }
    }
    
    
    @IBAction func starButtonTapped(_ sender: Any) { //RE ep.29 9mins
        delegate!.didClickStarButton!(property: property) //RE ep.45 6mins //IMPORTANT to include cell.delegate = self in our ViewController's cellForItemAt before generating cell
        
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) { //RE ep.84 9mins replaced the starButton's position in the cell
        delegate!.didClickMenuButton!(property: property) //RE ep.87 1min
    }
}

