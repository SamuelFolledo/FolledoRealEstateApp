//
//  MainTabBarController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/21/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {

    var justStarted = false //for presenting welcome alert
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //hasCurrentUser()

        if FUser.currentUser() != nil && justStarted == true {
            print("Welcome with an intro for... \(String(describing: FUser.currentUser()?.fullName))")
            presentWelcomeAlert()
        } else { return }
    }
    
    
    
    func presentWelcomeAlert() {
        justStarted = false
        let user = FUser.currentUser()
        var greetings:String = "Welcome to Folledo's Real Estate"
        if let name = user?.firstName, name != "" { //"" is a value not a nil
            greetings = "Hi \(name)"
        }
        
        let alert = UIAlertController(title: greetings, message: "Would you like to add a new property?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (action) in //RE ep.43 4mins .cancel style is bolded
            return
        }
        let updateAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            Service.toAddPropertyTab(on: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func logoutCurrentUser() { //RE ep.109 2mins logout the current user
        print("Logging outttt...")
        UserDefaults.standard.removeObject(forKey: "OneSignalId") //RE ep.109 3mins remove OneSignalId from UserDefaults
        removeOneSignalId() //RE ep.109 4mins updates id with empty string ""
        
        UserDefaults.standard.removeObject(forKey: kCURRENTUSER) //RE ep.109 3mins
        UserDefaults.standard.synchronize() //RE ep.109 5mins save the changes in UserDefaults. This order is important so it wont crash
        
        do { //RE ep.109 5mins do a try-catch, it will crash
            try Auth.auth().signOut() //RE ep.109 6mins
            
        } catch let error as NSError { //RE ep.109 5mins
            Service.presentAlert(on: self, title: "Error Logging out", message: error.localizedDescription)
            return
        }
        Service.toRegisterController(on: self)
        
//        FUser.logOutCurrentUser
//        { (success) in
//            if !success {
//                Service.presentAlert(on: self, title: "Log out Error", message: "Please try again.")
//                return
//            }
//            return
////            do {
////                try Auth.auth().signOut()
////                Service.toRegisterController(on: self)
////
////            } catch let error as NSError {
////                Service.presentAlert(on: self, title: "Logging out error", message: "\(error.localizedDescription)")
////            }
//
//        }
    }
    
}
