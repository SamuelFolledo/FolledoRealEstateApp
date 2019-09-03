//
//  RecentViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class RecentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PropertyCollectionViewCellDelegate { //RE ep.29 0mins //RE ep.32 0mins UICVDelegate, UICVDataSource, UICVFlowLayout added //RE ep.45 7mins customized protocol name PropertyCollectionViewCellDelegate is added
    
    var properties: [Property] = [] //RE ep.32 1min
    
    var numberOfPropertiesTextField: UITextField? //RE ep.43 3mins
    

    @IBOutlet weak var collectionView: UICollectionView! //RE ep.29 3mins
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() { //RE ep.32 2mins
        collectionView.collectionViewLayout.invalidateLayout() //RE ep.32 2mins invalidateLayout = Invalidates the current layout and triggers a layout update.
    }
    
    override func viewWillAppear(_ animated: Bool) { //RE ep.32 1min
        //load properties
        loadProperties(limitNumber: kRECENTPROPERTYLIMIT) //RE ep.33 8mins load properties with limit. If user didnt put any number, limit it by default of 20
    }
    
    
//MARK: CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //RE ep.32 3mins how many items in 1 section
        return properties.count //RE ep.32 4mins
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //RE ep.36 4mins tell what cell to represent, we'll reuse the cell from storyboard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell //RE ep.32 5mins since this was a customed cell, we have to return as PropertyCollectionViewCell
        cell.delegate = self //RE ep.46 4mins for our cell's start/menu button protocol
        cell.generateCell(property: properties[indexPath.row]) //RE ep.32 10mins call and generateCell from our arrays of properties
        
        return cell //RE ep.32 6mins
    }
    

//MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { //RE ep.33 1min this is when user taps on a cell
        
        let propertyView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "propertyController") as! PropertyViewController //RE ep.69 6mins our propertyViewController
        
        propertyView.property = properties[indexPath.row] //RE ep.73 here we are passing the property of our selected property from our properties array
        
        self.present(propertyView, animated: true, completion: nil) //RE ep.69 6mins
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { //RE ep.33 3mins
        
        return CGSize(width: collectionView.bounds.size.width, height: 320) //RE ep.33 3mins
    }
    
//MARK: Load Properties
    func loadProperties(limitNumber: Int) { //RE ep.33 6mins
        Property.fetchRecentProperties(limitNumber: limitNumber) { (allProperties) in //RE ep.33 7mins fetch our recent properties
            if allProperties.count != 0 { //RE ep.33 7mins see if we actually receive something
                self.properties = allProperties as! [Property] //RE ep.33 8mins set our properties array equal to allProperties
                self.collectionView.reloadData() //RE ep.33 8mins show all our properties
            }
        }
    }
    
    
//MARK: IBActions
    @IBAction func mixerButtonTapped(_ sender: Any) { //RE ep.29 3mins
        let alert = UIAlertController(title: "Update", message: "Set the number of properties to display", preferredStyle: .alert) //RE ep.43 0min
        alert.addTextField { (numberOfProperties) in //RE ep.43 1min
            numberOfProperties.placeholder = "Number of Properties" //RE ep.43 1min
            numberOfProperties.borderStyle = .roundedRect //RE ep.43 2mins
            numberOfProperties.keyboardType = .numberPad //RE ep.43 2mins //now we need a textfield so we can assign it to so it will be a global value
            
            self.numberOfPropertiesTextField = numberOfProperties //RE ep.43 3mins
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in //RE ep.43 4mins .cancel style is bolded
            return
        }
        let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in //RE ep.43 4mins
            if self.numberOfPropertiesTextField?.text != "" && self.numberOfPropertiesTextField!.text != "0" { //RE ep.43 5mins check if our textfield has a value //RE ep.44 0min && added, Since loadProperties calls fetchRecent, if we have 0 topAd, it will not call and reload the table. So we added this extra error check to make sure user doesnt or is not allowed to put 0 results
                ProgressHUD.show("Updating...") //RE ep.43 5mins show user we're updating...
                self.loadProperties(limitNumber: Int(self.numberOfPropertiesTextField!.text!)!) //RE ep.43 6mins call this controller's method that loads properties based on the passed Int parameter
                ProgressHUD.dismiss()
            }
        }
        alert.addAction(cancelAction) //RE ep.43 7mins
        alert.addAction(updateAction) //RE ep.43 7mins
        self.present(alert, animated: true, completion: nil) //RE ep.43 7mins
    } //RE end of mixerButtonTapped
    
    
//MARK: PropertyCollectionViewCellDelegate methods
    func didClickStarButton(property: Property) { //RE ep.45 7mins our cell is telling that the star button is clicked

        if FUser.currentUser() != nil { //RE ep.45 8mins check if we have a user
            let user = FUser.currentUser()! //RE ep.45 9mins
            if user.favoriteProperties.contains(property.objectId!) { //RE ep.45 9mins check if the property is in user's favoriteProperties array
                let index = user.favoriteProperties.index(of: property.objectId!) //RE ep.45 10mins get the index of that objectId in our array
                user.favoriteProperties.remove(at: index!) //RE ep.45 11mins with the index reference, we can remove the objectId from our favoriteProp
                
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.45 11mins update our current user's favoriteProperties
                    if !success { //RE ep.46 12mins if not success
                        print("Error removing favorite") //RE ep.46 0min
                        Service.presentAlert(on: self, title: "Error removing favorite", message: "Please try again")
                    } else { //RE ep.46 no error
                        self.collectionView.reloadData() //RE ep.46 0mins we need to update our startButton of our collectionView
                        ProgressHUD.show("Removed from the list")
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            ProgressHUD.dismiss()
                        })
                    }
                }
                
            } else { //RE ep.45 9mins its not in our list of favorite, so we add it
                user.favoriteProperties.append(property.objectId!) //RE ep.46 2mins
                
                updateCurrentUser(withValues: [kFAVORIT: user.favoriteProperties]) { (success) in //RE ep.46 1min
                    if !success { //RE ep.46 1min if not success
                        Service.presentAlert(on: self, title: "Error adding property", message: "Please try again")
                    } else { //RE ep.46 1min
                        self.collectionView.reloadData() //RE ep.46 2min
                        ProgressHUD.showSuccess("Added to the list") //RE ep.46 2mins
                    }
                }
                
            }
            
        } else { //RE ep.45 8mins no user so show login/register screen
            
        }
    }
    

}
