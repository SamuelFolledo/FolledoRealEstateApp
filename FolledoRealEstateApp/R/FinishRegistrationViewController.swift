//
//  FinishRegistrationViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import ImagePicker

class FinishRegistrationViewController: UIViewController, ImagePickerDelegate { //RE ep.147 0mins //RE ep.148 3mins 1 is added
    
    var avatarImage: UIImage? //RE ep.148 0mins
    var avatar = "" //RE ep.148 0mins
    var company = "" //RE ep.148 0mins
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView! //RE ep.147 2mins
    @IBOutlet weak var topLabel: UILabel! //RE ep.147 2mins
    @IBOutlet weak var nameTextField: UITextField! //RE ep.147 2mins
    @IBOutlet weak var surnameTextField: UITextField! //RE ep.147 2mins
    @IBOutlet weak var companyTextField: UITextField! //RE ep.147 2mins
    
    
    override func viewDidLoad() { //RE ep.147 0mins
        super.viewDidLoad()
        //toFinishRegisterSegue
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.mainView.addGestureRecognizer(tap)

    }
    
//MARK: ImagePicker Delegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.148 3mins
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.148 3mins
        avatarImage = images.first //RE ep.148 3minsgrab first and only image
        avatarImageView.image = avatarImage!.circleMasked //RE ep.148 3mins force unwrap it //RE ep.106 9mins 'circleMasked' added from extension that will turn a square image to round
        
        self.dismiss(animated: true, completion: nil) //RE ep.148 3mins
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) { //RE ep.148 3mins
        self.dismiss(animated: true, completion: nil) //RE ep.148 3mins
    }
    
    
//MARK: IBActions
    @IBAction func cameraButtonTapped(_ sender: Any) { //RE ep.147 2mins
        let imagePickerController = ImagePickerController() //RE ep.148 4mins
        imagePickerController.delegate = self //RE ep.148 4mins
        imagePickerController.imageLimit = 1 //RE ep.148 4mins
        
        present(imagePickerController, animated: true, completion: nil) //RE ep.148 4mins
    }
    
    
    @IBAction func finishRegistrationButtonTapped(_ sender: Any) { //RE ep.147 2mins
        if nameTextField.text != "" && surnameTextField.text != "" { //RE ep.148 5mins check if our tf has texts
            ProgressHUD.show("Registering....") //RE ep.148 5mins
            
            if self.avatarImage != nil { //RE ep.148 6mins if we have an avatarImage...
                let image = avatarImage?.jpegData(compressionQuality: 0.6) //RE ep.148 6mins change it to a data
                avatar = image!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) //RE ep.148 7mins this take our image data file to a string
            }
            
            if companyTextField.text != "" { //RE ep.148 8mins if we have a value...
                company = companyTextField.text! //RE ep.148 8mins then we update our company
            }
            
            register() //RE ep.148 9mins
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) { //RE ep.147 2mins once the user registers with their number and input the sms code, the user is created, but we are not creating an object for it in our Firebase Database -ish. So we if the user taps on dismiss, we also have to delete the user for not completing the registration
        self.deleteUser() //RE ep.150 0mins
//        self.dismiss(animated: true, completion: nil) //RE ep.148 0mins
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterController") as! RegisterViewController
        vc.isPhoneNumberRestart = true
//        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
//        vc.selectedIndex = 4 //index of MyProperties
        self.present(vc, animated: true, completion: nil)
    }
    
    
//MARK: Helpers functions //RE ep.148
    func register() { //RE ep.148 9mins
        let user = FUser.currentUser()! //RE ep.148 10mins access our current user since registering already created it, but we can access this unfinished user like this and fill the rest of its info
        user.firstName = nameTextField.text! //RE ep.148 11mins
        user.lastName = surnameTextField.text! //RE ep.148 11mins
        user.fullName = nameTextField.text! + " " + surnameTextField.text! //RE ep.148 11mins
        user.avatar = avatar //RE ep.148 12mins
        user.company = company //RE ep.148 12mins
        
        updateCurrentUser(withValues: [kFIRSTNAME: user.firstName, kLASTNAME: user.lastName, kFULLNAME: user.fullName, kAVATAR: user.avatar, kCOMPANY: user.company]) { (success) in //RE ep.148 13-14mins
            if !success { //RE ep.148 14mins
                print("Error updating user") //RE ep.148 14mins
                ProgressHUD.showError("Error updating user") //RE ep.148 15mins
                return //RE ep.148 15mins
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": FUser.currentId()]) //RE ep.148 15-17mins post a notification that a user logged in //post = Creates a notification with a given name, sender, and information and posts it to the notification center. //UserDidLoginNotification was called in AppDelegate.swift
            
            Service.toHomeTabController(on: self) //RE ep.148 17mins
        }
        
    }
    
    
    func deleteUser() { //RE ep.150 0mins
        let userId = FUser.currentId() //RE ep.150 0mins
    //delete locally
        UserDefaults.standard.removeObject(forKey: kCURRENTUSER) //RE ep.150 1mins remove the current user
        UserDefaults.standard.removeObject(forKey: "OneSignalId") //RE ep.150 1mins remove the OneSignalId
        UserDefaults.standard.synchronize() //RE ep.150 1mins refresh
    //logout user and delete
        firDatabase.child(kUSER).child(userId).removeValue { (error, ref) in //RE ep.150 2-3mins
            if let error = error { //RE ep.150 4mins
                Service.presentAlert(on: self, title: "Error removing user", message: "\(error.localizedDescription)") //RE ep.150 4mins
                return //RE ep.150 4mins
            }
            
        //if no error, then delete the user from Firebase's Authentication
            FUser.deleteUser(completion: { (error) in //RE ep.150 7mins
                if error != nil { //RE ep.150 7mins
                    Service.presentAlert(on: self, title: "Error Deleting User", message: "\(String(describing: error?.localizedDescription))") //RE ep.150 8mins
                    return //RE ep.150 8mins
                }
                Service.toHomeTabController(on: self) //RE ep.150 8mins
            })
        }
        
    }
    
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }
    
}
