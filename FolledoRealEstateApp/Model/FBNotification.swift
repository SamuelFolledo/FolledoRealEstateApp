//
//  FBNotification.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation

class FBNotification { //RE ep.113 0mins
    
    var notificationId: String //RE ep.113 1mins
    let createdAt: Date //RE ep.113 1mins
    
    let propertyReference: String //RE ep.113 2mins
    let propertyObjectId: String //RE ep.113 2mins
    var buyerFullName: String //RE ep.113 2mins
    var buyerId: String //RE ep.113 2mins
    var agentId: String //RE ep.113 2mins
    var phoneNumber: String //RE ep.113 2mins
    var additionalPhoneNumber: String //RE ep.113 2mins
    
    
//MARK: Initializers
    init(_buyerId: String, _agentId: String, _createdAt: Date, _phoneNumber: String, _additionalPhoneNumber: String = "", _buyerFullName: String, _propertyReference: String, _propertyObjectId: String) { //RE ep.113 2-4mins
        
        notificationId = "" //RE ep.113 5mins
        
        createdAt = _createdAt //RE ep.113 5mins
        buyerFullName = _buyerFullName //RE ep.113 5mins
        
        buyerId = _buyerId //RE ep.113 5mins
        agentId = _agentId //RE ep.113 5mins
        phoneNumber = _phoneNumber //RE ep.113 5mins
        additionalPhoneNumber = _additionalPhoneNumber //RE ep.113 5mins
        propertyReference = _propertyReference //RE ep.113 5mins
        propertyObjectId = _propertyObjectId //RE ep.113 5mins
        
    } //RE ep.113 6mins we also need another initializer with an NSDictionary which we will be used when our notifications will be passed from our firebase
    
    
    init(_dictionary: NSDictionary) { //RE ep.114 0mins
        notificationId = _dictionary[kNOTIFICATIONID] as! String //RE ep.114 0mins
        
        if let created = _dictionary[kCREATEDAT] { //RE ep.114 1mins
            createdAt = dateFormatter().date(from: created as! String)! //RE ep.114 1mins use our dateFormatter
        } else { //RE ep.114 2mins we dont have a date, so we create one
            createdAt = Date() //RE ep.114 2mins
        }
        
        if let fName = _dictionary[kBUYERFULLNAME] { //RE ep.114 3mins
            buyerFullName = fName as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            buyerFullName = "" //RE ep.114 3mins
        }
        
        if let buyerrId = _dictionary[kBUYERID] { //RE ep.114 3mins
            buyerId = buyerrId as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            buyerId = "" //RE ep.114 3mins
        }
        
        if let agenttId = _dictionary[kAGENTID] { //RE ep.114 3mins
            agentId = agenttId as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            agentId = "" //RE ep.114 3mins
        }
        
        if let phone = _dictionary[kPHONE] { //RE ep.114 3mins
            phoneNumber = phone as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            phoneNumber = "" //RE ep.114 3mins
        }
        
        if let addPhone = _dictionary[kADDPHONE] { //RE ep.114 3mins
            additionalPhoneNumber = addPhone as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            additionalPhoneNumber = "" //RE ep.114 3mins
        }
        
        if let propRef = _dictionary[kPROPERTYREFERENCEID] { //RE ep.114 3mins
            propertyReference = propRef as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            propertyReference = "" //RE ep.114 3mins
        }
        
        if let propObjId = _dictionary[kPROPERTYOBJECTID] { //RE ep.114 3mins
            propertyObjectId = propObjId as! String //RE ep.114 3mins
        } else { //RE ep.114 3mins
            propertyObjectId = "" //RE ep.114 3mins
        } //if we dont have value, we are setting it to empty string
        
        
    }
    
    
} //end of class

 //RE ep.114 5mins //we need a func to save and retrieve our notification object frm firebase
//MARK: Save Notifications
func saveNotificationInBackground(fbNotification: FBNotification, completion: @escaping (_ error: Error?) -> Void) { //RE ep.114 6mins
    
    let ref = notifFirebaseRef.childByAutoId() //RE ep.114 9mins notifFirebaseRef is a ref = database.child("Notifications") //here we create a unique id for each time we save a notification
    fbNotification.notificationId = ref.key //RE ep.114 10mins .key is thechildByAutoId value
    
    ref.setValue(notificationDictionaryFrom(fbNotification: fbNotification)) { (error, ref) in //RE ep.114 10mins value will be our FBNotification object, but we can only save dictionary, strings, and numbers in our Firebase. Same thing as what we did in our FUser //RE ep.115 5mins notifDictionary is finished
        completion(error) //RE ep.115 5mins
    }
}
func saveNotificationInBackground(fbNotification: FBNotification) { //RE ep.115 6mins no completion handler
    
    let ref = notifFirebaseRef.childByAutoId() //RE ep.115 6mins
    fbNotification.notificationId = ref.key //RE ep.115 6mins
    
    ref.setValue(notificationDictionaryFrom(fbNotification: fbNotification)) //RE ep.115 7mins
}


func fetchAgentNotifications(agentId: String, completion: @escaping(_ allNotifications: [FBNotification]) -> Void) { //RE ep.116 0mins Every notification has agentId, so we search all properties and we get all notifications that has our current agent only
    var allNotifications: [FBNotification] =  [] //RE ep.116 1mins
    var counter = 0 //RE ep.116 2mins
    
    notifHandler = notifFirebaseRef.queryOrdered(byChild: kAGENTID).queryEqual(toValue: agentId).observe(.value, with: { (snapshot) in //RE ep.116 3mins observe is called everytime there is a change in our "Notifications". Everytime a notification is remove, added or changed, .observe is automatically called //Since we want to get all notifications but we dont want to keep listening to these notifications in the future changes, we are using notifHandler which can remove the observer and stop listening to any changes
        //queryOrdered = queryOrderBy: is used to generate a reference to a view of the data that's been sorted by the values of a particular child key. This method is intended to be used in combination with queryStartingAtValue:, queryEndingAtValue:, or queryEqualToValue:.
        if snapshot.exists() { //RE ep.116 5mins if we a snapshot
            
            let allFbn = ((snapshot.value as! NSDictionary).allValues as NSArray) //RE ep.116 7mins now we have all our notification which is a type Dictionary inside an array
            for fbNot in allFbn { //RE ep.116 7mins get each notifs
                let fbNotication = FBNotification(_dictionary: fbNot as! NSDictionary) //RE ep.116 8mins for each object, it will create an FBNotification
                allNotifications.append(fbNotication) //RE ep.116 8mins append it to our allNotifications array
                counter += 1 //RE ep.116 8mins so we can know when our for-loop is finished
            }
            
            if counter == allFbn.count { //RE ep.116 9mins check if the number of objects we received from Firebase is the same as to number we processed
                notifFirebaseRef.removeObserver(withHandle: notifHandler)
                completion(allNotifications) //RE ep.116 10mins
            }
            
        } else { //RE ep.116 5mins means no notifications
            notifFirebaseRef.removeObserver(withHandle: notifHandler) //RE ep.116 5mins, removeObserver only accepts UInt
            completion(allNotifications) //RE ep.116 6mins in case we have no notification, then passback the empty allNotifications
        }
    }, withCancel: nil) //RE ep.116 3mins
    
}


func deleteNotification(fbNotification: FBNotification) { //RE ep.115 7mins
    notifFirebaseRef.child(fbNotification.notificationId).removeValue() //RE ep.115 8mins get the fbNotification's id from the passed fbNotif and remove the value
}


func notificationDictionaryFrom(fbNotification: FBNotification) -> NSDictionary { //RE ep.115 0mins this function takes a notification object and return NSDictionary
    let createdAt = dateFormatter().string(from: fbNotification.createdAt) //RE ep.115 1mins this is a date, but it converts the date to a string that we can save to Firebase. In our init(_dictionary:) we are converting the string back to date
    return NSDictionary(objects: [fbNotification.notificationId, createdAt, fbNotification.buyerFullName, fbNotification.buyerId, fbNotification.agentId, fbNotification.phoneNumber, fbNotification.additionalPhoneNumber, fbNotification.propertyReference, fbNotification.propertyObjectId], forKeys: [kNOTIFICATIONID as NSCopying, kCREATEDAT as NSCopying, kBUYERFULLNAME as NSCopying, kBUYERID as NSCopying, kAGENTID as NSCopying, kPHONE as NSCopying, kADDPHONE as NSCopying, kPROPERTYREFERENCEID as NSCopying, kPROPERTYOBJECTID as NSCopying]) //RE ep.115 2mins
    
}

