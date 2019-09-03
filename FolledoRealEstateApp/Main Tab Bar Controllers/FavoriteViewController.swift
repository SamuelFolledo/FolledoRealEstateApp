//
//  FavoriteViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/29/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate { //RE ep.77 //RE ep.78 1min collectionView's delegate, data source, and delegateFlowLayout is added //RE ep.78 4mins propertyCollectionViewCellDelegate is added in order to listen to the star button getting tapped
    
    var properties: [Property] = [] //RE ep.78 0mins
    
    @IBOutlet weak var collectionView: UICollectionView! //RE ep.77 6mins
    
    @IBOutlet weak var noPropertyLabel: UILabel! //RE ep.81 6mins
    
    
    
    override func viewDidLoad() { //RE ep.77
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(String(describing: FUser.currentUser()?.fullName))")
    }
    
    override func viewWillAppear(_ animated: Bool) { //RE ep.79 0mins
        if !isUserLoggedIn(viewController: self) { //RE ep.83 3mins if user is NOT logged in
            self.noPropertyLabel.isHidden = false
            return //RE ep.83 3mins if no user then do nothing
        } else { //RE ep.83 4mins is there is user, load proeprties. This prevents loading properties when there is no user
            loadProperties() //RE ep.79 0mins load it before view appears
        }
    }
    
    override func viewWillLayoutSubviews() { //RE ep.79 0mins
        collectionView.collectionViewLayout.invalidateLayout() //RE ep.79 1mins
    }
    
//MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //RE ep.78 2mins
        return properties.count //RE ep.78 2mins
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //RE ep.78 2mins
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell //RE ep.78 3mins
        cell.generateCell(property: properties[indexPath.row]) //RE ep.78 3mins
        cell.delegate = self //RE ep.78 4mins need to set delegate to self because in our view,we want to be notified when user taps the star button we can remove our cell from our favorites, dont forget to add the protocol
        return cell //RE ep.78 4mins
    }
    
//MARK: CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //RE ep.78 5mins
        let property = properties[indexPath.row] //RE ep.78 5mins
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "propertyController") as! PropertyViewController //RE ep.78 6mins get our PropertyViewController
        
        propertyVC.property = property //RE ep.78 7mins
        self.present(propertyVC, animated: true, completion: nil) //RE ep.78 7mins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //RE ep.78 8mins
        return CGSize(width: collectionView.bounds.size.width, height: 320) //RE ep.78 8mins
    }
    
//MARK: LoadProperties
    func loadProperties() { //RE ep.78 9mins
        self.properties = [] //RE ep.78 9mins everytime we call this method we empty properties array first
        let user = FUser.currentUser()! //RE ep.78 9mins
        let stringArray = user.favoriteProperties //RE ep.78 10mins favoriteProperties is an array of Strings which is the objectId of properties. So once user puts the property in its favorites, it will take the proppertyID and put it in an array
        let stringg = "'" + stringArray.joined(separator: "', '") + "'" //RE ep.78 11-12mins this converts our stringArray of user's favoriteProperties into a single string because BackEndless expects only a single string //RE ep.79 7mins for every item in our favorite array, we are separating them with a "', '"
//        print("SPECIAL STRING \(stringg)") //RE ep.78 13mins
        
        if user.favoriteProperties.count > 0 { //RE ep.78 14mins check if user has favorite properties... generate our whereClause
            self.noPropertyLabel.isHidden = true //RE ep.83 3mins
            
            let whereClause = "objectId IN (\(stringg))" //RE ep.78 14mins checks if objectId is in the string that we have passed //RE ep.79 5mins added a parenthesis between the stringg
            print("WHERE CLAUSE  = \(whereClause)")
            Property.fetchPropertiesWithClause(whereClause: whereClause) { (allProperties) in //RE ep.78 15mins access the properties with our whereClause
                if allProperties.count != 0 { //RE ep.78 15mins check if we receive something back
                    self.properties = allProperties as! [Property] //RE ep.78 16mins
                    self.collectionView.reloadData() //RE ep.78 16mins reload
                }
            }
        } else { //RE ep.78 16mins if favoriteProperties = 0
            self.noPropertyLabel.isHidden = false //RE ep.81 7mins unhide it
            self.collectionView.reloadData() //RE ep.78 16mins reload it
        }
    }
    
//MARK: PropertyCollectionViewCellDelegate
    func didClickStarButton(property: Property) { //RE ep.80 0mins
        
        if FUser.currentUser() != nil { //RE ep.80 1mins since we cant add to fav if we have no user
            let user = FUser.currentUser()! //RE ep.80 3mins
            
            if user.favoriteProperties.contains(property.objectId!) { //RE ep.80 3mins check if property is in user's favorite already using the prop's objectId
    //REMOVE from the list
                let index = user.favoriteProperties.index(of: property.objectId!) //RE ep.80 5mins INDEX = Returns the first index where the specified value appears in the collection //RE ep.80 5mins in order to remove our property from our favorites, we need to access the                index of our property in the fav properties array
                user.favoriteProperties.remove(at: index!) //RE ep.80 5mins
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.80 6mins
                    if !success { //RE ep.80 6mins if not success
                        Service.presentAlert(on: self, title: "Error", message: "Error removing property from the favorite list")
                    } else { //RE ep.80 7mins if no error
                        self.loadProperties() //RE ep.80 7mins
                        ProgressHUD.showSuccess("Removed from the list") //RE ep.80 7mins
                    }
                }
                
            } else { //RE ep.80 4mins its not in our favorite list, so we
    //ADD to the list
                user.favoriteProperties.append(property.objectId!) //RE ep.80 8mins
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.80 8mins
                    self.loadProperties() //RE ep.80 8mins
                    ProgressHUD.showSuccess("Added to the list") //RE ep.80 9mins
                }
            }
            
        } else { //RE ep.80 1min if no user then show registerController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterViewController //RE ep.80 1min
            self.present(vc, animated: true, completion: nil) //RE ep.80 2mins
        }
        
    }
    
    
}
