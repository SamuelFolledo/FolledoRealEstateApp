//
//  AddPropertyViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/19/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import ImagePicker //RE ep.48 0min new pods and dont forget to go to Project -> Build Phases -> Link Binary With Libraries and ADD IDMPhotoBrowser and ImagePicker

class AddPropertyViewController: UIViewController, ImagePickerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, MapViewDelegate, ImageGalleryViewControllerDelegate { //RE ep.36 11mins //RE ep.48 ImagePickerDelegate was added //RE ep.56 3mins tfDelegate, UIPickerViewDelegate/datasource, and CLLocationManagerDelegate for UIPickers coming out from a textfield. Then tracking with CLLocationManagerDelegate Dontforget to go to Project -> Build Phase -> Link with Binary and add Corelocation //RE ep.64 8mins MapViewDelegate is added //RE ep.101 1mins ImageGalleryVCDelegate
    
    var user: FUser? //RE ep.39 4mins
    var property: Property? //RE ep.89 8mins an optional property
    
    var propertyImages: [UIImage] = [] //RE ep.50 0min images for our property initialized as empty
    
    var yearArray: [Int] = [] //RE ep.56 6mins
    var datePicker = UIDatePicker() //RE ep.56 7mins
    var propertyTypePicker = UIPickerView() //RE ep.56 7mins
    var advertisementTypePicker = UIPickerView() //RE ep.56 7mins
    var yearPicker = UIPickerView() //RE ep.56 8mins
    
    var locationManager: CLLocationManager? //RE ep.56 8mins
    var locationCoordinates: CLLocationCoordinate2D? //RE ep.56 8mins
    var activeField: UITextField? //RE ep.56 9mins
    
    var timer = Timer() //for animation
    
    @IBOutlet weak var illustrationImageView: UIImageView!
    
    
    @IBOutlet weak var cameraButton: UIButton! //RE ep.90 5mins to edit the images button
    @IBOutlet weak var vcTitleLabel: UILabel! //RE ep.90 3mins to change the vc's title
    @IBOutlet weak var backButton: UIButton! //RE ep.89 7mins
    
    @IBOutlet weak var scrollView: UIScrollView! //RE ep.38 1min
    @IBOutlet weak var topView: UIView! //RE ep.37 1min
    
    @IBOutlet weak var referenceCodeTextField: UITextField! //RE ep.38
    @IBOutlet weak var titleTextField: UITextField! //RE ep.38
    @IBOutlet weak var roomsTextField: UITextField! //RE ep.38
    @IBOutlet weak var bathroomsTextField: UITextField! //RE ep.38
    @IBOutlet weak var propertySizeTextField: UITextField! //RE ep.38
    @IBOutlet weak var balconySizeTextField: UITextField! //RE ep.38
    @IBOutlet weak var parkingTextField: UITextField! //RE ep.38
    @IBOutlet weak var floorTextField: UITextField! //RE ep.38
    @IBOutlet weak var addressTextField: UITextField! //RE ep.38
    @IBOutlet weak var cityTextField: UITextField! //RE ep.38
    @IBOutlet weak var countryTextField: UITextField! //RE ep.38
    @IBOutlet weak var propertyTypeTextField: UITextField! //RE ep.38
    @IBOutlet weak var advertismentTypeTextField: UITextField! //RE ep.38
    @IBOutlet weak var availableFromTextField: UITextField! //RE ep.38
    @IBOutlet weak var buildYearTextField: UITextField! //RE ep.38
    @IBOutlet weak var priceTextField: UITextField! //RE ep.38
    @IBOutlet weak var desciptionTextView: UITextView! //RE ep.38
    
    @IBOutlet weak var titleDeedSwitch: UISwitch! //RE ep.38
    @IBOutlet weak var centralHeatingSwitch: UISwitch! //RE ep.38
    @IBOutlet weak var solarWaterHeatingSwitch: UISwitch! //RE ep.38
    @IBOutlet weak var storeRoomSwitch: UISwitch! //RE ep.38
    @IBOutlet weak var airconditionerSwitch: UISwitch! //RE ep.38
    @IBOutlet weak var furnishedSwitch: UISwitch! //RE ep.38
    
    var titleDeedSwitchValue = false //RE ep.39 value of the switches
    var centralHeatingSwitchValue = false //RE ep.39
    var solarWaterHeatingSwitchValue = false //RE ep.39
    var storeRoomSwitchValue = false //RE ep.39
    var airconditionerSwitchValue = false //RE ep.39
    var furnishedSwitchValue = false //RE ep.39
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: topView.frame.size.height) //RE ep.37 2mins set scrollView's size to the screen's width and entire topView's height
        
        setupYearArray() //RE ep.59 0mins
        
        
        referenceCodeTextField.delegate = self //RE ep.59 2mins
        titleTextField.delegate = self //RE ep.59 2mins
        roomsTextField.delegate = self //RE ep.59 2mins
        bathroomsTextField.delegate = self //RE ep.59 2mins
        propertySizeTextField.delegate = self //RE ep.59 2mins
        balconySizeTextField.delegate = self //RE ep.59 2mins
        parkingTextField.delegate = self //RE ep.59 2mins
        floorTextField.delegate = self //RE ep.59 2mins
        addressTextField.delegate = self //RE ep.59 2mins
        cityTextField.delegate = self //RE ep.59 2mins
        countryTextField.delegate = self //RE ep.59 2mins
        propertyTypeTextField.delegate = self //RE ep.59 2mins
        advertismentTypeTextField.delegate = self //RE ep.59 2mins
        availableFromTextField.delegate = self //RE ep.59 2mins
        buildYearTextField.delegate = self //RE ep.59 2mins
        priceTextField.delegate = self //RE ep.59 2mins
//        desciptionTextView.delegate = self //RE ep.59 2mins
        
        
        setupPickers() //RE ep.50 0mins
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged) //RE ep.60 1min out our pickerView delegate doesnt apply to our datePicker so we have to create our own method
        
        
        if property != nil { //RE ep.90 0mins if we have porperty, EDIT PROPERTY
            setupUIForEdit() //RE ep.90 1mins
            
        }
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startImageIncreaseThenDecrease), userInfo: nil, repeats: true) //start animation forever
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(rotateImage), userInfo: nil, repeats: true)
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.scrollView.addGestureRecognizer(tap)
    } //end of viewDidLoad
    
    @objc func startImageIncreaseThenDecrease() { //animation
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.illustrationImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.illustrationImageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
        })
    }
    @objc func rotateImage() {
        UIView.animate(withDuration: 1) {
            self.illustrationImageView.transform = CGAffineTransform(rotationAngle: (180 * .pi) / 180.0)
        }
        
    }
//    @objc func rotate1(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
//
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotationAnimation.fromValue = 0.0
//        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
//        rotationAnimation.duration = aCircleTime
//        rotationAnimation.repeatCount = .infinity
//        imageView.layer.add(rotationAnimation, forKey: nil)
//    }
    override func viewWillAppear(_ animated: Bool) { //RE ep.61 10mins
        if !isUserLoggedIn(viewController: self) { //RE ep.90 0mins check if not logged in
            return //RE ep.90 0mins do nothing
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) { //RE ep.61 10mins if view disappears
        locationManagerStop() //RE ep.61 10mins stop locationManager
        self.illustrationImageView.stopAnimating()
        self.timer.invalidate()
    }
    
    
//MARK: Helpers
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }
    
    
    func save() { //RE ep.39 6mins
        //check first before we
        if titleTextField.text != "" && referenceCodeTextField.text != "" && advertismentTypeTextField.text != "" && propertyTypeTextField.text != "" && priceTextField.text != "" { //RE ep.39 7mins if theyre empty dont continue
            
        //create a new property
            var newProperty = Property() //RE ep.93 0mins create a new Property with info we have
            
            if property != nil { //RE ep.93 1min if we have property... equal our new property to our property, which can only have a value if we are in this VC to EDIT
                newProperty = property! //RE ep.93 1min
            }
            
            ProgressHUD.show("Saving...") //RE ep.56 1min
            
            newProperty.referenceCode = referenceCodeTextField.text! //RE ep.40 1mins
            newProperty.ownerId = user!.objectId //RE ep.40 1min
            newProperty.title = titleTextField.text! //RE ep.40 2mins
            newProperty.advertisementType = advertismentTypeTextField.text! //RE ep.40 2mins
            newProperty.propertyType = propertyTypeTextField.text!
            newProperty.price = Int(priceTextField.text!)! //RE ep.40 3mins
            
            
            if balconySizeTextField.text != "" { //RE ep.40 3mins
                newProperty.balconySize = Double(balconySizeTextField.text!)! //RE ep.40 4mins
            }
            if bathroomsTextField.text != "" { //RE ep.40 4mins
                newProperty.numberOfBathrooms = Int(bathroomsTextField.text!)! //RE ep.40 4mins
            }
            
            if buildYearTextField.text != "" { //RE ep.40 3mins
                newProperty.buildYear = buildYearTextField.text! //RE ep.40 4mins
            }
            if parkingTextField.text != "" { //RE ep.40 4mins
                newProperty.parking = Int(parkingTextField.text!)! //RE ep.40 4mins
            }
            
            if roomsTextField.text != "" { //RE ep.40 3mins
                newProperty.numberOfRooms = Int(roomsTextField.text!)! //RE ep.40 4mins
            }
            if propertySizeTextField.text != "" { //RE ep.40 4mins
                newProperty.size = Double(propertySizeTextField.text!)! //RE ep.40 4mins
            }
            
            if addressTextField.text != "" { //RE ep.40 3mins
                newProperty.address = addressTextField.text! //RE ep.40 4mins
            }
            if cityTextField.text != "" { //RE ep.40 4mins
                newProperty.city = cityTextField.text! //RE ep.40 4mins
            }
            
            if countryTextField.text != "" { //RE ep.40 3mins
                newProperty.country = countryTextField.text! //RE ep.40 4mins
            }
            if availableFromTextField.text != "" { //RE ep.40 4mins
                newProperty.availableFrom = availableFromTextField.text! //RE ep.40 4mins
            }
            
            if floorTextField.text != "" { //RE ep.40 3mins
                newProperty.floor = Int(floorTextField.text!)! //RE ep.40 4mins
            }
            if desciptionTextView.text != "" && desciptionTextView.text != "Description" { //RE ep.40 4mins
                newProperty.propertyDescription = desciptionTextView.text! //RE ep.40 4mins
            }
            
            if locationCoordinates != nil { //RE ep.62 4mins check our coordinates and apply it to our saved newProperty
                newProperty.latitude = locationCoordinates!.latitude //RE ep.62 5mins
                newProperty.longitude = locationCoordinates!.longitude //RE ep.62 5mins
            }
            
        //switches
            newProperty.titleDeeds = titleDeedSwitchValue //RE ep.40 7mins
            newProperty.centralHeating = centralHeatingSwitchValue //RE ep.40 7mins
            newProperty.solarWaterHeating = solarWaterHeatingSwitchValue //RE ep.40 8mins
            newProperty.airconditioner = airconditionerSwitchValue //RE ep.40 8mins
            newProperty.storeRoom = storeRoomSwitchValue //RE ep.40 8mins
            newProperty.isFurnished = furnishedSwitchValue //RE ep.40 8mins
            
        //property images
            if self.propertyImages.count != 0 { //RE ep.50 3mins if we have an image...
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    uploadImages(images: self.propertyImages, userId: self.user!.objectId, referenceNumber: newProperty.referenceCode!) { (linkString) in //RE ep.54 1min if we have images then upload our images we chose //IMPORTANT! Dont forget to change the data type of imageLinks in Backendless from String to Text so we can upload as much links as we can. String has a character limit
                        newProperty.imageLinks = linkString //RE ep.54 2mins
                        newProperty.saveProperty() //RE ep.54 2mins
                        ProgressHUD.showSuccess("Saved!") //RE ep.54 3mins
                        //                    self.dismiss(animated: true, completion: nil) //RE ep.54 3mins
                        Service.toRecentTab(on: self)
                    }
//                }
                
                
                
                
            } else { //RE ep.50 3mins if no image then save
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    newProperty.saveProperty() //RE ep.40 9mins save it
                    ProgressHUD.showSuccess("Saved!")
                    Service.toHomeTabController(on: self) //RE ep.50 5mins
//                }
            }
        } else { //RE ep.39 8mins some *** textField is empty
            ProgressHUD.showError("Error Missing required fields") //RE ep.39 8mins
        }
    }
    
    
    
//MARK: IBActions
    
    @IBAction func backButtonTapped(_ sender: Any) { //RE ep.89 7mins
        self.dismiss(animated: true, completion: nil) //RE ep.93 0mins
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) { //RE ep.38
        
        if property != nil { //RE ep.94 2mins first check if we're in edit mode
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imageGalleryController") as! ImageGalleryViewController //RE ep.94 3mins
            
            vc.property = property //RE ep.97 6mins pass our property we're editing to the Vc's property
            vc.delegate = self //RE ep.101 2mins need to add this ImageGalleryDelegate for saving images
            
            present(vc, animated: true, completion: nil) //RE ep.94 3mind
            return //RE ep.94 4mins necessary so it wont run the rest of this method's code.
            
        }
        
        
        let imagePickerController = ImagePickerController() //RE ep.48 10mins
        imagePickerController.delegate = self //RE ep.48 10mins
        imagePickerController.imageLimit = kMAXIMAGENUMBER //RE ep.48 11mins maxImageNumber = 10
        present(imagePickerController, animated: true, completion: nil) //RE ep.48 12mins
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) { //RE ep.38
        user = FUser.currentUser()! //RE ep.39 4mins
        if !user!.isAgent { //RE ep.39 5mins if user is not agent user can only post 1 property. If user's property number is 1, then they cant post anymore
            canUserPostProperty { (canPost) in //RE ep.137 7mins
                if canPost { //RE ep.137 7mins
                    self.save() //RE ep.137 7mins
                } else { //RE ep.137 7mins
                    ProgressHUD.showError("You have reached your post limit!") //RE ep.137 8mins
                }
            }
            
//            save() //RE ep.39 5mins
        } else { //RE ep.39 5mins user is an agent, then user can post unlimited properties
            
            save() //RE ep.39 5mins
        }
    }
    
    
    @IBAction func mapPinButtonTapped(_ sender: Any) { //RE ep.38 show map so the user can pick a location
        let mapView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapController") as! MapViewController //RE ep.63 16mins
        mapView.delegate = self //RE ep.64 7mins need to have it conform to our protocol
        self.present(mapView, animated: true, completion: nil) //RE ep.63 17mins
    }
    
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) { //RE ep.38
        locationManagerStart() //RE ep.61 11mins when our user clicks on the currentLocation button IMPORTANT not to forget info.plist to add a row for Privacy - Location when in use
    }
    
//switches
    @IBAction func titleDeedSwitch(_ sender: Any) { //RE ep.38
        titleDeedSwitchValue = !titleDeedSwitchValue //RE ep.39 2mins whatever it is, flip the value
    }
    @IBAction func centralHeatingSwitch(_ sender: Any) { //RE ep.38
        centralHeatingSwitchValue = !centralHeatingSwitchValue //RE ep.39 2mins
    }
    @IBAction func solarWaterSwitch(_ sender: Any) { //RE ep.38
        solarWaterHeatingSwitchValue = !solarWaterHeatingSwitchValue
    }
    
    @IBAction func storeRoomSwitch(_ sender: Any) { //RE ep.38
        storeRoomSwitchValue = !storeRoomSwitchValue //RE ep.39 2mins
    }
    @IBAction func airConditionerSwitch(_ sender: Any) { //RE ep.38
        airconditionerSwitchValue = !airconditionerSwitchValue //RE ep.39 3mins
    }
    @IBAction func furnishedSwitch(_ sender: Any) { //RE ep.38
        furnishedSwitchValue = !furnishedSwitchValue //RE ep.39 3mins
    }
    
    
//MARK: ImagePickerDelegate methods
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.48 9mins wrapper is all our images wrapped
        self.dismiss(animated: true, completion: nil) //RE ep.50 1min
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) { //RE ep.48 9mins
        propertyImages = images //RE ep.50 1min puts all our images inside out array
        print("number of images \(images.count)")
        self.dismiss(animated: true, completion: nil) //RE ep.50 1min
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) { //RE ep.48 9mins
        print("Cancel")
        self.dismiss(animated: true, completion: nil) //RE ep.50 1min
    }
    
    
//MARK: PickerView
    
    func setupPickers() { //RE ep.57 0mins
        yearPicker.delegate = self //RE ep.57 1mins
        propertyTypePicker.delegate = self //RE ep.57 1min
        advertisementTypePicker.delegate = self //RE ep.57 1min
        datePicker.datePickerMode = .date //RE ep.57 1min we'll only show date
        
        let toolBar = UIToolbar() //RE ep.57 2mins Tool bar on top of the picker where we'll put our Done button
        toolBar.sizeToFit() //RE ep. //RE ep.57 2mins
        
        let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) //RE ep.57 2mins this will push the Done Button all the way to the right
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTapped)) //RE ep.57 3mins
        toolBar.setItems([flexibleBar, doneButton], animated: true) //RE ep.57 4mins add the two bar buttons to our toolBar
        
        buildYearTextField.inputAccessoryView = toolBar //RE ep.57 5mins we put our picker's input accessory view as the toolbar we created for our textField
        buildYearTextField.inputView = yearPicker //RE ep.57 5mins put our textField's inputView as the yearPicker
        
        availableFromTextField.inputAccessoryView = toolBar //RE ep.57 5mins
        availableFromTextField.inputView = datePicker //RE ep.57 5mins
        
        propertyTypeTextField.inputAccessoryView = toolBar //RE ep.57 5mins
        propertyTypeTextField.inputView = propertyTypePicker //RE ep.57 5mins
        
        advertismentTypeTextField.inputAccessoryView = toolBar //RE ep.57 5mins
        advertismentTypeTextField.inputView = advertisementTypePicker //RE ep.57 5mins
        
        
    }
    
    @objc func doneButtonTapped() { //RE ep.57 6mins
        self.view.endEditing(true) //RE ep.57 7mins
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //RE ep.56 4mins
        return 1 //RE ep.56 5mins we only need one, date has 3 components
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //RE ep.56 4mins how many rows do we have
        
        if pickerView == propertyTypePicker { return propertyTypes.count } //RE ep.57 8mins
        
        if pickerView == advertisementTypePicker { return advertismentType.count } //RE ep.57 8mins

        if pickerView == yearPicker { return yearArray.count } //RE ep.57 8mins
        
        return 0 //RE ep.56 5mins
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //RE ep.58 0mins
        if pickerView == propertyTypePicker { return propertyTypes[row] } //RE ep.57 8mins
        
        if pickerView == advertisementTypePicker { return advertismentType[row] } //RE ep.57 8mins
        
        if pickerView == yearPicker { return "\(yearArray[row])" } //RE ep.57 8mins
        
        return "" //RE ep.58 5mins
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //RE ep.58 1min
        var rowValue = row //RE ep.58 2mins we cant change the arrow
        if pickerView == propertyTypePicker { //RE ep.58 3mins
            if rowValue == 0 { rowValue = 1 } //RE ep.58 3mins because 0 = "Select"
            propertyTypeTextField.text = propertyTypes[rowValue] //RE ep.58
        }
        
        if pickerView == advertisementTypePicker { //RE ep.58 3mins
            if rowValue == 0 { rowValue = 1 } //RE ep.58 4mins
            advertismentTypeTextField.text = advertismentType[rowValue] //RE ep.58 4mins
        }
        
        if pickerView == yearPicker { //RE ep.58 3mins
            buildYearTextField.text = "\(yearArray[row])" //RE ep.58 5mins
        }
        
    }
    
    
    func setupYearArray() { //RE ep.59 3mins
        for i in 1800...2030 { //RE ep.59 3mins
            yearArray.append(i) //RE ep.59 4mins add 1800 to 2030
        }
        yearArray.reverse() //RE ep.59 5mins start from 2030 and not in 1800
        
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker) { //RE ep.60 2mins
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date) //RE ep.60 2mins componends are year, month, day. From sender's date which is from (datePicker)
        if activeField == availableFromTextField { //RE ep.60 3mins
            availableFromTextField.text = "\(components.month!)/\(components.day!)/\(components.year!)" //RE ep.60 4mins
        }
    }
    
    
//MARK: UITextField Delegate //RE ep.60
    func textFieldDidBeginEditing(_ textField: UITextField) { //RE ep.60 5mins UITextField delegate method when you begin editing
        activeField = textField //RE ep.60 6mins equal the activeField to the current textField, and not the delegate = self anymore
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { //RE ep.60 5mins
        activeField = nil //RE ep.60 6mins and when we finish editing, make activeField = nil again
    }
    
    
//MARK: Location Manager //RE ep.61
    
    func locationManagerStart() { //RE ep.61 7mins
        if locationManager == nil { //RE ep.61 7mins if we have no locationManager, then we start it
            locationManager = CLLocationManager() //RE ep.61 8mins
            locationManager!.delegate = self //RE ep.61 8mins
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest //RE ep.61 8mins
            locationManager!.requestWhenInUseAuthorization() //RE ep.61 9mins so if we dont have our location, we might also want to ask permission to use it in case it is needed
        }
        locationManager!.startUpdatingLocation() //RE ep.61 9mins if we do have a locationManager then start updating location
    }
    
    
    func locationManagerStop() { //RE ep.61 9mins
        if locationManager != nil { //RE ep.61 9mins if its not empty
            locationManager?.stopUpdatingLocation() //RE ep.61 9mins stop updating
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { //RE ep.61 6mins everytime our location changes, this function gets called and we're provided with our new coordinates
        self.locationCoordinates = locations.last!.coordinate //RE ep.61 6mins set our updated coordinates to our variable
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { //RE ep.61 1mins this is if user changes the status and makes the app cannot use the location anymore...
        switch status { //RE ep.61 1min
        case .notDetermined: //RE ep.61 2mins if we dont know the status of user's lcation, then we ask it
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse: //RE ep.61 2mins if we're authorized when in use
            manager.startUpdatingLocation() //RE ep.61 3mins
        case .authorizedAlways: //RE ep.61 3mins
            manager.startUpdatingLocation() //RE ep.61 3mins
        case .restricted: //RE ep.61 4mins if restricted because of parental control
            break //RE ep.61 4mins then break it
        case .denied: //RE ep.61 4mins
            self.locationManager = nil //RE ep.61 4mins if deny or remove location
            Service.presentAlert(on: self, title: "Location disabled", message: "Please enable location from settings")
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { //RE ep.61 0mins if location manager failed
        print("Failed to get the location")
        Service.presentAlert(on: self, title: "Map Error", message: "Failed to get the location")
    }
    
    
    
//MARK: MapViewDelegate
    func didFinishWith(coordinate: CLLocationCoordinate2D) { //RE ep.64 9mins
        self.locationCoordinates = coordinate //RE ep.64 9mins so we're passing the coordinate we received from mapView to our locationCoordinates
        print("Coordinates = \(coordinate)")
    }
    
    
//MARK: EditProperties
    func setupUIForEdit() { //RE ep.90 1min
        self.vcTitleLabel.text = "Edit Property" //RE ep.90 3mins
        self.cameraButton.setImage(UIImage(named: "Picture"), for: .normal) //RE ep.90 5mins
        self.backButton.isHidden = false //RE ep.90 8mins so we can unhide our button and go back
        
    //fill the values
        referenceCodeTextField.text = property!.referenceCode //RE ep.90 8mins
        titleTextField.text = property!.title //RE ep.90 8mins
        advertismentTypeTextField.text = property!.advertisementType //RE ep.90 8mins
        priceTextField.text = "\(property!.price)" //RE ep.90 8mins
        propertyTypeTextField.text = property!.propertyType //RE ep.90 8mins
        
    //tf
        balconySizeTextField.text = "\(property!.balconySize)" //RE ep.90 8mins
        bathroomsTextField.text = "\(property!.numberOfBathrooms)" //RE ep.90 8mins
        buildYearTextField.text = "\(property!.buildYear ?? "" )" //RE ep.90 8mins
        parkingTextField.text = "\(property!.parking)" //RE ep.90 8mins
        roomsTextField.text = "\(property!.numberOfRooms)" //RE ep.90 8mins
        propertySizeTextField.text = "\(property!.size)" //RE ep.90 8mins
        availableFromTextField.text = "\(property!.availableFrom ?? "" )" //RE ep.90 8mins
        floorTextField.text = "\(property!.floor)" //RE ep.90 8mins
        desciptionTextView.text = "\(property!.propertyDescription ?? "" )" //RE ep.90 8mins
        addressTextField.text = "\(property!.address ?? "" )" //RE ep.90 8mins
        cityTextField.text = "\(property!.city ?? "" )" //RE ep.90 8mins
        countryTextField.text = "\(property!.country ?? "" )" //RE ep.90 8mins
        
    //switch values
        titleDeedSwitchValue = property!.titleDeeds //RE ep.91 3mins
        centralHeatingSwitchValue = property!.centralHeating //RE ep.91 3mins
        solarWaterHeatingSwitchValue = property!.solarWaterHeating //RE ep.91 3mins
        storeRoomSwitchValue = property!.storeRoom //RE ep.91 3mins
        airconditionerSwitchValue = property!.airconditioner //RE ep.91 3mins
        furnishedSwitchValue = property!.isFurnished //RE ep.91 3mins
        
        if property!.latitude != 0.0 && property!.longitude != 0.0 { //RE ep.91 3mins check if we have location
            locationCoordinates?.latitude = property!.latitude //RE ep.91 4mins
            locationCoordinates?.longitude = property!.longitude //RE ep.91 4mins
        }
        
        updateSwitches() //RE ep.91 5mins
        
    }
    
    func updateSwitches() { //RE ep.91 5mins
        titleDeedSwitch.isOn = titleDeedSwitchValue //RE ep.91 5mins
        centralHeatingSwitch.isOn = centralHeatingSwitchValue //RE ep.91 5mins
        solarWaterHeatingSwitch.isOn = solarWaterHeatingSwitchValue //RE ep.91 5mins
        storeRoomSwitch.isOn = storeRoomSwitchValue //RE ep.91 5mins
        airconditionerSwitch.isOn = airconditionerSwitchValue //RE ep.91 5mins
        furnishedSwitch.isOn = furnishedSwitchValue//RE ep.91 5mins
    }
    
//MARK: ImageGalleryDelegate
    func didFinishEditingImages(allImages: [UIImage]) {
         //RE ep.101 0mins dont forget to delegate to self in cameraButtonTapped. Now that we receive  all our images, we have to set it to our existing images. propertyImages
        self.propertyImages = allImages //RE ep.101 4mins
        
    }
    
}
