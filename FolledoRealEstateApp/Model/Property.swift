//
//  Property.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/17/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation

@objcMembers //RE ep.30 3mins without this, Backendless wont be able to store Property in Swift 4, pre-Swift 4 is possible
class Property: NSObject { //RE ep.30 3mins
    
    var objectId: String? //RE ep.30 5mins property's id
    var referenceCode: String? //RE ep.30 5mins for properties that only have a reference number
    var ownerId: String? //RE ep.30 5mins user's id of the owner
    var title: String? //RE ep.30 5mins title of property
    var numberOfRooms: Int = 0 //RE ep.30 5mins //Backendless requires Ints and Bools to have a default value
    var numberOfBathrooms: Int = 0 //RE ep.30 5mins
    var size: Double = 0.0 //RE ep.30 5mins
    var balconySize: Double = 0.0 //RE ep.30 5mins
    var parking: Int = 0 //RE ep.30 5mins
    var floor: Int = 0 //RE ep.30 5mins
    var address: String? //RE ep.30 5mins
    var city: String? //RE ep.30 5mins
    var country: String? //RE ep.30 5mins
    var propertyDescription: String? //RE ep.30 5mins
    var latitude: Double = 0.0 //RE ep.30 5mins
    var longitude: Double = 0.0 //RE ep.30 5mins
    var advertisementType: String? //RE ep.30 5mins For Sale/Rent/Exchange
    var availableFrom: String? //RE ep.30 5mins Date when it's available
    var imageLinks: String? //RE ep.30 5mins link in string so we can access later
    var buildYear: String? //RE ep.30 5mins
    var price: Int = 0 //RE ep.30 5mins
    var propertyType: String? //RE ep.30 5mins apartment/condo/ house/ villa/ land
    var titleDeeds: Bool = false //RE ep.30 5mins
    var centralHeating: Bool = false //RE ep.30 5mins
    var solarWaterHeating: Bool = false //RE ep.30 5mins
    var airconditioner: Bool = false //RE ep.30 5mins
    var storeRoom: Bool = false //RE ep.30 5mins
    var isFurnished: Bool = false //RE ep.30 5mins
    var isSold: Bool = false //RE ep.30 5mins
    var inTopUntil: Date? //RE ep.30 5mins top ad until? manually created in our Property table in Backendless
    
    
    
//MARK: Property METHODS //RE ep.30 9mins we want to be able to save, delete, retrieve, edit our properties from Backendless
    
//Save Functions
    func saveProperty() { //RE ep.30 10mins
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.30 10mins access our backendless's data and save a table of a new Property for us
        dataStore!.save(self) //RE ep.30 11mins this will save our property in backendless
    }
    
    func saveProperty(completion: @escaping(_ values: String) -> Void) { //RE ep.30 11mins this will save our property with a completion block
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.30 12mins
        dataStore!.save(self, response: { (result) in //RE ep.30 12mins save with result
            completion("Success") //RE ep.30 14mins no error
            print("Sucessfully Saved our New Property!")
        }) { (fault: Fault?) in //RE ep.30 13mins this is how Backendless code their errors
            completion(fault!.message) //RE ep.30 13mins pass our error message to our function
        }
    }
    
//Delete Functions
    func deleteProperty(property: Property) { //RE ep.30 14mins this will take a property and return nothing
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.30 15mins
        dataStore!.remove(property) //RE ep.30 15mins
    }
    
    func deleteProperty(property: Property, completion: @escaping (_ value: String)-> Void) { //RE ep.30 16mins
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.30 16mins
        dataStore!.remove(property, response: { (result) in //RE ep.30 16mins
            completion("Success") //RE ep.30 17mins
            print("Sucessfully deleted our property")
        }) { (fault: Fault?) in //RE ep.30 16mins
            completion(fault!.message) //RE ep.30 17mins
        }
        
    }
    
    
//Search Functions
    class func fetchRecentProperties(limitNumber: Int, completion: @escaping(_ properties: [Property?]) -> Void ) { //RE ep.31 1min properties will return an array of Properties? which can be nil and the passed in limitNumber
        let queryBuilder = DataQueryBuilder() //RE ep.31 2mins
        queryBuilder!.setSortBy(["inTopUntil DESC"]) //RE ep.31 3mins it will be sorted DESCendingly by Property's inTopUntil variable, make sure "inTopUntil" has the same name as the variable
        queryBuilder!.setPageSize(Int32(limitNumber)) //RE ep.31 //RE ep.31 4mins how many objects/property we want to get
        queryBuilder!.setOffset(0) //RE ep.31 4mins offset is get our top property so it always begin on top of our list
        
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.31 5mins
        dataStore!.find(queryBuilder, response: { (backendlessProperties) in //RE ep.31 6mins
            completion(backendlessProperties as! [Property]) //RE ep.31 8mins make sure the backendlessProperties is type Property
        }) { (fault: Fault?) in //RE ep.31 7mins
            print("Error couldnt get recent properties \(String(describing: fault!.message))")
            completion([]) //RE ep.31 7mins
        }
    }
    
    
    class func fetchAllProperties(completion: @escaping(_ properties: [Property?]) -> Void) { //RE ep.31 9mins this method will return all properties
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.31 9mins
        dataStore?.find({ (allProperties) in //RE ep.31 10mins
            completion(allProperties as! [Property]) //RE ep.31 11mins
            
        }, error: { (fault: Fault?) in
            print("Error couldnt get all properties \(String(describing: fault!.message))") //RE ep.31 10mins
            completion([]) //RE ep.31 10mins return an empty array
        })
    }
    
    
    class func fetchPropertiesWithClause(whereClause: String, completion: @escaping(_ properties: [Property?]) -> Void) { //RE ep.31 11mins search with whereClause
        let queryBuilder = DataQueryBuilder() //RE ep.31 12min
        queryBuilder!.setWhereClause(whereClause) //RE ep.31 12mins we want to tell Backendless what we want to seach, then sort it
        queryBuilder!.setSortBy(["inTopUntil DESC"]) //RE ep.31 12mins inTopUntil row is manually inputted in Backendless
        
        let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.31 13mins
        dataStore!.find(queryBuilder, response: { (allProperties) in
            completion(allProperties as! [Property]) //RE ep.31 14mins pass all properties
        }) { (fault: Fault?) in //RE ep.31 13mins
            completion([]) //RE ep.31 13mins pass the empty array
            print("Error fetching all properties with clause \(whereClause) with the following error\n\(String(describing: fault!.message))")
        } //RE ep.31 13mins combine our dataStore with our queryBuilder
    }
    
}


func canUserPostProperty(completion: @escaping (_ canPost: Bool) -> Void) { //RE ep.137 1mins
    let queryBuilder = DataQueryBuilder() //RE ep.137 2mins
    let whereClause = "ownerId = '\(FUser.currentId())'" //RE ep.137 2mins we search all properties that the owner is the current user
    queryBuilder!.setWhereClause(whereClause) //RE ep.137 3mins
    
    let dataStore = backendless!.data.of(Property().ofClass()) //RE ep.137 3mins searching our property table in our backendless
    dataStore!.find(queryBuilder, response: { (allProperties) in //RE ep.137 4mins returns allProperties associated to the user
        
        allProperties!.count == 0 ? completion(true) : completion(false) //RE ep.137 6mins if our allProperties count is 0, then we return true, otherwise return false. Which means user has reached limit
        
    }) { (fault: Fault?) in //RE ep.137 5mins
        print("Fault where clause \(fault!.message)") //RE ep.137 5mins
        completion(true) //RE ep.137 6mins in case we want an error, we still want to let user post property
    }
    
}
