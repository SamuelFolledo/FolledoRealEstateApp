//
//  NotificationsViewController.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 11/10/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { //RE ep.112 //RE ep.112 5mins 1-2 is added
    
    var allNotifications: [FBNotification] = [] //RE ep.117 0mins
    
    
    @IBOutlet weak var tableView: UITableView! //RE ep.112 2mins
    @IBOutlet weak var noNotificationLabel: UILabel! //RE ep.117 6mins
    
    
    override func viewDidLoad() { //RE ep.112
        super.viewDidLoad()

        loadNotifications() //RE ep.117 3mins
        
    }
    
    
//MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //RE ep.112 6mins
        return allNotifications.count //RE ep.112 6mins
    }
    
    
//MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //RE ep.118 0mins when user selects a cell
        tableView.deselectRow(at: indexPath, animated: true) //RE ep.118 1mins deselect the row because we are not going to show anything
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { //RE ep.118 1mins we need to allow user to delete a notification
        return true //RE ep.118 2mins
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) { //RE ep.118 2mins this func is called everytime we slide the cell, we will see a delete button
        deleteNotification(fbNotification: allNotifications[indexPath.row]) //RE ep.118 2mins call our delete method and pass the notif selected
        self.allNotifications.remove(at: indexPath.row) //RE ep.118 3mins remove it from array
        tableView.reloadData() //RE ep.118 3mins we reload our tableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //RE ep.112 6mins
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell //RE ep.112 7mins
        
        cell.bindData(notification: allNotifications[indexPath.row]) //RE ep.119 9mins
        
        return cell //RE ep.112 7mins
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
//MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { //RE ep.117 8mins will make lines of cells clear if we have no notifications
        let view = UIView() //RE ep.117 9mins
        view.backgroundColor = .clear //RE ep.117 9mins
        
        return view //RE ep.117 10mins
    }
    
    
//MARK: IBActions
    @IBAction func backButtonTapped(_ sender: Any) { //RE ep.112 2mins
        self.dismiss(animated: true, completion: nil) //RE ep.118 0mins
    }
    
    
//MARK: LoadNotifications
    func loadNotifications() { //RE ep.117 0mins
        fetchAgentNotifications(agentId: FUser.currentId()) { (allNotif) in //RE ep.117 1mins call our fetch notif. AgenId will be the current user's id
            print("Fetching \(self.allNotifications.count) notification(s)")
            self.allNotifications = allNotif //RE ep.117 1mins everytime we receive a notif from firebase, we want to replace our allNotifcations array with our new objects array
            
            if self.allNotifications.count == 0 { //RE ep.117 2mins
                print("No notifications") //RE ep.117 2mins
                self.noNotificationLabel.isHidden = false //RE ep.117 7mins if no notif, unhide the label
            }
            self.tableView.reloadData() //RE ep.117 2mins
        }
        
    }
    

}
