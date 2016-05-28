//
//  Database.swift
//  AlarmCharm
//
//  Created by Elizabeth Brouckman on 5/28/16.
//  Copyright © 2016 Laura Brouckman. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

class Database {
    
    private var usersRef = FIRDatabase.database().reference().child("users")
    
    func uploadFileToDatabase(fileURL: NSURL, forUser userID: String) {
        
        let filename = fileURL.lastPathComponent!
        let storage = FIRStorage.storage()
        let gsReference = storage.referenceForURL("gs://project-5208532535641760898.appspot.com")
        let fileRef = gsReference.child(filename)
        
        let _ = fileRef.putFile(fileURL, metadata: nil) { metadata, error in
            if (error != nil) {
                print(error)
            } else {
                let currUserRef = self.usersRef.child(userID)
                let newSound = ["audio_file": filename]
                currUserRef.updateChildValues(newSound)
            }
        }
        
    }
    
    
    
    
    func downloadFileToLocal(forUser userID: String) {
        //Carlisle your function will go here!
        usersRef.child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if let audioFile = snapshot.value!["audio_file"] as? String where audioFile != ""{
                let storage = FIRStorage.storage()
                let gsReference = storage.referenceForURL("gs://project-5208532535641760898.appspot.com")
                let soundRef = gsReference.child(audioFile)
                soundRef.downloadURLWithCompletion { (URL, error) -> Void in
                    if (error != nil) {
                        print(error)
                    } else {
                        self.saveToFileSystem(URL!, fileName: "test.caf")
                    }
                }
            }
        })
        { (error) in
            print(error)
        }
    }
    
    /*
     Given the url, it turns url into NSDATA and then saves the file in the libray/sounds folder.
     */
    private func saveToFileSystem(URL : NSURL, fileName: String){
        let songData =  NSData(contentsOfURL: URL)
        let fileManager = NSFileManager.defaultManager()
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath = soundsPath + "/" + fileName
        do {
            try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        let soundPathUrl = NSURL(fileURLWithPath: filePath)
        print(soundPathUrl)
        songData?.writeToURL(soundPathUrl,  atomically: true)
    }
    var player : AVPlayer?
    /**/
    private func playMusicFromFileSystem(fileName:String){
        let playerItem = AVPlayerItem(URL : getURlFromFileSystem(fileName))
        player = AVPlayer(playerItem: playerItem)
        player!.play()
    }
    
    
    /*
     Will be useful once app opens as well to actually play the sound with an av player
     */
    private func getURlFromFileSystem(fileName: String) -> NSURL{
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath = soundsPath + "/" + fileName
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        let myURL = NSURL(fileURLWithPath: filePath)
        return myURL
    }
    
    /*
     This function will be moved to Notification Class soon
     Grabs the notificationm and changes the soundName to be the sound name of the user
     */
    func setNotificationFromFileSystem(){
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications
        if notifications?.count > 0 {
            if let oldNotification = notifications?[0]
            {
                oldNotification.soundName = "test.caf"
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                UIApplication.sharedApplication().scheduleLocalNotification(oldNotification)
            }
        }
    }
    
    
    
}