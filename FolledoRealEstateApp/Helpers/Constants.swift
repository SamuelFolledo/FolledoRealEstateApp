//
//  Constants.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/14/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

 //RE ep.6 3mins created like this because we will be using the backendless in multiple locations, so we'll create an instance for it

import Foundation
import FirebaseDatabase

var backendless = Backendless.sharedInstance() //RE ep.6
var firDatabase = Database.database().reference() //RE ep.15 11mins


var notifHandler: UInt = 0 //RE ep.114 7mins
let notifFirebaseRef = firDatabase.child(kFBNOTIFICATIONS) //RE ep.114 7mins "Notifications"


//uiPickers
let propertyTypes = ["Select", "Apartment", "House", "Villa", "Land", "Flat", "Mansion", "Palace", "Hotel"] //RE ep.57 10mins
let advertismentType = ["Select", "Sale", "Rent", "Exchange"] //RE ep.57 10mins


//Ids and Keys
public let kONESIGNALAPPID = "e3258093-1466-4ddd-acde-667495920a4b" //RE ep.6 7mins
public let kFILEREFERENCE = "gs://realestateapp-50167.appspot.com" //RE ep.52 12mins for our images reference from Firebase Storage

//FUser //RE ep.11 12mins
public let kOBJECTID = "objectId" //RE ep.11 12mins
public let kUSER = "User" //RE ep.11 12mins
public let kCREATEDAT = "createdAt" //RE ep.11 12mins
public let kUPDATEDAT = "updatedAt" //RE ep.11 12mins
public let kCOMPANY = "company" //RE ep.11 12mins
public let kPHONE = "phone" //RE ep.11 12mins
public let kADDPHONE = "addPhone" //RE ep.11 12mins

public let kCOINS = "coins" //RE ep.11 12mins
public let kPUSHID = "pushId" //RE ep.11 12mins
public let kFIRSTNAME = "firstname" //RE ep.11 12mins
public let kLASTNAME = "lastname" //RE ep.11 12mins
public let kFULLNAME = "fullname" //RE ep.11 12mins
public let kAVATAR = "avatar" //RE ep.11 12mins
public let kCURRENTUSER = "currentUser" //RE ep.11 12mins
public let kISONLINE = "isOnline" //RE ep.11 12mins
public let kVERIFICATIONCODE = "firebasee_verification" //RE ep.11 12mins
public let kISAGENT = "isAgent" //RE ep.11 12mins
public let kFAVORIT = "favoritProperties" //RE ep.11 12mins

//Property
public let kMAXIMAGENUMBER = 10 //RE ep.11 12mins
public let kRECENTPROPERTYLIMIT = 20 //RE ep.11 12mins

//FB Notification
public let kFBNOTIFICATIONS = "Notifications" //RE ep.11 12mins
public let kNOTIFICATIONID = "notificationId" //RE ep.11 12mins
public let kPROPERTYREFERENCEID = "referenceId" //RE ep.11 12mins
public let kPROPERTYOBJECTID = "propertyObjectId" //RE ep.11 12mins
public let kBUYERFULLNAME = "buyerFullName" //RE ep.11 12mins
public let kBUYERID = "buyerId" //RE ep.11 12mins
public let kAGENTID = "agentId" //RE ep.11 12mins

//push
public let kDEVICEID = "deviceId" //RE ep.11 12mins

//other
public let kTEMPFAVORITID = "tempID" //RE ep.11 12mins


//comFolledoSwagCoins
//comFolledoSwagAgentSubscription
