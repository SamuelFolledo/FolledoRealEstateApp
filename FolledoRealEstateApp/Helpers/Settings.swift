//
//  Settings.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/15/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import UIKit


private let dateFormat = "yyyyMMddHHmmss" //RE ep.12 3mins made it private so it will remain constant and wont be changed at all outside of this file

func dateFormatter() -> DateFormatter { //RE ep.12 1min DateFormatter = A formatter that converts between dates and their textual representations.
    let dateFormatter = DateFormatter() //RE ep.12 2mins
    dateFormatter.dateFormat = dateFormat //RE ep.12 3mins
    
    return dateFormatter //RE ep.12 4mins
}


func imageFromData(pictureData: String, withBlock: (_ image: UIImage?) -> Void ) { //RE ep.105 3mins string to image method for avatar
    var image: UIImage? //RE ep.105 4mins container for our image
    
    let decodedData = NSData(base64Encoded: pictureData, options: NSData.Base64DecodingOptions(rawValue: 0)) //RE ep.105 5mins this will decode our string to an NSData
    
    image = UIImage(data: decodedData! as Data) //RE ep.105 5mins assign our image to our decodedData
    withBlock(image) //RE ep.105 6mins
}

extension UIImage { //RE ep.106 4mins 'extension' means we take a class that we are extending and add extra functions that we want to user for our extended class //to make our AVATAR IMAGE ROUND
    var isPortrait: Bool { return size.height > size.width } //RE ep.106 5mins check if portrait or landscape, and returning the height and width differences
    var isLandscape: Bool { return size.width > size.height } //RE ep.106 5mins
    var breadth: CGFloat { return min(size.width, size.height) } //RE ep.106 5mins returns the screen's minimum width or height
    var breadthSize: CGSize { return CGSize(width: breadth, height: breadth) } //RE ep.106 5mins set our minimum width or height
    var breadthRect: CGRect { return CGRect(origin: .zero, size: breadthSize) } //RE ep.106 5mins sete the rect here
    
    var circleMasked: UIImage? { //RE ep.106 5mins now that we have a square image, we checked if the view is portrait or landscape. Now we make the image round
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale) //RE ep.106 5mins
        defer { UIGraphicsEndImageContext() } //RE ep.106 5mins if we dont have any image, dont start it
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor( (size.width - size.height) / 2 ) : 0,
                                                                         y: isPortrait ? floor( (size.height - size.width) / 2 ) : 0),
                                                                        size: breadthSize)) else { return nil } //RE ep.106 5mins convert our UIImage and crop it
        UIBezierPath(ovalIn: breadthRect).addClip() //RE ep.106 5mins create a bezier path
        UIImage(cgImage: cgImage).draw(in: breadthRect) //RE ep.106 5mins create a UIImage from a CgImage
        return UIGraphicsGetImageFromCurrentImageContext() //RE ep.106 5mins returns our circle image
    }
    
    
    func scaleImageToSize(newSize: CGSize) -> UIImage { //RE ep.106 5mins
        var scaledImageRect = CGRect.zero //RE ep.106 5mins create a
        
        let aspectWidth = newSize.width / size.width //RE ep.106 5mins
        let aspectHeight = newSize.height / size.height //RE ep.106 5mins
        
        let aspectRatio = max(aspectWidth, aspectHeight) //RE ep.106 5mins
        
        scaledImageRect.size.width = size.width * aspectRatio //RE ep.106 5mins
        scaledImageRect.size.height = size.height * aspectRatio //RE ep.106 5mins
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0; //RE ep.106 5mins
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0; //RE ep.106 5mins
        
        UIGraphicsBeginImageContext(newSize) //RE ep.106 5mins
        draw(in: scaledImageRect) //RE ep.106 5mins
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() //RE ep.106 5mins
        UIGraphicsEndImageContext() //RE ep.106 5mins
        
        return scaledImage! //RE ep.106 5mins return our scaled image back
    }
    
    
}

