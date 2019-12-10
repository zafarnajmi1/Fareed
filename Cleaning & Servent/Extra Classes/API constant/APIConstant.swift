//
//  APIConstant.swift
//  SaveMe
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import Foundation

struct APIConstants {
    static let kServerURL = "http://www.fareedapp.com/en/api/"//"https://www.mytechnology.ae/test/cleaners-maintainers/en/api/"
    static let kServerArabicURL = "http://www.fareedapp.com/ar/api/" //"https://www.mytechnology.ae/test/cleaners-maintainers/ar/api/"
}

enum UserAPI : String {
    case login              = "login"
    case register           = "register"
    case check_email        = "check_email"
    case social_login        = "social_login"
    case get_user_profile    = "get_user_profile"
    case get_followers        = "get_followers"
}

enum WebServiceName: String {
    /****   Basic APIS  *******/
    case RegisterPhone        = "user/register/phone"
    case SocialLogin        = "user/social-login"
    case ResendVerificationCode    = "user/resend-sms-verification-code"
    case Login               =  "user/login"
    case Verification_Code    = "user/verify-phone"
    case EditProfile    = "user/profile"
    case Logout          = "user/logout"
    case ChatUsers      = "chats"
    case ChatMsgs        = "chats/messages"
    case SendMsg        = "chats/send-message"
    case RefreshToken  = "user/token"
    case ChangePassword  = "user/change-password"
    
    
}


var kServerIPAddress: String {
    return "https://www.mytechnology.ae/test/servents-cleaners/dev/en/api/"
}

var kBaseURLString: String {
    return "\(kServerIPAddress)"
}

