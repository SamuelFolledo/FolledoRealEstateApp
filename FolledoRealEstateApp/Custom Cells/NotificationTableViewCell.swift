//
//  NotificationTableViewCell.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell { //RE ep.112
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var telNumberLabel: UILabel!
    @IBOutlet weak var propertyCodeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() { //RE ep.112
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) { //RE ep.112 
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bindData(notification: FBNotification) { //RE ep.112 4mins
        var phone = notification.phoneNumber //RE ep.118 4mins get the phone
        if notification.additionalPhoneNumber != "" { //RE ep.118 4mins
            phone = phone + ", " + notification.additionalPhoneNumber //RE ep.118 5mins so we show the phone and additional phone
        }
        
        let newDateFormatter = dateFormatter() //RE ep.118 7mins
        newDateFormatter.dateFormat = "MM/dd/YYYY" //RE ep.118 8mins this will be the format of the date
        
        fullNameLabel.text = notification.buyerFullName //RE ep.118 5mins
        telNumberLabel.text = phone //RE ep.118 6mins
        
        propertyCodeLabel.text = notification.propertyReference //RE ep.118 6mins
        dateLabel.text = newDateFormatter.string(from: notification.createdAt) //RE ep.11 8mins date will be the date created converted to string
        
    }

}
