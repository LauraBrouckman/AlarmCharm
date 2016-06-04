//
//  UserDefaults.swift
//  AlarmCharm
//
//  Created by Alexander Carlisle on 5/31/16.
//  Copyright © 2016 Laura Brouckman. All rights reserved.
//

import Foundation

class UserDefaults{
    
    static var messageKey =         "messageKey"
    static var friendKey =          "friendKey"
    static var defaultSongKey =     "defaultKey"
    static var dateKey =            "dateKey"
    static var setKey =             "setKey"
    static func addWakeUpMessage(wakeUpMessage: String){
        NSUserDefaults.standardUserDefaults().setValue(wakeUpMessage, forKey: messageKey)
    }
    static func storeFriendWhoSetAlarm(friend: String){
        NSUserDefaults.standardUserDefaults().setValue(friend, forKey: friendKey)
    }
    static func getFriendWhoSetAlarm() -> String?{
        return NSUserDefaults.standardUserDefaults().valueForKey(friendKey) as? String
    }
    
    static func userAlarmBeenSet(hasBeenSet: Bool){
        NSUserDefaults.standardUserDefaults().setValue(hasBeenSet, forKey: setKey)
    }
    static func hasAlarmBeenSet() -> Bool{
       let hasBeenSet =  NSUserDefaults.standardUserDefaults().valueForKey(setKey) as? Bool
        print(hasBeenSet)
        if hasBeenSet != nil { return hasBeenSet!}
        else { return false }
    }
    
    static func getWakeUpMessage() -> String?{
        return NSUserDefaults.standardUserDefaults().valueForKey(messageKey) as? String
    }
    static func setDefaultSongName(songName: String){
        NSUserDefaults.standardUserDefaults().setValue(songName, forKey: defaultSongKey)
    }
    static func getDefaultSongName() -> String{
        if let defaultSong =  NSUserDefaults.standardUserDefaults().valueForKey(defaultSongKey) as? String{
            return defaultSong
        }
        return "Alarm_Soothing_Piano"
    }
    static func setAlarmDate(date: NSDate){
        NSUserDefaults.standardUserDefaults().setValue(date, forKey: dateKey)
    }
    static func getAlarmDate() -> NSDate?{
       return NSUserDefaults.standardUserDefaults().valueForKey(dateKey) as? NSDate
    }
    //THis function ensures that if a user cancels out a notification, we set their has been set to false
    static func ensureAlarmTime(){
        let currentDay = NSDate()
        let userDate = UserDefaults.getAlarmDate()
        if userDate != nil{
            let bufferedDate = userDate!.dateByAddingTimeInterval(120)
            if currentDay.earlierDate(bufferedDate) == bufferedDate {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(dateKey)
                UserDefaults.userAlarmBeenSet(false)
            }
        }
        else{
            UserDefaults.userAlarmBeenSet(false)
        }
    }
    static func clearAlarmDate(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(dateKey)
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: setKey)
    }

    
}