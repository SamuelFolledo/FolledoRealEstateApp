//
//  PushNotifications.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/11/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import OneSignal

func sendPushNotification(toProperty: Property, message: String) { //RE ep.121 1mins we need to see which property and the message we want to send to the owner of the property
    getUserToPush(userId: toProperty.ownerId!) { (usersPushIds) in //RE ep.121 8mins the uid is the property's ownerId and will return an array of pushIds
        let currentUser = FUser.currentUser() //RE ep.121 9mins now that we have our current user, and user to push...
        OneSignal.postNotification(["contents" : ["en" : "\(currentUser!.firstName) \n\(message)"], "ios_badgeType" : "Increase", "ios_badgeCount" : "1", "include_player_ids" : usersPushIds]) //RE ep.121 9-13mins //contents will have a keyValue pair, "en" is english language with a value of our current user (title), \n brings a new line and pass our message. ios_badgeType will have a value of increase which will tell our OneSignal that whatever the value is in our "Increase" is, take it an add 1 to it. ios_badgeCount is key and value is the amount we want to increment the icon's badge by 1. Then we need to pass another key "include_player_ids" with a value of userPushIds which will send notifications to all this users in this array of userPushIds, and since our array only contains one Id, it will only send to one user
        ProgressHUD.showSuccess("Notification Sent")
    }
    
}

func getUserToPush(userId: String, result: @escaping(_ pushIds: [String]) -> Void) { //RE ep.121 2mins gets the owner of the property that we can send the notification to. This func gets a userId: and a callback that returns an array of pushIds //SUMMARY we are passing our userId, we find this user in firebase, we get the user and convert it to FUser from the dictionary, then we call our callback function which returns an array of pushIds. The reason we are using an array here is because OneSignal, when we send a notification, it doesnt accept a String, but an array of Strings (array of pushIds)
    firDatabase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in //RE ep.121 3-4 mins equal to the passed userId: and obserrve single event becase we are passing only one userId and there is only one user with the same userId, so we do it once and we forget about it so there is no observer everytime we do an update
        
        if snapshot.exists() { //RE ep.121 5mins
            
            let userDictionary = ((snapshot.value as! NSDictionary).allValues as Array).first //RE ep.121 6mins NSDictionary because we are saving our users as NSDictionary, .allValues because our snapshot is in an array, .first because we know that we will only get one user because only one user can have our objectId
            let fUser = FUser(_dictionary: userDictionary as! NSDictionary) //RE ep.121 7mins
            result([fUser.pushId!])
            
        } else { //RE ep.121 5mins
            ProgressHUD.showError("Couldn't send Notification") //RE ep.121 5mins
        }
    }
    
}

