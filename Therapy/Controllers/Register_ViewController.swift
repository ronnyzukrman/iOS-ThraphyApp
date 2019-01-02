//
//  Register_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/11/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
@available(iOS 11.0, *)

class Register_ViewController: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,UIGestureRecognizerDelegate{
    @IBOutlet weak var bottomView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var viewName: DesignableView!
    @IBOutlet weak var viewPhone: DesignableView!
    @IBOutlet weak var viewAddress: DesignableView!
    @IBOutlet weak var viewDOB: DesignableView!
    @IBOutlet weak var viewEmail: DesignableView!
    @IBOutlet weak var viewPassword: DesignableView!
    @IBOutlet weak var viewConPassword: DesignableView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConPassword: UITextField!
    @IBOutlet weak var imgCheckbox: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var txtcode: UILabel!
    @IBOutlet weak var txtCode: UITextField!
    
   fileprivate var alertStyle: UIAlertControllerStyle = .actionSheet
    var tapGesture = UITapGestureRecognizer()
    var checkAction = ""
    var datePicker : UIDatePicker!
    var gmailuserdictionary = [String : Any]()
    var userid = String()
    var dictFb:NSDictionary!
    var dictTweet:NSDictionary!
    var fb_id = String()
    var fb_type = String()
    var fb_email = String()
    var fb_firstname = String()
    var fb_lastname = String()
    var fb_gender = String()
    var fb_userimage:String!
    var loginType = ""
    var flag = ""
    var parms = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtEmail.delegate = self
        self.txtName.delegate = self
        self.txtPhone.delegate = self
        self.txtDOB.delegate = self
        self.txtConPassword.delegate = self
        self.txtPassword.delegate = self
        checkAction = "notCheck"
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        self.datePicker.maximumDate = Date()
        txtDOB.resignFirstResponder()
        txtDOB.inputView = self.datePicker
        
        tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(Register_ViewController.handleTap(sender:)))
        tapGesture.delegate = self
        self.myLabel.isUserInteractionEnabled = true
        self.myLabel.addGestureRecognizer(tapGesture)
        
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
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let length = self.getTextLength(mobileNo: txtCode.text!)
//        if length == 0{
//            let num : String = self.formatNumber(mobileNo: txtCode.text!)
//            textField.text = num + "+"
//        }
//        return true
//    }
//    func getTextLength(mobileNo: String) -> NSInteger{
//        var str : NSString = mobileNo as NSString
//        str = str.replacingOccurrences(of: "+", with: "") as NSString
//        return str.length
//    }
//
    func formatNumber(mobileNo: String) -> String{
        var str : NSString = mobileNo as NSString
        str = str.replacingOccurrences(of: "+", with: "") as NSString
//        if str.length > 5{
//            str = str.substring(from: str.length - 10) as NSString
//        }

        return str as String
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmail{
            self.viewEmail.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewEmail.layer.borderWidth = 1
            
            self.viewName.layer.borderColor = UIColor.clear.cgColor
            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
           // self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
        }else if textField == self.txtName{
            self.viewName.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewName.layer.borderWidth = 1
            
            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
            //self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
        }
        else if textField == self.txtCode{
//            self.txtCode.text = "+"
        }
        else if textField == self.txtPhone{
            let num : String = self.formatNumber(mobileNo: txtCode.text!)
            txtCode.text = "+" + num
            if txtCode.text == "" {
               Utilities.ShowAlertView2(title: "Alert", message: "Please enter country code", viewController: self)
            }
            else if txtCode.text?.count > 5{
                Utilities.ShowAlertView2(title: "Alert", message: "Please enter valid country code", viewController: self)
            }
            else{
            self.viewPhone.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewPhone.layer.borderWidth = 1
            
            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
            self.viewName.layer.borderColor = UIColor.clear.cgColor
            //self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
            }
        }
//        else if textField == self.txtAddress{
//            if txtPhone.text?.count < 10 || txtPhone.text?.count > 10  {
//                Utilities.ShowAlertView2(title: "Alert", message: "Please enter correct phone number", viewController: self)
//            }else{
//            self.viewAddress.layer.borderColor = SELECTION_COLOR.cgColor
//            self.viewAddress.layer.borderWidth = 1
//
//            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
//            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
//            self.viewName.layer.borderColor = UIColor.clear.cgColor
//            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
//            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
//            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
//            }
//        }
        else if textField == self.txtDOB{
            if txtPhone.text?.count < 10 || txtPhone.text?.count > 10  {
                Utilities.ShowAlertView2(title: "Alert", message: "Please enter correct phone number", viewController: self)
            }else{
            self.viewDOB.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewDOB.layer.borderWidth = 1
            
            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
            self.viewName.layer.borderColor = UIColor.clear.cgColor
           // self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if textField == self.txtPassword{
            self.viewPassword.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewPassword.layer.borderWidth = 1
            
            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
            self.viewName.layer.borderColor = UIColor.clear.cgColor
            //self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
        }
        else if textField == self.txtConPassword{
            self.viewConPassword.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewConPassword.layer.borderWidth = 1
            
            self.viewEmail.layer.borderColor = UIColor.clear.cgColor
            self.viewPhone.layer.borderColor = UIColor.clear.cgColor
            self.viewName.layer.borderColor = UIColor.clear.cgColor
           // self.viewAddress.layer.borderColor = UIColor.clear.cgColor
            self.viewPassword.layer.borderColor = UIColor.clear.cgColor
            self.viewDOB.layer.borderColor = UIColor.clear.cgColor
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBAction func actDOB(_ sender: UITextField) {
         self.view.endEditing(true)
         self.pickUpDate(self.txtDOB)
    }
    func pickUpDate(_ textField : UITextField){
       
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
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
    
    func validations() {
        if self.txtName.text == "" && txtCode.text == "" && self.txtPhone.text == "" && self.txtDOB.text == "" && self.txtEmail.text == "" && self.txtPassword.text == "" && self.txtConPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
        }
        else if txtName.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your name", viewController: self)
        }
        else if txtCode.text == ""{
            Utilities.ShowAlertView2(title: "Alert", message: "Please choose your country code", viewController: self)
        }
        else if txtPhone.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your phone number", viewController: self)
        }
        
        else if txtDOB.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your date of birth", viewController: self)
        }
        
        else if txtEmail.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your email", viewController: self)
        }
            
        else if (isValidEmail(testStr: self.txtEmail.text!) == false)
        {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter the valid email", viewController: self)
        }
            
        else if txtPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your password", viewController: self)
            
        }else if (txtPassword.text?.count)! < 6 {
            Utilities.ShowAlertView2(title: "Alert", message: "Password should be greater than six characters", viewController: self)
        }
        else if txtConPassword.text != txtPassword.text {
            Utilities.ShowAlertView2(title: "Alert", message: "Passwords does not match", viewController: self)
        }
        else {
            emailValidation2()
        }
    }
    func emailValidation2(){
        if (isValidEmail(testStr: self.txtEmail.text!) == true)
        {
            self.checkUncheckValidation()
        }
        else{
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter the valid email", viewController: self)
        }
    }
    func checkUncheckValidation(){
        if checkAction == "Check"{
            self.registerAPI()
        }else{
            Utilities.ShowAlertView2(title: "Alert", message: "Please agree Terms of use & Privacy policy", viewController: self)
        }
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self.txtEmail.text)
        
    }
    @IBAction func actcheck(_ sender: UIButton) {
        if imgCheckbox.image == #imageLiteral(resourceName: "check-box-empty"){
            imgCheckbox.image = #imageLiteral(resourceName: "check-box (1)")
            checkAction = "Check"
        }else{
            imgCheckbox.image = #imageLiteral(resourceName: "check-box-empty")
            checkAction = "notCheck"
        }
    }
    
    @IBAction func signIn_act(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SignUPAct(_ sender: UIButton) {
        self.validations()
    }
    
    func registerAPI(){
        self.showProgress()
        let params = ["name": self.txtName.text!,
                      "phone_no": self.txtPhone.text!,
                      "address": "",
                      "dob": self.txtDOB.text!,
                      "email": self.txtEmail.text!,
                      "password": self.txtPassword.text!,
                      "country_code":self.txtCode.text!,
                      "flag":"IN",
        ]
        print(params)
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.userRegister.caseValue, parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.hideProgress()
                Utilities.ShowAlertView2(title: "Alert", message: (dic.value(forKey: "message") as? String)!, viewController: self)
            }
            else
            {
                self.hideProgress()
                let alert = UIAlertController(title: "Message", message:(dic.value(forKey: "message") as? String)! , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action -> Void in
                     print("action are work....")
                    let user_id = "\(dic.value(forKeyPath: "user_id") as! NSNumber)"
                    let user_accessToken = dic.value(forKeyPath: "token") as! String
                  
                    UserDefaults.standard.set(user_id, forKey: "USER_ID")
                    UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
                    UserDefaults.standard.synchronize()
                    
                    self.sague()
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    }
    func sague(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile_ViewController") as! Profile_ViewController
         vc.checkSagueActon = "yes"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: GOGGLE_SIGN_IN
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId: String = user.userID                  // For client-side use only!
            let idToken: String = user.authentication.idToken // Safe to send to the server
            let fullName: String = user.profile.name
            let givenName: String = user.profile.givenName
            let email: String = user.profile.email
            let picURL = user.profile.imageURL(withDimension: 120)
            gmailuserdictionary  = ["id" : userId, "Tokenid": idToken, "username" : fullName, "name" : givenName, "useremail" : email, "image" : picURL as Any]
            print(userId ,idToken ,fullName ,givenName ,email ,picURL as Any )
            
            // ...
        } else {
            print("\(error.localizedDescription)")
            
        }
    }
    
    @IBAction func fbAct(_ sender: UIButton) {
        //Start @[@"public_profile", @"email", @"user_friends"]
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
            else
            {
                print(error as Any )
            }        }
    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,gender, picture.type(large), email,age_range,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    //                    name,email,gender,fb_id,image(optional),phone
                    self.dictFb = (result as! NSDictionary)
                    print(self.dictFb)
                    // self.logintype = "F"
                    self.fb_id = self.dictFb.value(forKey: "id") as! String
                    self.fb_email = self.dictFb.value(forKey: "email") as! String
                    self.fb_firstname = self.dictFb.value(forKey: "first_name") as! String
                    self.fb_lastname = self.dictFb.value(forKey: "last_name") as! String
                    self.fb_userimage = self.dictFb.value(forKeyPath: "picture.data.url") as! String
                    self.loginType = "f"
                    self.SocialLoginAPI()
                }
            })
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                // self.stopAnimating()
                Utilities.ShowAlertView(title: "Message", message: "Not successfully Login ", viewController: self)
            }
            
        }
    }
    @IBAction func gmailAct(_ sender: UIButton) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    func SocialLoginAPI(){
        self.showProgress()
        if fb_userimage != ""{
            parms = ["name": fb_firstname,
                     "email": fb_email,
                     "login_type": loginType,
                     "social_id" : fb_id,
                     "user_image": fb_userimage,
                     "phone_no": "",
                     "address": "",
                     "dob":"",
                     "password":"",
                     "country_code":"",
                     "flag":"",
                     "image_type":"link"]
        }else{
            parms = ["name": fb_firstname,
                     "email": fb_email,
                     "login_type": loginType,
                     "social_id" : fb_id,
                     "user_image": "http://therapy.gangtask.com/public/images/default.jpg",
                     "phone_no": "",
                     "address": "",
                     "dob":"",
                     "password":"",
                     "country_code":"",
                     "flag":"",
                     "image_type":"link"]
        }
        print(parms)
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.SocialLogin.caseValue, parameters: parms ) { (response) in
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
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
                secondViewController.checkSagueActon = "yes"
                let user_id = "\(dic.value(forKeyPath: "user_id") as! NSNumber)"
                let user_accessToken = dic.value(forKeyPath: "token") as! String
                UserDefaults.standard.set(user_id, forKey: "USER_ID")
                UserDefaults.standard.set("NotCheck" , forKey: "REMEMBER_ME")
                UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
                 UserDefaults.standard.set("socialLogin", forKey: "SOCAIL_LOGIN")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(secondViewController, animated: true)
                
            }
            
        }
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        let text = (myLabel.text)!
        let termsRange = (text as NSString).range(of: "Terms of use")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        if (sender?.didTapAttributedTextInLabel(label: myLabel, inRange: termsRange))! {
            print("Tapped terms")
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermCondition_ViewController") as! TermCondition_ViewController
            secondViewController.urlLink = "http://therapy.gangtask.com/terms.php"
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        } else if (sender?.didTapAttributedTextInLabel(label: myLabel, inRange: privacyRange))! {
            print("Tapped privacy")
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "TermCondition_ViewController") as! TermCondition_ViewController
            secondViewController.urlLink = "http://therapy.gangtask.com/policy.php"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else {
            print("Tapped none")
        }
    }
}
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
