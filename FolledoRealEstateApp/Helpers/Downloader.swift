//
//  Downloader.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/22/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage() //RE ep.51 0min

func downloadImages(urls: String, withBlock: @escaping(_ image: [UIImage?]) -> Void) { //RE ep.51 1min get urls separated by commas and returns the images
    let linkArray = separateImageLinks(allLinks: urls) //RE ep.51 6mins split our long link to get all the links for our images
    var imageArray: [UIImage] = [] //RE ep.51 6mins
    
    var downloadCounter = 0 //RE ep.51 6mins counter
    
    for link in linkArray { //RE ep.51 7mins
        let url = NSURL(string: link) //RE ep.51 7mins create an NSUrl from our string link
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue") //RE ep.51 8mins create a queue
        downloadQueue.async { //RE ep.51 8mins queue asynchrously
            downloadCounter += 1 //RE ep.51 9mins
            let data = NSData(contentsOf: url! as URL) //RE ep.51 9mins created a data file
            if data != nil { //RE ep.51 9mins if we have a data, we can create an image from this data
                let image = UIImage(data: data! as Data)! //RE ep.51 10mins
                imageArray.append(image) //RE ep.51 10mins
                
                if downloadCounter == imageArray.count { //RE ep.51 11mins this means we have gone through all the images we had in our array
                    DispatchQueue.main.async { //RE ep.51 11mins
                        withBlock(imageArray) //RE ep.51 11mins
                    }
                }
            } else { //RE ep.51 11mins
                print("Couldnt download image") //RE ep.51 11mins
                withBlock(imageArray) //RE ep.51 11mins so our code will not stop working, pass even if its an empty image array
            }
        }
    }
    
} //end of download images


func uploadImages(images: [UIImage], userId: String, referenceNumber: String, withBlock: @escaping(_ imageLink: String?) -> Void) { //RE ep.52 0min this method takes an array of images and 2 string which will be our reference, and returns a long image's link separated by a comma
    
    convertImagesToData(images: images) { (pictures) in //RE ep.52 5mins convert our array our images to datas before we can upload them
        var uploadCounter = 0, nameSuffix = 0 //RE ep.52 6mins
        var linkString = "" //RE ep.52 6mins
        
        for picture in pictures { //RE ep.52 7mins for every picture, we upload them
            let fileName = "PropertyImages/" + userId + "/" + referenceNumber + "/image" + "\(nameSuffix)" + ".jpg" //RE ep.52 8mins this will be our fileName which will create a new Folder in our Firebase
            nameSuffix += 1 //RE ep.52 10mins
            
            let storageRef = storage.reference(forURL: kFILEREFERENCE) .child(fileName) //RE ep.53 1min
            
            var task: StorageUploadTask!
            task = storageRef.putData(picture, metadata: nil, completion: { (metadata, error) in //RE ep.53 2mins upload our picture data
                uploadCounter += 1 //RE ep.53 3mins
                if let error = error { //RE ep.53 3mins
                    print("error uploading picture \(error.localizedDescription)") //RE ep.53 3mins
                    return //RE ep.53 3mins
                }
                DispatchQueue.main.async {
                    storageRef.downloadURL(completion: { (url, error) in //RE ep.53 4mins get the download URL firebase has saved our images
                        if let error = error {
                            print("Error downloading picture's URL \(error.localizedDescription)") //RE ep.53 4mins
                            return
                        }
                        
                        linkString = linkString + url!.absoluteString + "," //RE ep.53 5mins the comma will separate our links from one another
                        if uploadCounter == pictures.count { //RE ep.53 5mins if our counter is = to our all our pictures...
                            task.removeAllObservers() //RE ep.53 5mins
                            withBlock(linkString) //RE ep.53 6mins
                        }
                    })
                }
            })
        }
    }
}



//MARK: Helpers
func separateImageLinks(allLinks: String) -> [String] { //RE ep.51 3mins takes one long string and separate them by commas
    var linkArray: [String] = allLinks.components(separatedBy: ",") //RE ep.51 4mins separates links everytime we see a comma
    linkArray.removeLast() //RE ep.51 5mins in our backendless's image links, the last character is a comma with nothing after, so we remove the last
    return linkArray //RE ep.51 5mins
}


func convertImagesToData(images: [UIImage], withBlock: @escaping(_ datas: [Data]) -> Void) { //RE ep.52 2mins get images and return their data
    var dataArray: [Data] = [] //RE ep.52 3mins empty array for our data
    for image in images { //RE ep.52 3mins for every image...
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return } //RE ep.52 4mins make a jpeg representation and compress it to half
        dataArray.append(image.jpegData(compressionQuality: 0.5)!) //RE ep.52 4mins
    }
    withBlock(dataArray)
}
