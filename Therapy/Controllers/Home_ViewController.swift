//
//  Home_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/12/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
class Home_ViewController: UIViewController {
   
    var cell = HomeCell()
    var getProfileData = [getProfile]()
    var ratingValue = ""
    var checkSagueActon = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         // Do any additional setup after loading the view.
        self.getProfileAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        if checkSagueActon == "yes"{
         Utilities.AttachSideMenuController()
            checkSagueActon = ""
        }else{
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuAct(_ sender: UIBarButtonItem) {
        Utilities.LeftSideMenu()
    }
    
    func getProfileAPI(){
        let params = [ "user_id": UserDefaults.standard.value(forKey: "USER_ID") as! String]
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
                    let urlstring = self.getProfileData[0].Profile_Pic
                    UserDefaults.standard.set(urlstring, forKey: "PROFILEIMAGE")
                    UserDefaults.standard.set(self.getProfileData[0].email, forKey: "PROFILEEMAIL")
                    UserDefaults.standard.set(self.getProfileData[0].Name, forKey: "PROFILENAME")
                    UserDefaults.standard.synchronize()
                    
                }
                catch {}
            }
            
        }
    }
}
@available(iOS 11.0, *)
extension Home_ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        // Reset float rating view's background color
        cell.startView.backgroundColor = UIColor.clear
        
        /** Note: With the exception of contentMode, type and delegate,
         all properties can be set directly in Interface Builder **/
        cell.startView.delegate = self
        cell.startView.contentMode = UIViewContentMode.scaleAspectFit
        cell.startView.type = .halfRatings
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2.5
    }
    
    
}
@available(iOS 11.0, *)
extension Home_ViewController: FloatRatingViewDelegate {
    
//    // MARK: FloatRatingViewDelegate
//        func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        self.ratingValue = String(format: "%.2f", self.startView.rating)
//        print(self.ratingValue)
//    }
//
//    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
//        self.ratingValue = String(format: "%.2f", self.startView.rating)
//        print(self.ratingValue)
//    }
    
}
class HomeCell: UITableViewCell {
     @IBOutlet weak var startView: FloatRatingView!
}
