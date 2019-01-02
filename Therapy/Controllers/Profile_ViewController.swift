//
//  Profile_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/13/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
@available(iOS 11.0, *)
class Profile_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneno: UITextField!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var btnEditAccount: DesignableButton!
    
    var datePicker : UIDatePicker!
    var tempImage : UIImage!
    var checkAction = false
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var editAction = ""
    var getProfileData = [getProfile]()
    var checkSagueActon = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileAPI()
        disableIntraction()
        if checkSagueActon == "yes"{
            Utilities.AttachSideMenuController()
            checkSagueActon = ""
        }else{ }
            
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if SingletonVariables.sharedInstace.checkBackAction == "yes"{
            SingletonVariables.sharedInstace.checkBackAction = "no"
            getProfileAPI()
        }
        else{
            SingletonVariables.sharedInstace.checkBackAction = "no"
        }
        disableIntraction()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        self.profileImage.layer.borderColor = PROFILEIMAGEBORDER_COLOR.cgColor
        self.profileImage.layer.borderWidth = 5
        self.profileImage.clipsToBounds = true
        
        self.detailView.layer.shadowColor = UIColor.lightGray.cgColor
        self.detailView.layer.shadowOpacity = 0.7
        self.detailView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.detailView.layer.shadowRadius = 5.0
       
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
    }
    func enableIntraction(){
        self.txtName.isUserInteractionEnabled = true
        self.txtPhoneno.isUserInteractionEnabled = true
        self.txtAddress.isUserInteractionEnabled = true
        self.txtEmail.isUserInteractionEnabled = false
        self.btnCamera.isUserInteractionEnabled = true
        
    }
    func disableIntraction(){
        self.txtName.isUserInteractionEnabled = false
        self.txtPhoneno.isUserInteractionEnabled = false
        self.txtAddress.isUserInteractionEnabled = false
        self.txtEmail.isUserInteractionEnabled = false
        self.btnCamera.isUserInteractionEnabled = false
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
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.opencamera()
        })
        let saveAction = UIAlertAction(title: "Choose from Gallery ", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallery()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        // Add the actions
        imagePicker?.delegate = self
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
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
                    //self.txtAddress.text = self.getProfileData[0].Address
                    self.txtEmail.text = self.getProfileData[0].email
                    self.txtPhoneno.text = "\(self.getProfileData[0].country_code)" + " | \(self.getProfileData[0].Phone)"
                    let urlstring = self.getProfileData[0].Profile_Pic
                    let trimmedString1 = urlstring.replacingOccurrences(of: " ", with: "%20")
                    let url = NSURL(string: trimmedString1)
                    self.profileImage.sd_setImage(with: url! as URL, placeholderImage: nil)
                    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
                    self.profileImage.clipsToBounds = true

                    UserDefaults.standard.set(urlstring, forKey: "PROFILEIMAGE")
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
                          "address":self.txtAddress.text!,
                          "phone_no":self.txtPhoneno.text!,
                          "email":self.txtEmail.text!,
                          "dob":self.txtDOB.text!,
                          "user_image":""]
            print(params)
            NetworkingService.shared.getData2(PostName: APIEndPoint.userCase.editProfile.caseValue, parameters: params) { (response) in
                print(response)
                let dic = response as! NSDictionary
                print(dic)
                if (dic.value(forKey: "status") as? String == "0")
                {
                    self.hideProgress()
                    Utilities.ShowAlertView2(title: "Alert",message: dic.value(forKey: "message") as! String, viewController: self)
                }
                else
                {
                    self.hideProgress()
                    self.editAction = ""
                    self.btnEditAccount.isHidden = true
                    self.disableIntraction()
                    Utilities.ShowAlertView2(title: "Message",message: dic.value(forKey: "message") as! String, viewController: self)
                    self.getProfileAPI()
                    
                }
               
            }
        }
        else{
            let params = ["name": self.txtName.text!,
                          "address":self.txtAddress.text!,
                          "phone_no":self.txtPhoneno.text!,
                          "email":self.txtEmail.text!,
                          "dob":self.txtDOB.text!,
                         ]
            print(params)
            uploadImage(urlString: "http://therapy.gangtask.com/api/editProfile", params: (params ), imageKeyValue: "user_image", image: tempImage, success: {(response) in
                print(response)
                let data = response
                print(data)
                let dict:NSDictionary = response
                print(dict)
                if dict.value(forKeyPath: "status") as! String == "0"{
                    self.hideProgress()
                    Utilities.ShowAlertView2(title: "Alert", message: dict.value(forKey: "message") as! String, viewController: self)
                }else {
                    self.hideProgress()
                    self.btnEditAccount.isHidden = true
                    self.disableIntraction()
                    Utilities.ShowAlertView2(title: "Message",message: dict.value(forKey: "message") as! String, viewController: self)
                    self.getProfileAPI()

                }
            }, failure:
                {
                    (error) in
                    self.hideProgress()
                    print(error)

            })
        }
    }
  
    @IBAction func menuAct(_ sender: UIBarButtonItem) {
        Utilities.LeftSideMenu()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickUpDate(_ textField : UITextField){
          // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(Register_ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Register_ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtDOB.inputAccessoryView = toolBar
        
    }
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd-MM-yyyy"
        txtDOB.text = dateFormatter1.string(from: datePicker.date)
        txtDOB.resignFirstResponder()
    }
    @objc func cancelClick() {
        txtDOB.resignFirstResponder()
    }
    @IBAction func actDOB(_ sender: UITextField) {
        self.view.endEditing(true)
        self.pickUpDate(self.txtDOB)
    }
    @IBAction func editNavBtn_act(_ sender: UIBarButtonItem) {
//        if editAction == ""{
//            editAction = "yes"
//            enableIntraction()
//            self.btnEditAccount.isHidden = false
//        }else{
//            editAction = ""
//            disableIntraction()
//            self.btnEditAccount.isHidden = true
//        }
    }
    
    @IBAction func EditAccount_act(_ sender: UIButton) {
        //editProfileAPI()
    }
    
    @IBAction func cameraAct(_ sender: UIButton) {
        // cameraAuthorization()
    }
    
}

