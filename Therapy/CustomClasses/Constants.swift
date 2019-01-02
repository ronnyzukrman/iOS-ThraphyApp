//
//  Constants.swift
//  OSODCompany
//
//  Created by SIERRA on 7/16/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import Foundation
import UIKit

let THEME_COLOR = UIColor(red: 0/255.0, green: 45/255.0, blue: 158/255.0, alpha: 0.0)
let IMAGEBORDER_COLOR = UIColor(red: 0/255.0, green: 87/255.0, blue: 182/255.0, alpha: 1.0)
let PROFILEIMAGEBORDER_COLOR = UIColor(red: 182/255.0, green: 241/255.0, blue: 244/255.0, alpha: 1.0)
let SELECTION_COLOR = UIColor(red: 13/255.0, green: 206/255.0, blue: 220/255.0, alpha: 1.0)
let baseUrl = "http://therapy.gangtask.com/api"
public enum APIEndPoint
{
    public enum userCase {
        case userRegister
        case userLogin
        case forgotPassword
        case SocialLogin
        case getProfile
        case editProfile
        case changePassword
        case delete_profile_pic
        var caseValue: String{
            switch self{
            case .userRegister:               return "/register"
            case .userLogin:                  return "/login"
            case .forgotPassword:             return "/forgotPassword"
            case .SocialLogin:                return "/SocialLogin"
            case .getProfile:                 return "/getProfile"
            case .editProfile:                return "/editProfile"
            case .changePassword:             return "/changePassword"
            case .delete_profile_pic:         return "/delete_profile_pic"
            }
        }
    }
   
}

