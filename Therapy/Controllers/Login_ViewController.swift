//
//  Login_ViewController.swift
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
class Login_ViewController: UIViewController , GIDSignInUIDelegate, UITextFieldDelegate{

    @IBOutlet weak var viewPassword: DesignableView!
    @IBOutlet weak var viewEmail: DesignableView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgcheckBox: UIImageView!
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
    var fb_userimage = String()
    var checkAction = "NotCheck"
    var loginType = ""
    var parms = [String:String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        if UserDefaults.standard.value(forKey: "USER_ID") == nil
        {
            print("user are not logged in...")
            if let a = UserDefaults.standard.value(forKey: "REMEMBER_ME") as? String
            {
                if a != "Check"{
                    print(" is not remember me...")
                    imgcheckBox.image = #imageLiteral(resourceName: "check-box-empty")
                    checkAction = "NotCheck"
                }else{
                    print(" is remember me...")
                    self.txtPassword.text = (UserDefaults.standard.value(forKey: "USER_PASSWORD") as! String)
                    self.txtEmail.text = (UserDefaults.standard.value(forKey: "USER_EMAIL") as! String)
                    imgcheckBox.image = #imageLiteral(resourceName: "check-box (1)")
                    checkAction = "Check"
                }
            }else{}
        }else {
             if let a = UserDefaults.standard.value(forKey: "REMEMBER_ME") as? String
             {
                if a != "Check"{
                    print(" is not remember me...")
                    imgcheckBox.image = #imageLiteral(resourceName: "check-box-empty")
                    checkAction = "NotCheck"
                   
                }else{
                    print(" is remember me...")
                    self.txtPassword.text = (UserDefaults.standard.value(forKey: "USER_PASSWORD") as! String)
                    self.txtEmail.text = (UserDefaults.standard.value(forKey: "USER_EMAIL") as! String)
                    imgcheckBox.image = #imageLiteral(resourceName: "check-box (1)")
                    checkAction = "Check"
                     self.sague()
                }
             }else{}
        }
        // Do any additional setup after loading the view.
        
         NotificationCenter.default.addObserver(self, selector: #selector(Login_ViewController.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "GMAIL_NOTI"), object: nil)
    }
    
    @objc func methodOfReceivedNotification() {
        print("RECEIVED ANY NOTIFICATION")
        self.sague()
    }
    
    func sague(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
        vc.checkSagueActon = "yes"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmail{
        self.viewEmail.layer.borderColor = SELECTION_COLOR.cgColor
        self.viewEmail.layer.borderWidth = 1
        self.viewPassword.layer.borderColor = UIColor.clear.cgColor
        }else{
        self.viewPassword.layer.borderColor = SELECTION_COLOR.cgColor
        self.viewPassword.layer.borderWidth = 1
        self.viewEmail.layer.borderColor = UIColor.clear.cgColor
        }
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
    @IBAction func facebook_Clicked(_ sender: Any)
    {
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
        
        //End
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
    @IBAction func google_Clicked(_ sender: Any)
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
     }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func rememberMe_act(_ sender: UIButton) {
        if imgcheckBox.image == #imageLiteral(resourceName: "check-box-empty"){
            imgcheckBox.image = #imageLiteral(resourceName: "check-box (1)")
            checkAction = "Check"
            let useremail = self.txtEmail.text
            let userpassword = self.txtPassword.text
            UserDefaults.standard.set(userpassword, forKey: "USER_PASSWORD")
            UserDefaults.standard.set(useremail, forKey: "USER_EMAIL")
            UserDefaults.standard.synchronize()
        }else{
            imgcheckBox.image = #imageLiteral(resourceName: "check-box-empty")
            checkAction = "NotCheck"
           
        }
        
    }
    
    @IBAction func signInAct(_ sender: UIButton) {
        self.validations()
    }
    func validations() {
        if self.txtEmail.text == "" && self.txtPassword.text == ""{
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
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
        else {
            emailValidation2()
        }
    }
    func emailValidation2(){
        if (isValidEmail(testStr: self.txtEmail.text!) == true)
        {
             self.loginAPI()
        }
        else{
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter the valid email", viewController: self)
        }
    }
  
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self.txtEmail.text)
        
    }
    func loginAPI(){
        self.showProgress()
        let params = [ "email" : self.txtEmail.text!,
                       "password": self.txtPassword.text!
        ]
        print(params)
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.userLogin.caseValue, parameters: params) { (response) in
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
                let user_id = "\(dic.value(forKeyPath: "user_id") as! NSNumber)"
                let user_accessToken = dic.value(forKeyPath: "token") as! String
                secondViewController.checkSagueActon = "yes"
                UserDefaults.standard.set(self.checkAction , forKey: "REMEMBER_ME")
                UserDefaults.standard.set(user_id, forKey: "USER_ID")
                UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(secondViewController, animated: true)
                
            }
            
        }
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
                let user_id = "\(dic.value(forKeyPath: "user_id") as! NSNumber)"
                secondViewController.checkSagueActon = "yes"
                let user_accessToken = dic.value(forKeyPath: "token") as! String
                UserDefaults.standard.set(self.checkAction , forKey: "REMEMBER_ME")
                UserDefaults.standard.set(user_id, forKey: "USER_ID")
                UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
                UserDefaults.standard.set("socialLogin", forKey: "SOCAIL_LOGIN")
                UserDefaults.standard.synchronize()
                self.navigationController?.pushViewController(secondViewController, animated: true)
                
            }
            
        }
    }
}
