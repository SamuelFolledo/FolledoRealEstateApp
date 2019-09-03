//
//  SearchParametersViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/15/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit


protocol SearchParametersViewControllerDelegate { //RE ep.133 1mins
    func didFinishSettingParameters(whereClause: String) //RE ep.133 2mins
}


class SearchParametersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource { //RE ep.126 0mins //RE ep.128 1-2 is added
    
    var delegate: SearchParametersViewControllerDelegate? //RE ep.133 mins
    
    
    var furnishedSwitchValue = false //RE ep.127 0mins
    var centralHeatingSwitchValue = false //RE ep.127 0mins
    var airConditionedSwitchValue = false //RE ep.127 0mins
    var solarWaterSwitchValue = false //RE ep.127 1mins
    var storageRoomSwitchValue = false //RE ep.127 1mins
    
    var propertyTypePicker = UIPickerView() //RE ep.127 4mins
    var advertismentTypePicker = UIPickerView() //RE ep.127 4mins
    var bedroomPicker = UIPickerView() //RE ep.127 4mins
    var bathroomPicker = UIPickerView() //RE ep.127 4mins
    var pricePicker = UIPickerView() //RE ep.127 4mins
    var yearPicker = UIPickerView() //RE ep.127 4mins
    
    var yearArray: [String] = [] //RE ep.127 5mins
    var minPriceArray = ["Minimum", "Any", "10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "200000", "500000"] //RE ep.127 6mins
    var maxPriceArray = ["Maximum", "Any", "10000", "20000", "30000", "40000", "50000", "60000", "70000", "80000", "90000", "100000", "200000", "500000"] //RE ep.127 6mins
    
    var bathroomsArray = ["Any", "1+", "2+", "3+"] //RE ep.127 7mins
    var bedroomsArray = ["Any", "1+", "2+", "3+", "4+", "5+"] //RE ep.127 7mins
    
    var minPrice = "" //RE ep.127 8mins
    var maxPrice = "" //RE ep.127 9mins
    var whereClause = "" //RE ep.127 9mins
    
    var activeTextField: UITextField? //RE ep.127 9mins
    
    
    @IBOutlet weak var scrollView: UIScrollView! //RE ep.126 1mins
    
    @IBOutlet weak var mainView: UIView! //RE ep.126 1mins
    
//text field outlets
    @IBOutlet weak var advertismetTypeTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var propertyTypeTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var bedroomsTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var bathroomsTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var priceTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var buildYearTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var cityTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var countryTextField: UITextField! //RE ep.126 3mins
    @IBOutlet weak var areaTextField: UITextField! //RE ep.126 3mins
    
    
    
//VIEW DID LOAD
    override func viewDidLoad() { //RE ep.126
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: self.view.bounds.width , height: mainView.frame.size.height + 30) //RE ep.128 1mins
        setupArray() //RE ep.128 4mins
        setupPickers() //RE ep.128 4mins
        
        
    }
    
    
//MARK: IBActions
    @IBAction func doneButtonTapped(_ sender: Any) { //RE ep.126 4mins
        if advertismetTypeTextField.text != "" && propertyTypeTextField.text != "" { //RE ep.131 0mins in case user didnt chose an advertisement type and property type
            
            whereClause =  "advertisementType = '\(advertismetTypeTextField.text!)' and propertyType = '\(propertyTypeTextField.text!)'" //RE ep.131 2-4mins this will be adjusted
            
            if bedroomsTextField.text != "" && bedroomsTextField.text != "Any" { //RE ep.131 5mins
                
                let index = bedroomsTextField.text!.index(bedroomsTextField.text!.startIndex, offsetBy: 0) //RE ep.131 9mins this will index our first char in a string, gets the first char of a text
                
                let bedroomNumber = bedroomsTextField.text![index] //RE ep.131 6mins we only want the first char, not that + //Since .characters.first is depracated, we create an index instead
                whereClause = whereClause + " and numberOfRooms >= \(bedroomNumber)" //RE ep.131 7-8mins takes whatever our whereClause is and add bedroomNumber greater or equal to our user's desire. This doesnt have ' ' because bedroomNumber is not a string
            }
            
            if bathroomsTextField.text != "" && bathroomsTextField.text != "Any" { //RE ep.132 1mins
                let index = bathroomsTextField.text!.index(bathroomsTextField.text!.startIndex, offsetBy: 0) //RE ep.132 2mins
                let bathroomNumber = bathroomsTextField.text![index] //RE ep.132 3mins
                whereClause = whereClause + " and numberOfBathrooms >= \(bathroomNumber)" //RE ep.132 3mins
            }
            
            
    //price with min and max range
            if priceTextField.text != "" && priceTextField.text != "Any-Any" { //RE ep.135 0mins
                minPrice = priceTextField.text!.components(separatedBy: "-").first! //RE ep.135 1min this will generate 2 text objects, the first object before AND after the dash. minPrice is the first text object
                maxPrice = priceTextField.text!.components(separatedBy: "-").last! //RE ep.135 1min grab the last text object
                
                if minPrice == "" { minPrice = "Any" } //RE ep.135 2mins if empty, put Any
                if maxPrice == "" { maxPrice = "Any" } //RE ep.135 3mins
                
                if minPrice == "Any" && maxPrice != "Any" { //RE ep.135 3mins if minPrice is any and max is any number but Any... whereClause is everything after the -
                    whereClause = whereClause + " and price <= \(maxPrice)" //RE ep.135 4mins
                }
                
                if minPrice != "Any" && maxPrice == "Any" { //RE ep.135 5mins
                    whereClause = whereClause + " and price >= \(minPrice)" //RE ep.135 6mins
                }
                
                if minPrice != "Any" && maxPrice != "Any" { //RE ep.135 7mins meaning we have a range here
                    whereClause = whereClause + " and price > \(minPrice) and price < \(maxPrice)" //RE ep.135 8mins
                }
                
            }
            
            
            
            if buildYearTextField.text != "" && buildYearTextField.text != "Any" { //RE ep.132 4mins
                whereClause = whereClause + " and buildYear = \(buildYearTextField.text!)" //RE ep.132 4mins
            }
            
            if cityTextField.text != "" && cityTextField.text != "Any" { //RE ep.132 5mins
                whereClause = whereClause + " and city = \(cityTextField.text!)" //RE ep.132 5mins
            }
            
            if countryTextField.text != "" && countryTextField.text != "Any" { //RE ep.132 6mins
                whereClause = whereClause + " and country = \(countryTextField.text!)" //RE ep.132 6mins
            }
            
            if areaTextField.text != "" && areaTextField.text != "Any" { //RE ep.132 7mins
                whereClause = whereClause + " and size >= \(areaTextField.text!)" //RE ep.132 8mins
            }
            
        //switches
            if furnishedSwitchValue { //RE ep.132 9mins if true then add it to our clause
                whereClause = whereClause + " and isFurnished = \(furnishedSwitchValue)" //RE ep.132 10mins
            }
            
            if centralHeatingSwitchValue { //RE ep.132 9mins if true then add it to our clause
                whereClause = whereClause + " and centralHeating = \(centralHeatingSwitchValue)" //RE ep.132 10mins
            }
            
            if airConditionedSwitchValue { //RE ep.132 9mins if true then add it to our clause
                whereClause = whereClause + " and airconditioner = \(airConditionedSwitchValue)" //RE ep.132 10mins
            }
            
            if solarWaterSwitchValue { //RE ep.132 9mins if true then add it to our clause
                whereClause = whereClause + " and solarWaterHeating = \(solarWaterSwitchValue)" //RE ep.132 10mins
            }
            
            if storageRoomSwitchValue { //RE ep.132 9mins if true then add it to our clause
                whereClause = whereClause + " and storeRoom = \(storageRoomSwitchValue)" //RE ep.132 10mins
            }
            
            print("WHERECLAUSE = \(whereClause)") //RE ep.132 11mins
            
            delegate!.didFinishSettingParameters(whereClause: whereClause) //RE ep.132 3mins whichever view assigns itself as a delegate of SearchParameterViewController will implement this function and the received whereClause
            self.dismiss(animated: true, completion: nil) //RE ep.132 11mins now we can dismiss and let searchController finish the job for the search
            
        } else { //RE ep.131 1mins missing requirements
            ProgressHUD.showError("Missing required fields***") //RE ep.131 2mins
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) { //RE ep.127 4mins
        self.dismiss(animated: true, completion: nil) //RE ep.127 2mins
    }
    
//MARK: Switches
    @IBAction func furnishedSwitchOutlet(_ sender: Any) { //RE ep.126 5mins
        furnishedSwitchValue = !furnishedSwitchValue //RE ep.127 2mins
    }
    
    @IBAction func centralHeatingSwitchOutlet(_ sender: Any) { //RE ep.126 5mins
        centralHeatingSwitchValue = !centralHeatingSwitchValue //RE ep.127 2mins
    }
    
    @IBAction func airConditionedSwitchOutlet(_ sender: Any) { //RE ep.126 5mins
        airConditionedSwitchValue = !airConditionedSwitchValue //RE ep.127 2mins
    }
    
    @IBAction func solarWaterHeatingSwitchOutlet(_ sender: Any) { //RE ep.126 5mins
        solarWaterSwitchValue = !solarWaterSwitchValue //RE ep.127 2mins
    }
    
    @IBAction func storageRoomSwitchOutlet(_ sender: Any) { //RE ep.126 5mins
        storageRoomSwitchValue = !storageRoomSwitchValue //RE ep.127 2mins
    }
    
    
//MARK: PickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //RE ep.129 0mins this tells how many rows our picker will have, we mostly have 1
        if pickerView == pricePicker { //RE ep.129 1mins
            return 2 //RE ep.129 1mins we have a maximum and minimum, not just numbers
        }
        return 1 //RE ep.129 1mins otherwise return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //RE ep.129 1mins we'll also have dynamic amount of rows as well
        switch pickerView { //RE ep.129 1mins
        case propertyTypePicker: //RE ep.129 2mins
            return propertyTypes.count //RE ep.129 2mins return our propertyTypes constant's count
        case advertismentTypePicker: //RE ep.129 3mins
            return advertismentType.count //RE ep.129 3mins
        case yearPicker: //RE ep.129 3mins
            return yearArray.count //RE ep.129 3mins
        case pricePicker: //RE ep.129 3mins
            return minPriceArray.count //RE ep.129 4mins
        case bedroomPicker: //RE ep.129 4mins
            return bedroomsArray.count //RE ep.129 4mins
        case bathroomPicker: //RE ep.129 4mins
            return bathroomsArray.count //RE ep.129 4mins
        default: //RE ep.129 1mins
            return 0 //RE ep.129 1mins if none above, then return 0 rows
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //RE ep.129 5mins now we need to tell pickerview "what the title for each row is going to be"
        
        switch pickerView { //RE ep.129 7mins
        case propertyTypePicker: //RE ep.129 2mins
            return propertyTypes[row] //RE ep.129 7mins return our propertyTypes constant's count
        case advertismentTypePicker: //RE ep.129 7mins
            return advertismentType[row] //RE ep.129 7mins
        case yearPicker: //RE ep.129 7mins
            return yearArray[row] //RE ep.129 7mins
        case pricePicker: //RE ep.129 7mins
            if component == 0 { //RE ep.129 8mins
                return minPriceArray[row] //RE ep.129 8mins
            } else { //RE ep.129 8mins
                return maxPriceArray[row] //RE ep.129 8mins
            }
        case bedroomPicker: //RE ep.129 7mins
            return bedroomsArray[row] //RE ep.129 7mins
        case bathroomPicker: //RE ep.129 7mins
            return bathroomsArray[row] //RE ep.129 7mins
        default: //RE ep.129 7mins
            return "" //RE ep.129 7mins default is an empty string
        }
    }
    
    
//MARK: PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //RE ep.130 2mins called when cell is tapped
        var rowValue = row //RE ep.129 3mins needed to manipulate the number of row because we dont want the index 0 to be counted
        
        switch pickerView { //RE ep.130 3mins
        case propertyTypePicker: //RE ep.130 3mins
            if rowValue == 0 { rowValue = 1 } //RE ep.130 4mins
            propertyTypeTextField.text = propertyTypes[rowValue] //RE ep.130 5mins
        case advertismentTypePicker: //RE ep.130 5mins
            if rowValue == 0 { rowValue = 1 } //RE ep.130 5mins
            advertismetTypeTextField.text = advertismentType[rowValue] //RE ep.130 6mins
        case yearPicker: //RE ep.130 3mins
            buildYearTextField.text = yearArray[row] //RE ep.130 7mins
        case pricePicker: //RE ep.130 3mins
            if rowValue == 0 { rowValue = 1 } //RE ep.130 7mins
            if component == 0 { //RE ep.130 7mins
                minPrice = minPriceArray[rowValue] //RE ep.130 7mins
            } else { //RE ep.130 8mins
                maxPrice = maxPriceArray[rowValue] //RE ep.130 8mins
            }
            priceTextField.text = minPrice + "-" + maxPrice //RE ep.130 8mins
        case bedroomPicker: //RE ep.130 3mins
            bedroomsTextField.text = bedroomsArray[row] //RE ep.130 9mins
        case bathroomPicker: //RE ep.130 3mins
            bathroomsTextField.text = bathroomsArray[row] //RE ep.130 9mins
        default: //RE ep.130 3mins
            break //RE ep.130 3mins
        }
        
    }
    
    
    
//MARK: Helper
    func setupArray() { //RE ep.128 2mins
        for i in 1800...2020 { //RE ep.128 2mins generate numbers from 1800-2020
            yearArray.append("\(i)") //RE ep.128 3mins
        }
        yearArray.append("Any") //RE ep.128 3mins
    }
    
    func setupPickers() { //RE ep.128 5mins
        yearPicker.delegate = self //RE ep.128 5mins, dont forget to conform protocols (pickerviewdelegate, and datasource)
        propertyTypePicker.delegate = self //RE ep.128 5mins
        advertismentTypePicker.delegate = self //RE ep.128 5mins
        bedroomPicker.delegate = self //RE ep.128 5mins
        bathroomPicker.delegate = self //RE ep.128 5mins
        pricePicker.delegate = self //RE ep.128 5mins
        
        let toolBar = UIToolbar() //RE ep.128 7mins
        toolBar.sizeToFit() //RE ep.128 7mins
        
        let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) //RE ep.128 8mins by default, toolbar's barbuttonitem appears from left to right unless we specify it .flexibleSpace
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissButtonTapped)) //RE ep.128 9mins
        
        toolBar.setItems([flexibleBar, doneButton], animated: true) //RE ep.128 10mins we need flexibleBar to push doneButton all the way to the right side
        
        buildYearTextField.inputAccessoryView = toolBar //RE ep.128 11mins toolbar will be the accessory
        buildYearTextField.inputView = yearPicker //RE ep.128 11mins and year picker as inputView
        
        propertyTypeTextField.inputAccessoryView = toolBar //RE ep.128 11mins
        propertyTypeTextField.inputView = propertyTypePicker //RE ep.128 11mins
        
        advertismetTypeTextField.inputAccessoryView = toolBar //RE ep.128 11mins
        advertismetTypeTextField.inputView = advertismentTypePicker //RE ep.128 11mins
        
        bedroomsTextField.inputAccessoryView = toolBar //RE ep.128 11mins
        bedroomsTextField.inputView = bedroomPicker //RE ep.128 11mins
        
        bathroomsTextField.inputAccessoryView = toolBar //RE ep.128 11mins
        bathroomsTextField.inputView = bathroomPicker //RE ep.128 11mins
        
        priceTextField.inputAccessoryView = toolBar //RE ep.128 11mins
        priceTextField.inputView = pricePicker //RE ep.128 11mins
        
        
    }
    
    @objc func dismissButtonTapped() { //RE ep.128 14mins
        self.view.endEditing(true) //RE ep.128 14mins dismiss keyboard or whatever our first responder
    }
    
}
