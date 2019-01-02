//
//  ForgotPass_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/12/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class ForgotPass_ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewEmail: DesignableView!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtEmail.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtEmail{
            self.viewEmail.layer.borderColor = SELECTION_COLOR.cgColor
            self.viewEmail.layer.borderWidth = 1
        }
    }
    @IBAction func btnAct(_ sender: UIButton) {
        self.view.endEditing(true)
        self.validations()
    }
    func validations() {
        if self.txtEmail.text == "" {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter your email", viewController: self)
        }
        else if (isValidEmail(testStr: self.txtEmail.text!) == false)
        {
            Utilities.ShowAlertView2(title: "Alert", message: "Please enter the valid email", viewController: self)
        }else{
            self.ForgotPasswordAPI()
        }
        
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self.txtEmail.text)
        
    }
    func ForgotPasswordAPI(){
        self.showProgress()
        let params = [ "email" : self.txtEmail.text!]
        print(params)
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.forgotPassword.caseValue, parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.hideProgress()
                 self.txtEmail.text = ""
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
            }
            else
            {
                self.hideProgress()
                self.txtEmail.text = ""
                Utilities.ShowAlertView2(title: "Message", message: dic.value(forKey: "message") as! String, viewController: self)
               
            }
        }
        }

}
