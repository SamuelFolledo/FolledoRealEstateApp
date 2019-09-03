//
//  RegisterViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/15/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    var phoneNumber: String? //RE ep.20 2mins
    var isPhoneNumberRestart: Bool = false
    
    //spinner
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.center = self.view.center
        spinner.startAnimating()
        return spinner
    }()
    
//phone
    @IBOutlet weak var phoneNumberTextField: UITextField! //RE ep.10
    @IBOutlet weak var codeTextField: UITextField! //RE ep.10
    @IBOutlet weak var requestButton: UIButton! //RE ep.10
    
//email
    @IBOutlet weak var emailTextField: UITextField! //RE ep.10
    @IBOutlet weak var firstNameTextField: UITextField! //RE ep.10
    @IBOutlet weak var lastNameTextField: UITextField! //RE ep.10
    @IBOutlet weak var passwordTextField: UITextField! //RE ep.10
    
    
    @IBOutlet weak var loginOrRegisterSwitcherButton: UIButton!
    @IBOutlet weak var loginOrRegisterWithEmailButton: UIButton!
    
    var isLoginMode = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Current logged in user for some reason is.... \(String(describing: FUser.currentUser()?.fullName))")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isPhoneNumberRestart == true {
            isPhoneNumberRestart = true
            phoneNumberTextField.text = ""
            phoneNumberTextField.isEnabled = true
            codeTextField.text = ""
            codeTextField.isHidden = true
        }
    }
    
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }
        
    
    
    
    
//MARK: IBActions
    @IBAction func requestButtonTapped(_ sender: Any) { //RE ep.10 //requestCode
        
        if phoneNumberTextField.text != "" { //RE ep.20 0min
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTextField.text!, uiDelegate: nil) { (verificationID, error) in //RE ep.20 1min
                
                if let error = error { //RE ep.20 1min
                    Service.presentAlert(on: self, title: "Phone Error", message: error.localizedDescription) //RE ep.20 2mins
                    return
                }
                
                //if no error verifying phoneNumber inputted, first show code textfield
                self.phoneNumber = self.phoneNumberTextField.text! //RE ep.20 3mins
                self.phoneNumberTextField.text = "" //RE ep.20 3mins remove text
                self.phoneNumberTextField.placeholder = self.phoneNumber! //RE ep.20 3mins
                self.phoneNumberTextField.isEnabled = false //RE ep.20 4mins because we dont want the user to play with the phone number textfield anymore, that is why we put it as placeholder
                self.codeTextField.isHidden = false //RE ep.20 4mins show code tf
                self.requestButton.setTitle("Register", for: .normal) //RE ep.20 5mins
                
                UserDefaults.standard.set(verificationID, forKey: kVERIFICATIONCODE) //RE ep.20 5mins set our verificationID we got from verifyPhoneNumber's completion handler to our kVERIFICATIONCODE
                UserDefaults.standard.synchronize() //RE ep.20 5mins save it
            }
        }//end of phoneNumber Textfield
        
        if codeTextField.text != "" { //RE ep.20 5mins
            FUser.registerUserWith(phoneNumber: self.phoneNumber!, verificationCode: codeTextField.text!) { (error, shouldLogin) in //RE ep.20 6mins
             //RE ep.20 7mins//check if we are login or registering
                if let error = error {
                    Service.presentAlert(on: self, title: "Phone Number Registering Error", message: error.localizedDescription)
                } //RE ep.20 7mins
                
    //decide to finish registering or not
                if shouldLogin { //RE ep.20 8mins go to main view
                    Service.toHomeTabController(on: self)
                    
                } else { //RE ep.20 8mins go to FINISH REGISTERING view
//                    Service.toHomeTabController(on: self)
                    self.performSegue(withIdentifier: "toFinishRegisterSegue", sender: nil) //RE ep.149 1mins go finish registering if shouldLogin is false, meaning if we're registering because our phone number has never been inputted
                }
            }
        }
    }
    
    
    @IBAction func loginOrRegisterSwitcherButtonTapped(_ sender: Any) {
        
        if isLoginMode { //if currently on log in mode, turn to REGISTER
            loginOrRegisterWithEmailButton.setTitle("Register", for: .normal)
            loginOrRegisterSwitcherButton.setTitle("Switch to Log In?", for: .normal)
            self.firstNameTextField.isHidden = false
            self.lastNameTextField.isHidden = false
            isLoginMode = false
            
        } else { //currently in register mode, and we turn it
            loginOrRegisterWithEmailButton.setTitle("Login", for: .normal)
            loginOrRegisterSwitcherButton.setTitle("Switch to Register?", for: .normal)
            self.firstNameTextField.isHidden = true
            self.lastNameTextField.isHidden = true
            isLoginMode = true
        }
        
    }
    
    @IBAction func loginOrRegisterWithEmailButtonTapped(_ sender: Any) { //RE ep.10
        guard let email = self.emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return } //RE ep.16 1min
        guard let password = self.passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return } //RE ep.16 1min
        
        if Service.isValidWithEmail(email: email) && password.count >= 6 {
        //if Service.isValidWithEmail(email: email) && Service.isValidWithName(name: firstName) && Service.isValidWithName(name: lastName) && password.count >= 6 { //checks if email, names, and password are valid. If valid then we can register our FUser
            
//LOGIN
            if isLoginMode == true { //LOGIN //RE ep.110
                FUser.loginUserWith(email: email, password: password) { (error) in //RE ep.110 11mins
//                    self.spinner.stopAnimating()
                    if error != nil { //RE ep.110 11mins
                        print(error!.localizedDescription)
                        Service.presentAlert(on: self, title: "Error", message: error!.localizedDescription)
                        return
                    } else {
                        DispatchQueue.main.async {
                            self.presentMainTabAndWelcome()
                        }
                    }
                }
                
//REGISTER
            } else { //REGISTER
//                spinner.stopAnimating()
                guard let firstName = self.firstNameTextField.text else { return } //RE ep.16 1min
                guard let lastName = self.lastNameTextField.text else { return } //RE ep.16 1min
                if Service.isValidWithName(name: firstName) && Service.isValidWithName(name: lastName) {
//                    spinner.startAnimating()
                    
                    FUser.registerUserWith(email: email, password: password, firstName: firstName, lastName: lastName) { (error) in //RE ep.16 2mins call our FUser's registerUserWith method
//                        self.spinner.stopAnimating()
                        if let error = error { //RE ep.16 3mins
                            Service.presentAlert(on: self, title: "Error registering user", message: error.localizedDescription)
                            return //RE ep.16 3mins
                        }
                        
                        //if no error registering user, then present the mainView
                        self.presentMainTabAndWelcome()
                    }
                } else { //RE ep.110 11mins invalid first name and last name
                    Service.presentAlert(on: self, title: "First/Last Name Error", message: "Invalid first or last name. Please try again with a different one.")
                    return
                }
            } //END OF REGISTERING
        } else { //email and password are invalid
            Service.presentAlert(on: self, title: "Email/Password Error", message: "Invalid Email or Password. Please try a valid email with a password greater than 6 characters.")
            return
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) { //RE ep.10
        Service.toHomeTabController(on: self) //RE ep.10 10mins
//        self.dismiss(animated: true, completion: nil)
    }
    
    func presentMainTabAndWelcome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        vc.justStarted = true //to present our welcome alert
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
} //end of Controller
