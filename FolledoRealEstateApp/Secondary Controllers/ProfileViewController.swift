//
//  ProfileViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/2/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import ImagePicker //RE ep.104 5mins

class ProfileViewController: UIViewController, ImagePickerDelegate { //RE ep.104 0mins //RE ep.104 5mins 1 is added
    
    
    var avatarImage: UIImage? //RE ep.104 5mins
    
    @IBOutlet weak var avatarImageView: UIImageView! //RE ep.104 4mins
    @IBOutlet weak var coinLabel: UILabel! //RE ep.104 4mins
    
    @IBOutlet weak var nameTextField: UITextField! //RE ep.104 4mins
    @IBOutlet weak var surnameTextField: UITextField! //RE ep.104 4mins
    @IBOutlet weak var mobileTextField: UITextField! //RE ep.104 4mins
    @IBOutlet weak var additionalPhoneTextField: UITextField! //RE ep.104 4mins
    
//VIEW DID LOAD
    override func viewDidLoad() { //RE ep.104 0mins
        super.viewDidLoad()
        
        updateUI()
        print("\(String(describing: FUser.currentUser()?.fullName))")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    
//MARK: Helpers
    func saveChanges() { //RE ep.108 0mins
        var addPhone = "" //RE ep.108 1mins
        if additionalPhoneTextField.text != "" { //RE ep.108 1mins
            addPhone = additionalPhoneTextField.text! //RE ep.108 1mins
        }
        
        var phoneNumber: String = ""
        var avatarLink: String = "\(FUser.currentUser()?.avatar ?? "")" //avatarLink with "" default value
        
        if mobileTextField.text != "" {
            phoneNumber = mobileTextField.text!
        }
        
    //name textfields
        if nameTextField.text != "" && surnameTextField.text != "" { //RE ep.108 2mins check if nameTextField is empty
            
            ProgressHUD.show("Saving...") //RE ep.108 3mins
            var values = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kPHONE: phoneNumber, kADDPHONE: addPhone, kAVATAR: avatarLink] //RE ep.108 3mins addPhone is an empty string unless the user inputs in additionalPhoneTF
            
        //phoneNumber
            if phoneNumber != "" && phoneNumber.count > 9 { //if phone number is empty or greater than 9
                values = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kPHONE: phoneNumber, kADDPHONE: addPhone, kAVATAR: avatarLink] //RE ep.108 5mins
            } else if phoneNumber == "" { print("No phone number") }
            else {
                ProgressHUD.showError("Invalid Phone Number")
                return
            }
            
        //avatar image
            if avatarImage != nil { //RE ep.108 4mins check if we have an avatar image, then we save it as well
                
                let image = avatarImage!.jpegData(compressionQuality: 0.6) //RE ep.108 6mins convert an image to data
                avatarLink = image!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) //RE ep.108 7mins converts a data to string as a parameter for our avatar in values
                
                values = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kPHONE: phoneNumber, kADDPHONE: addPhone, kAVATAR: avatarLink] //RE ep.108 5mins
            }
            
            values = [kFIRSTNAME: nameTextField.text!, kLASTNAME: surnameTextField.text!, kPHONE: phoneNumber, kADDPHONE: addPhone, kAVATAR: avatarLink] //RE ep.108 5mins
            
            print("Avatar link is ===== \(avatarLink)\nphoneNumber is ===== \(phoneNumber)")
            
            
            
            updateCurrentUser(withValues: values) { (success) in //RE ep.108 8mins
                if !success { //RE ep.108 8mins
                    ProgressHUD.showError("Couldn't Update User") //RE ep.108 8mins
                } else { //RE ep.108 8mins if its successful
                    ProgressHUD.showSuccess("Saved!") //RE ep.108 8mins
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            
        } else { //RE ep.108 2mins if there is no name and surname
            ProgressHUD.showError("Name and Surname cannot be empty")
        }
        
    }
    
    
    
    func updateUI() { //RE ep.104 7mins
    //set images to our text fields
        let mobileImageView = UIImageView(image: UIImage(named: "Mobile")) //RE ep.104 7mins
        mobileImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) //RE ep.104 8mins
        mobileImageView.contentMode = .scaleAspectFit //RE ep.104 9mins
        
        let mobileImageView1 = UIImageView(image: UIImage(named: "Mobile")) //RE ep.104 9mins
        mobileImageView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30) //RE ep.104 9mins
        mobileImageView1.contentMode = .scaleAspectFit //RE ep.104 9mins
        
        let contactImageView = UIImageView(image: UIImage(named: "ContactLogo")) //RE ep.104 10mins
        contactImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) //RE ep.104 10mins
        contactImageView.contentMode = .scaleAspectFit //RE ep.104 10mins
        
        let contactImageView1 = UIImageView(image: UIImage(named: "ContactLogo")) //RE ep.104 10mins
        contactImageView1.frame = CGRect(x: 0, y: 0, width: 30, height: 30) //RE ep.104 10mins
        contactImageView1.contentMode = .scaleAspectFit //RE ep.104 10mins
        
        nameTextField.leftViewMode = .always //RE ep.104 11mins Always appear leftViewMode
        nameTextField.leftView = contactImageView //RE ep.104 11mins
        nameTextField.addSubview(contactImageView) //RE ep.104 12mins add it
        
        surnameTextField.leftViewMode = .always //RE ep.105 0mins
        surnameTextField.leftView = contactImageView1 //RE ep.105 0mins
        surnameTextField.addSubview(contactImageView1) //RE ep.105 0mins
        
        mobileTextField.leftViewMode = .always //RE ep.105 0mins
        mobileTextField.leftView = mobileImageView //RE ep.105 0mins
        mobileTextField.addSubview(mobileImageView) //RE ep.105 0mins
        
        additionalPhoneTextField.leftViewMode = .always //RE ep.105 0mins
        additionalPhoneTextField.leftView = mobileImageView1 //RE ep.105 0mins
        additionalPhoneTextField.addSubview(mobileImageView1) //RE ep.105 0mins
        
        updateValuesOfTextFieldsAndImageView()
    }
    
    
    func updateValuesOfTextFieldsAndImageView() {
    //fill out the text in the text fields
        let user = FUser.currentUser()! //RE ep.105 1min
        nameTextField.text = user.firstName //RE ep.105 2mins
        surnameTextField.text = user.lastName //RE ep.105 2mins
        mobileTextField.text = user.phoneNumber //RE ep.105 2mins
        additionalPhoneTextField.text = user.additionalPhoneNumber //RE ep.105 2mins
        coinLabel.text = "\(user.coins)"
        
        
        if user.avatar != "" { //RE ep.105 2mins if true, it means we have an image
            imageFromData(pictureData: user.avatar) { (image) in //RE ep.105 6mins convert string data to an image
                self.avatarImageView.image = image!.circleMasked //RE ep.105 7mins //RE ep.106 9mins make the image round
            }
        }
    }
    
    func removeValuesOfTextFieldsAndImageView() {
        nameTextField.text = "" //RE ep.105 2mins
        surnameTextField.text = "" //RE ep.105 2mins
        mobileTextField.text = "" //RE ep.105 2mins
        additionalPhoneTextField.text = "" //RE ep.105 2mins
        
        
        self.avatarImageView.image = UIImage(named: "img_placeholder")
    }
    
    
//MARK: Selectors
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    
    
//MARK: IBActions
    @IBAction func backButtonTapped(_ sender: Any) { //RE ep.104 4mins
        self.dismiss(animated: true, completion: nil) //RE ep.107 0mins
    }
    
    
    @IBAction func menuButtonTapped(_ sender: Any) { //RE ep.104 4mins
        let user = FUser.currentUser()! //RE ep.107 0mins
        
        let optionMenu = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet) //RE ep.107 0mins
        let accountTypeString = user.isAgent ? "You are Agent" : "Become an Agent" //RE ep.107 1mins dynamic title for our action
        
        let accountTypeAction = UIAlertAction(title: accountTypeString, style: .default) { (alert) in //RE ep.107 2mins
             print("Account")
            
            if !user.isAgent { //RE ep.143 2mins if user is not an agent...
                self.agentSubscription() //RE ep.143 3mins
            }
        }
        
        let restorePurchaseAction = UIAlertAction(title: "Restore Purchase", style: .default) { (alert) in //RE ep.107 5mins
            self.restorePurchase() //RE ep.143 1mins
            print("Restore purchases")
            
        }
        
        let buyCoinsAction = UIAlertAction(title: "Buy Coins", style: .default) { (alert) in //RE ep.107 5mins
            self.buyCoins() //RE ep.143 1mins
            print("Buy coins")
//            IAPService.shared.purchase(product: .coins) //RE ep.142 0mins
        }
        
        let saveChangesAction = UIAlertAction(title: "Save Changes", style: .default) { (alert) in
            self.saveChanges() //RE ep.108 0mins
        }
        
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (alert) in //RE ep.107 5mins
            let userFullName = user.fullName
            
            FUser.logOutCurrentUser(withBlock: { (success) in //RE ep.109 7mins
                if !success {
                    Service.presentAlert(on: self, title: "Error", message: "Error loggin out")
                } else { //RE ep.109 7mins if successful
//                    self.removeValuesOfTextFieldsAndImageView()
                    
                    print("\(userFullName) is Logged out successfully!")
                    Service.clearUserDefaults()
                    Service.toRegisterController(on: self) //RE ep.109 8mins
                }
            })
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in //RE ep.107 5mins
            optionMenu.dismiss(animated: true, completion: nil)
        }
        
        optionMenu.addAction(saveChangesAction) //RE ep.107 5mins
        optionMenu.addAction(buyCoinsAction) //RE ep.107 5mins
        optionMenu.addAction(accountTypeAction) //RE ep.107 5mins
        optionMenu.addAction(restorePurchaseAction) //RE ep.107 5mins
        optionMenu.addAction(logoutAction) //RE ep.107 5mins
        optionMenu.addAction(cancelAction) //RE ep.107 5mins
        
        self.present(optionMenu, animated: true, completion: nil) //RE ep.107 5mins
        
    }//End of ManuButton Tapped
    
    
//MARK: IAPurchases
    func buyCoins() { //RE ep.143 0mins
        IAPService.shared.purchase(product: .coins) //RE ep.143 1mins
    }
    
    func restorePurchase() { //RE ep.143 1mins
        IAPService.shared.restorePurchase() //RE ep.143 2mins
    }
    
    func agentSubscription() { //RE ep.143 3mins
        IAPService.shared.purchase(product: .agentSubscription) //RE ep.143 3mins
    }
    
    
    
//MARK: IBActions
    @IBAction func changeAvatarButtonTapped(_ sender: Any) { //RE ep.104 4mins
        let imagePickerController = ImagePickerController() //RE ep.106 0mins
        imagePickerController.delegate = self //RE ep.106 0mins
        imagePickerController.imageLimit = 1 //RE ep.106 1min limit the user to 1 avatar image only
        
        present(imagePickerController, animated: true, completion: nil) //RE ep.106 1mins
    }
    
    @IBAction func buyCoinsButtonTapped(_ sender: Any) { //RE ep.104 4mins
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let user = FUser.currentUser()!
        
        let optionMenu = UIAlertController(title: "\(user.firstName) Logout?", message: nil, preferredStyle: .actionSheet) //RE ep.107 0mins
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (alert) in //RE ep.107 5mins
            
            FUser.logOutCurrentUser(withBlock: { (success) in //RE ep.109 7mins
                if !success {
                    Service.presentAlert(on: self, title: "Error", message: "Error loggin out")
                } else { //RE ep.109 7mins if successful
                    //                    self.removeValuesOfTextFieldsAndImageView()
                    
                    print("\(user.fullName) is Logged out successfully!")
                    Service.clearUserDefaults()
                    Service.toRegisterController(on: self) //RE ep.109 8mins
                }
            })
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in //RE ep.107 5mins
            optionMenu.dismiss(animated: true, completion: nil)
        }
        
        
        optionMenu.addAction(logoutAction) //RE ep.107 5mins
        optionMenu.addAction(cancelAction) //RE ep.107 5mins
        
        
    }
    
    
//MARK: ImagePicker Delegate
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.104 5mins
        
    }
    

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.104 5mins
        
        avatarImage = images.first //RE ep.106 1mins grab first and only image
        avatarImageView.image = avatarImage!.circleMasked //RE ep.106 2mins force unwrap it //RE ep.106 9mins 'circleMasked' added from extension that will turn a square image to round
        
        self.dismiss(animated: true, completion: nil) //RE ep.104 6mins
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) { //RE ep.104 5mins
        self.dismiss(animated: true, completion: nil) //RE ep.104 6mins
    }
    
    
    
    
}
