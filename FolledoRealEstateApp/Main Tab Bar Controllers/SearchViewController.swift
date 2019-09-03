//
//  SearchViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/13/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate, SearchParametersViewControllerDelegate { //RE ep.123 2mins //RE ep.123 5mins 1-4 is added //RE ep.134 5 is added for the serach's whereClause
    
    var properties: [Property] = [] //RE ep.123 6mins
    
    
    @IBOutlet weak var collectionView: UICollectionView! //RE ep.123 3mins
    
    
    
    override func viewDidLoad() { //RE ep.123 2mins
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
//MARK:IBActions
    @IBAction func mixerButtonTapped(_ sender: Any) { //RE ep.123 12mins
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchParametersController") as! SearchParametersViewController //RE ep.129 13mins
        
        vc.delegate = self //RE ep.134 6mins needed or our search protocol will not work
        
        self.present(vc, animated: true, completion: nil) //RE ep.129 13mins
    }
    
    
//MARK: CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //RE ep.123 5mins
        return properties.count //RE ep.123 6mins
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //RE ep.123 5mins
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell //RE ep.123 7mins
        cell.delegate = self //RE ep.123 7mins this will take care of the star button
        cell.generateCell(property: properties[indexPath.row]) //RE ep.123 8mins
        return cell //RE ep.123 8mins
    }
    
    
//MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //RE ep.123 9mins called everytime our user touches our cell
        let property = properties[indexPath.row] //RE ep.123 10mins
        
        let propertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "propertyController") as! PropertyViewController //RE ep.123 10mins
        propertyVC.property = property //RE ep.123 11mins
        self.present(propertyVC, animated: true, completion: nil) //RE ep.123 11mins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //RE ep.123 12mins
        return CGSize(width: collectionView.bounds.size.width, height: 320) //RE ep.123 12mins
    }
    
    
//MARK: PropertyCollectionViewCell's delegate
    func didClickStarButton(property: Property) { //RE ep.129 10mins
        if FUser.currentUser() != nil { //RE ep.136 0mins
            let user = FUser.currentUser()! //RE ep.136 1mins
            if user.favoriteProperties.contains(property.objectId!) { //RE ep.136 1mins check if prop is in favorite list and we remove it
                let index = user.favoriteProperties.index(of: property.objectId!) //RE ep.136 1mins
                user.favoriteProperties.remove(at: index!) //RE ep.136 1mins
                
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.136 1min
                    if !success { //RE ep.136
                        ProgressHUD.showError("Error removing favorite") //RE ep.136
                    } else { //RE ep.136
                        self.collectionView.reloadData() //RE ep.136 1mins
                        ProgressHUD.showSuccess("Removed from the list!")
                    }
                }
                
            } else { //RE ep.136 1mins add to the favorite list
                user.favoriteProperties.append(property.objectId!) //RE ep.136 1mins
                
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.136 1mins
                    if !success { //RE ep.136 1mins
                        ProgressHUD.showError("Error adding property") //RE ep.136 1mins
                    } else { //RE ep.136 1mins
                        self.collectionView.reloadData() //RE ep.136 1mins
                        ProgressHUD.showSuccess("Added to the list!") //RE ep.136 1min
                    }
                }
            }
        } else { //RE ep.136 1mins no user
            Service.toRegisterController(on: self) //RE ep.136 1mins
        }
    }
    
//MARK: SearchParameterDelegate
    func didFinishSettingParameters(whereClause: String) { //RE ep.134 0mins
        loadProperties(whereClause: whereClause) //RE ep.134 4mins
    }
    
    
//MARK: Load Properties
    func loadProperties(whereClause : String) { //RE ep.134 1mins
        self.properties = [] //RE ep.134 1mins clean/clear our array in case it got some from previous search
        
        Property.fetchPropertiesWithClause(whereClause: whereClause) { (allProperties) in //RE ep.134 2mins
            
            if allProperties.count > 0 { //RE ep.134 3mins we did receive something from our fetch
                self.properties = allProperties as! [Property] //RE ep.134 3mins
                self.collectionView.reloadData() //RE ep.134 3mins
            } else { //RE ep.134 3mins
                ProgressHUD.showError("No properties for your search") //RE ep.134 4mins
                self.collectionView.reloadData() //RE ep.134 4mins
            }
            
        }
        
    }
    
    
} //EOF
