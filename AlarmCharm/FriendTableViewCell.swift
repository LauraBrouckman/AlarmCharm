//
//  FriendTableViewCell.swift
//  AlarmCharm
//
//  Created by Elizabeth Brouckman on 5/22/16.
//  Copyright © 2016 Laura Brouckman. All rights reserved.
//

import UIKit
import Contacts

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactAlarmTime: UILabel!
    @IBOutlet weak var contactPicture: UIImageView!
    
    var contact: CNContact? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI() {
        contactName?.text = nil
        contactAlarmTime?.text = nil
        contactPicture?.image = nil
        
        contactName?.text = contact!.givenName + " " + contact!.familyName
        
        print(contact!.givenName)
        if(contact!.phoneNumbers.count > 0) {
            let a = contact!.phoneNumbers[0].value as! CNPhoneNumber
            print("\(a.stringValue)")
        }
        
        //maybe have a default image to set this to
        if(contact!.isKeyAvailable("imageData")) {
            setImage()
        }
        contactAlarmTime?.text = "Not Set"
    }
    
    private func setImage() {
        if contact!.imageData != nil {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [weak weakSelf = self] in
                let imageData = weakSelf?.contact!.imageData!
                dispatch_async(dispatch_get_main_queue()) {
                    if imageData == weakSelf?.contact!.imageData! {
                        if let data = imageData {
                            weakSelf?.contactPicture?.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
}
