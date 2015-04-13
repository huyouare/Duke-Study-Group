//
//  ProfileViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var userImageView: PFImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentUser = PFUser.currentUser() {
            self.loadUser()
        } else {
            Utilities.loginUser(self)
        }
        
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2;
        userImageView.layer.masksToBounds = true;
        imageButton.layer.cornerRadius = userImageView.frame.size.width / 2;
        imageButton.layer.masksToBounds = true;
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func loadUser() {
        var user = PFUser.currentUser()
        
        userImageView.file = user[PF_USER_PICTURE] as? PFFile
        userImageView.loadInBackground { (image: UIImage!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            }
        }
        
        nameField.text = user[PF_USER_FULLNAME] as String
    }
    
    func saveUser() {
        let fullName = nameField.text
        if count(fullName) > 0 {
            var user = PFUser.currentUser()
            user[PF_USER_FULLNAME] = fullName
            user[PF_USER_FULLNAME_LOWER] = fullName.lowercaseString
            user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    ProgressHUD.showSuccess("Saved")
                } else {
                    ProgressHUD.showError("Network error")
                }
            })
        } else {
            ProgressHUD.showError("Name field must not be empty")
        }
    }
    
    // MARK: - User actions
    
    func cleanup() {
        userImageView.image = UIImage(named: "profile_blank")
        nameField.text = nil;
    }
    
    func logout() {
        var logOutAlert = UIAlertController(title: "Log Out", message:"Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:{ (action:UIAlertAction!) in
            NSLog("Cancelled log out")
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Log Out", style: .Default, handler: { (action:UIAlertAction!) in
            PFUser.logOut()
            PushNotication.parsePushUserResign()
            Utilities.postNotification(NOTIFICATION_USER_LOGGED_OUT)
            self.cleanup()
            Utilities.loginUser(self)
        }))
        
        presentViewController(logOutAlert, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(sender: UIBarButtonItem) {
        self.logout()
    }
    
    @IBAction func photoButtonPressed(sender: UIButton) {
        let user = PFUser.currentUser()
        var actionSheet: UIActionSheet!
        if user[PF_USER_FACEBOOKID] == nil {
            actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Camera",  "Photo Gallery")
        } else {
            actionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:"Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Facebook Profile Picture", "Camera",  "Photo Gallery")
        }
        actionSheet.showFromTabBar(self.tabBarController?.tabBar)
    }
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                self.requestFacebook(PFUser.currentUser());
            case 2:
                Camera.shouldStartFrontCamera(self, canEdit: true)
            case 3:
                Camera.shouldStartPhotoLibrary(self, canEdit: true)
            default:
                break
            }
        }
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        self.dismissKeyboard()
        self.saveUser()
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as UIImage
        if image.size.width > 280 {
            image = Images.resizeImage(image, width: 280, height: 280)!
        }
        
        var pictureFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
        pictureFile.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        self.userImageView.image = image
        
        if image.size.width > 60 {
            image = Images.resizeImage(image, width: 60, height: 60)!
        }
        
        var thumbnailFile = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
        thumbnailFile.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        var user = PFUser.currentUser()
        user[PF_USER_PICTURE] = pictureFile
        user[PF_USER_THUMBNAIL] = thumbnailFile
        user.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
            if error != nil {
                ProgressHUD.showError("Network error")
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Facebook Profile Photo fetch methods
    
    func requestFacebook(user: PFUser) {
        var request = FBRequest.requestForMe()
        request.startWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error == nil {
                var userData = result as [String: AnyObject]!
                self.processFacebook(user, userData: userData)
            } else {
                PFUser.logOut()
                ProgressHUD.showError("Failed to fetch Facebook user data")
            }
        }
    }
    
    func processFacebook(user: PFUser, userData: [String: AnyObject]) {
        let facebookUserId = userData["id"] as String
        var link = "http://graph.facebook.com/\(facebookUserId)/picture"
        let url = NSURL(string: link)
        var request = NSURLRequest(URL: url!)
        let params = ["height": "200", "width": "200", "type": "square"]
        Alamofire.request(.GET, link, parameters: params).response() {
            (request, response, data, error) in
            
            if error == nil {
                var image = UIImage(data: data! as NSData)!
                
                if image.size.width > 280 {
                    image = Images.resizeImage(image, width: 280, height: 280)!
                }
                var filePicture = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
                filePicture.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if error != nil {
                        ProgressHUD.showError("Error saving photo")
                    }
                })
                
                self.userImageView.image = image
                
                if image.size.width > 60 {
                    image = Images.resizeImage(image, width: 60, height: 60)!
                }
                var fileThumbnail = PFFile(name: "thumbnail.jpg", data: UIImageJPEGRepresentation(image, 0.6))
                fileThumbnail.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if error != nil {
                        ProgressHUD.showError("Error saving thumbnail")
                    }
                })
                
                user[PF_USER_EMAILCOPY] = userData["email"]
                user[PF_USER_FULLNAME] = userData["name"]
                user[PF_USER_FULLNAME_LOWER] = (userData["name"] as String).lowercaseString
                user[PF_USER_FACEBOOKID] = userData["id"]
                user[PF_USER_PICTURE] = filePicture
                user[PF_USER_THUMBNAIL] = fileThumbnail
                user.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                    if error == nil {
                        return
                    } else {
                        if let info = error!.userInfo {
                            ProgressHUD.showError("Login error")
                            println(info["error"] as String)
                        }
                    }
                })
            } else {
                if let info = error!.userInfo {
                    ProgressHUD.showError("Failed to fetch Facebook photo")
                    println(info["error"] as String)
                }
            }
        }
    }

}
