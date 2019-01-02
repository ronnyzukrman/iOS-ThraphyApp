//http://therapy.gangtask.com/public/images/default.jpg
//  EditProfile_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/18/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
@available(iOS 11.0, *)
class EditProfile_ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var txtcode: UILabel!
    @IBOutlet weak var txtCode: UITextField!
    fileprivate var alertStyle: UIAlertControllerStyle = .actionSheet
    var datePicker : UIDatePicker!
    var tempImage : UIImage!
    var checkAction = false
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var editAction = ""
    var getProfileData = [getProfile]()
    var flag = ""
    var URLString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.isUserInteractionEnabled = false
        self.getProfileAPI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        self.profileImage.layer.borderColor = PROFILEIMAGEBORDER_COLOR.cgColor
        self.profileImage.layer.borderWidth = 5
        self.profileImage.clipsToBounds = true
        
    }
    @IBAction func codeAct(_ sender: UIButton) {
        let alert = UIAlertController(style: self.alertStyle)
        alert.addLocalePicker(type: .phoneCode) { info in Log(info)
            print(info?.code as Any)
            print( UIImage(named: "Countries.bundle/Images/\(info?.code.uppercased() ?? "")") as Any)
            self.txtcode.text = info?.phoneCode
            self.flagImage.image = UIImage(named:"Countries.bundle/Images/\(info?.code ?? "")")
            self.flag = (info?.code)!
        }
        alert.addAction(title: "Cancel", style: .cancel)
        alert.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            //self.presentCamera()
        })
    }
    func cameraAuthorization(){
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined: requestCameraPermission()
        case .authorized: CameraActionSheet()
        case .restricted, .denied: alertCameraAccessNeeded()
        }
    }
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: Action Sheet to open camera and gallery
    func CameraActionSheet(){
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Photo", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.removePhoto()
        })
        let TakeAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.opencamera()
        })
        let saveAction = UIAlertAction(title: "Choose Photo ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallery()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // Add the actions
        imagePicker?.delegate = self
        if self.URLString == "http://therapy.gangtask.com/public/images/default.jpg"{
            
        }else{
            optionMenu.addAction(deleteAction)
        }
        
        optionMenu.addAction(TakeAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func removePhoto(){
        let refreshAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete profile photo", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deletePicAPI()
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        
    }
    //MARK: Function to open Camera
    func opencamera()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker!.allowsEditing = true
            imagePicker!.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo;
            self.present(imagePicker!, animated: true, completion: nil)
        }
        else
        {
            print("Sorry cant take picture")
            let alert = UIAlertController(title: "Warning", message:"Camera is not working.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Function to open Gallery
    func openGallery()
    {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker!.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo editingInfo: [String : Any]) {
        print(editingInfo as Any);
        tempImage = editingInfo[UIImagePickerControllerEditedImage] as! UIImage
        print(tempImage)
        self.profileImage.image = tempImage
        self.dismiss(animated: true, completion: nil);
    }
    
    func getProfileAPI(){
        self.showProgress()
        let params = [ "user_id": UserDefaults.standard.value(forKey: "USER_ID") as! String,
                       ]
        print(params)
        NetworkingService.shared.getData2(PostName: APIEndPoint.userCase.getProfile.caseValue, parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else
            {
                self.hideProgress()
                do {
                    let response = try GetProfileResponse(json: dic.value(forKey: "user_details") as! [String: Any])
                    self.getProfileData = response.getdata
                    self.txtName.text = self.getProfileData[0].Name
                   // self.txtAddress.text = self.getProfileData[0].Address
                    self.txtEmail.text = self.getProfileData[0].email
                    self.txtPhone.text = self.getProfileData[0].Phone
                    self.txtCode.text = self.getProfileData[0].country_code
                    //self.flagImage.image = UIImage(named:"Countries.bundle/Images/\(self.getProfileData[0].flag)")
                    self.URLString = self.getProfileData[0].Profile_Pic
                    let trimmedString1 = self.URLString.replacingOccurrences(of: " ", with: "%20")
                    let url = NSURL(string: trimmedString1)
                    self.profileImage.sd_setImage(with: url! as URL, placeholderImage: nil)
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
                    self.profileImage.clipsToBounds = true
                    
                    UserDefaults.standard.set(self.URLString, forKey: "PROFILEIMAGE")
                    UserDefaults.standard.set(self.getProfileData[0].email, forKey: "PROFILEEMAIL")
                    UserDefaults.standard.set(self.getProfileData[0].Name, forKey: "PROFILENAME")
                    UserDefaults.standard.synchronize()
                    
                }
                catch {}
            }
            
        }
    }
    func editProfileAPI(){
        self.showProgress()
        if tempImage == nil{
            let params = ["name": self.txtName.text!,
                          "address":"",
                          "phone_no":self.txtPhone.text!,
                          "email":self.txtEmail.text!,
                          "dob":"",
                          "user_image":"",
                          "country_code": self.txtCode.text!,
                          "flag":self.flag,
                          "image_type":"local"]
            print(params)
            NetworkingService.shared.getData2(PostName: APIEndPoint.userCase.editProfile.caseValue, parameters: params) { (response) in
                print(response)
                let dic = response as! NSDictionary
                print(dic)
                if (dic.value(forKey: "status") as? String == "0")
                {
                    self.hideProgress()
                    SingletonVariables.sharedInstace.checkBackAction = "no"
                    Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                }
                else
                {
                    self.hideProgress()
                    SingletonVariables.sharedInstace.checkBackAction = "yes"
                    let refreshAlert = UIAlertController(title: "Message", message:  (dic.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.getProfileAPI()
                        self.navigationController?.popViewController(animated: true)
                    }))
//                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
//                        print("Handle Cancel Logic here")
//                         self.getProfileAPI()
//                        refreshAlert .dismiss(animated: true, completion: nil)
//                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }
                
            }
        }
        else{
            let params = ["name": self.txtName.text!,
                          "address":"",
                          "phone_no":self.txtPhone.text!,
                          "email":self.txtEmail.text!,
                          "dob":"",
                          "country_code": self.txtCode.text!,
                          "flag":self.flag,
                          "image_type":"local"]
            print(params)
            uploadImage(urlString: "http://therapy.gangtask.com/api/editProfile", params: (params ), imageKeyValue: "user_image", image: tempImage, success: {(response) in
                print(response)
                let data = response
                print(data)
                let dict:NSDictionary = response
                print(dict)
                if dict.value(forKeyPath: "status") as! String == "0"{
                    self.hideProgress()
                    SingletonVariables.sharedInstace.checkBackAction = "no"
                    Utilities.ShowAlertView2(title: "Alert", message: dict.value(forKey: "message") as! String, viewController: self)
                }else {
                    self.hideProgress()
                    SingletonVariables.sharedInstace.checkBackAction = "yes"
                    let refreshAlert = UIAlertController(title: "Message", message:  (dict.value(forKey: "message") as! String), preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.navigationController?.popViewController(animated: true)
                    }))
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                        self.getProfileAPI()
                        refreshAlert .dismiss(animated: true, completion: nil)
                    }))
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }
            }, failure:
                {
                    (error) in
                    self.hideProgress()
                    print(error)
                    
            })
        }
    }
    
    func deletePicAPI(){
        self.showProgress()
        let params = [ "":""]
        print(params)
        NetworkingService.shared.getData2(PostName: APIEndPoint.userCase.delete_profile_pic.caseValue, parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else
            {
                self.hideProgress()
                SingletonVariables.sharedInstace.checkBackAction = "yes"
                self.getProfileAPI()
            }
            
        }
    }
    
    func validations() {
        if self.txtName.text == "" && self.txtCode.text == "" && self.txtPhone.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
        }
        else if txtName.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your name", viewController: self)
        }
        else if txtCode.text == ""{
             Utilities.ShowAlertView2(title: "Alert", message: "Please choose your country code", viewController: self)
        }
        else if txtCode.text?.count > 5{
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter valid country code", viewController: self)
        }
        else if txtPhone.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your phone number", viewController: self)
        }
        else if txtPhone.text?.count < 10 || txtPhone.text?.count > 10  {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter correct phone number", viewController: self)
        }
//        else if txtAddress.text == "" {
//            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your address", viewController: self)
//        }
        else {
           editProfileAPI()
        }
    }
    @IBAction func cameraAct(_ sender: UIButton) {
        cameraAuthorization()
    }
    @IBAction func save_act(_ sender: UIButton) {
        self.validations()
    }
}
