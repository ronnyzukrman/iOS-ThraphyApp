//
//  Post.swift
//  MVC-S
//
//  Created by Kyle Lee on 8/20/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//
import Foundation

struct SignUp
{
    let Id: String
    let username: String
    init?(dict:[String: Any])
    {
        print(dict)
        guard let Id = dict["id"] as? String,
            let username = dict["username"] as? String
            else { return nil }
        self.Id = Id
        self.username = username
    }
}
struct ErrorResponse
{
    let message: String
    init?(dict:[String: Any]) {
        print(dict)
        guard let message = dict["message"] as? String
            else { return nil }
        self.message = message
   }
}

struct getProfile
{
    let Name: String
    let Address: String
    let Phone: String
    let email: String
    let user_id: NSNumber
    let DOB: String
    let Profile_Pic : String
    let country_code : String
    let flag: String
    init?(dict:[String: Any])
    {
        print(dict)
        guard let _userid = dict["user_id"] as? NSNumber,
            let _Name = dict["name"] as? String,
            let _Address = dict["address"] as? String,
            let _Phone = dict["phone_no"] as? String,
            let _email = dict["email"] as? String,
            let _DOB = dict["dob"] as? String,
            let _CountryCode = dict["country_code"] as? String,
            let _flag = dict["flag"] as? String,
            let profilePic = dict["user_image"] as? String
            else {
                return nil
        }
        self.Name = _Name
        self.Address = _Address
        self.Phone = _Phone
        self.email = _email
        self.DOB = _DOB
        self.user_id = _userid
        self.country_code = _CountryCode
        self.flag = _flag
        self.Profile_Pic = profilePic
    }
}
