//
//  ChangePass_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/13/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ChangePass_ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var viewOldPassword: DesignableView!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var viewNewPassword: DesignableView!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var viewConPassword: DesignableView!
    @IBOutlet weak var txtConPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtOldPassword.delegate = self
        self.txtNewPassword.delegate = self
        self.txtConPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtOldPassword{
            self.viewOldPassword.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewNewPassword.layer.borderWidth = 1
            self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
        }else if textField == self.txtNewPassword{
                self.viewNewPassword.layer.borderColor = SELECTION_COLOR.cgColor
                self.viewOldPassword.layer.borderWidth = 1
                self.viewConPassword.layer.borderColor = UIColor.clear.cgColor
        }else if textField == self.txtConPassword{
                self.view.layer.borderColor = SELECTION_COLOR.cgColor
                self.viewOldPassword.layer.borderWidth = 1
                self.viewNewPassword.layer.borderColor = UIColor.clear.cgColor
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    @IBAction func menuAct(_ sender: UIBarButtonItem) {
        Utilities.LeftSideMenu()
    }
    
    func validations() {
        if self.txtOldPassword.text == "" && self.txtNewPassword.text == "" && self.txtConPassword.text == ""{
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter all fields", viewController: self)
        }
        else if self.txtOldPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your old password", viewController: self)
        }
        else if self.txtNewPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your new password", viewController: self)
        }
        else if self.txtConPassword.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please confirm your password", viewController: self)
        }
        else if (self.txtNewPassword.text?.count)! < 6 && (self.txtConPassword.text?.count)! < 6{
            Utilities.ShowAlertView2(title: "Alert", message: "Password should be greater than six characters", viewController: self)
        }
        else if self.txtConPassword.text != self.txtNewPassword.text {
            Utilities.ShowAlertView2(title: "Alert", message: "Passwords does not match", viewController: self)
        }
        else {
            changePasswordAPI()
        }
    }
    
    func changePasswordAPI(){
        self.showProgress()
        let params = [ "old_password" : self.txtOldPassword.text!,
                       "new_password": self.txtNewPassword.text!
        ]
        print(params)
        NetworkingService.shared.getData2(PostName: APIEndPoint.userCase.changePassword.caseValue, parameters: params) { (response) in
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
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
                self.txtNewPassword.text = ""
                self.txtConPassword.text = ""
                self.txtOldPassword.text = ""
            }
            
        }
    }
    @IBAction func submitAct(_ sender: UIButton) {
        validations()
    }
}
