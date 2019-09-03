//
//  Service.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/15/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class Service { //FB ep.29 1mins
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor = UIColor.white
    //static let buttonBackgroundColorSignInAnonymously = UIColor(red: 88, green: 86, blue: 214, alpha: 1)
    static let facebookColor = UIColor(rgb: 0x4267B2) //facebook's blue
    static let buttonCornerRadius: CGFloat = 5
    
    
//presentAlert
    static func presentAlert(on: UIViewController, title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        on.present(alertVC, animated: true, completion: nil)
    }
    
    
    static func toHomeTabController(on: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        on.present(vc, animated: true, completion: nil)
    }
    
    static func toRegisterController(on: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterController")
        on.present(vc, animated: true, completion: nil)
    }
    
    static func toRecentTab(on: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        vc.selectedIndex = 0
        on.present(vc, animated: true, completion: nil)
    }
    
    static func toAddPropertyTab(on: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        vc.selectedIndex = 2
        on.present(vc, animated: true, completion: nil)
    }
    
    static func toMyPropertiesTab(on: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: MainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
        vc.selectedIndex = 4 //index of MyProperties
        on.present(vc, animated: true, completion: nil)
    }
    
    
    static func clearUserDefaults() {
        UserDefaults.standard.set(nil, forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }
    
    static func hideButton(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = .clear
            button.alpha = 0.5
        }
    }
    
    static func showButton(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = self.facebookColor
            button.alpha = 1
        }
    }
    
    
    static func isValidWithEmail(email: String) -> Bool { //FB ep.29 2mins validate email
        /*
         1) declare a rule
         2) apply this rule in NSPredicate
         3) evaluate the test with the email we received
         */
        let regex:CVarArg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //FB ep.29 5mins // [A-Z0-9a-z._%+-] means capital A-Z, and small letters a-z, and number 0 - 9, and . _ % + and - are allowed (which is samuelfolledo in samuelfolledo@gmail.com). PLUS @ and the next format [A-Za-z0-9.-] which allows all small letters, big letters, and integers, and . - (which is the @[gmail] in samuelfolledo@gmail.com). COMPULSARY AND which will allow small and big letters only like .com or .uk. {2,} and the minimum symboys are at least 2 symbols
        let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 6mins we want it to be matching with out regex rules
        let result = test.evaluate(with: email) //FB ep.29 7mins
        
        return result //FB ep.29 7mins
    }
    
    
    static func isValidWithName(name: String) -> Bool { //FB ep.29 8mins
        let regex = "[A-Za-z]{2,}" //FB ep.29 9mins allow letters only with at least 2 chars for the name
        let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 10mins
        let result = test.evaluate(with: name) //FB ep.29 10mins
        
        return result  //FB ep.29 11mins
    }
    
}

extension UIColor { //in order to turn hex to uiColor //#ffffff are actually 3 color components in hexadecimal notation - red ff, green ff and blue ff. You can write hexadecimal notation in Swift using 0x prefix, e.g 0xFF
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
