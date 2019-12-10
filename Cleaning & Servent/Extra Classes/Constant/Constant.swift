//
//  Constant.swift
//  Shir
//
//  Created by MAC MINI on .
//  Copyright © 2018. All rights reserved.
//

import Foundation
import UIKit

let kEmptyString = ""


struct Constants {
    // Constants to call services to server
    static let kTagColor = UIColor.init(red: (26/255), green: (131/255), blue: (203/255), alpha: 0.7)
    static let kBlackColor = UIColor.init(red: 0.6901, green: 0.6901, blue: 0.6901, alpha: 1.0)
    //init(colorLiteralRed: 0.6901, green: 0.6901, blue: 0.6901, alpha: 1.0)
	
    
    static let kGreenColor = UIColor.init(red: (90/255), green: (165/255), blue: (80/255), alpha: 1.0)
    static let kGreenAlphaColor = UIColor.init(red: (113/255), green: (197/255), blue: (72/255), alpha: 0.25)
    
    static let kDarkGreenColor = UIColor.init(red: (107/255), green: (161/255), blue: (75/255), alpha: 1.0)

    
    static let kBorderColor = UIColor.lightGray
    
    
	static let kNavigationcolor = UIColor.init(red: 0.1647, green: 0.5882, blue: 0.9176, alpha: 1.0)
    //init(colorLiteralRed: 0.1647, green: 0.5882, blue: 0.9176, alpha: 1.0)
	
    static let kPlaceholderColor = UIColor.gray
    
    static let kCornerRaious : CGFloat = 5.0
    
    
    
    static var deviceToken = "DummyToken"

}



struct ConstantsColor {
    static let kBudzSelectColor = UIColor.init(red: (153/255), green: (45/255), blue: (127/255), alpha: 1.0)
    static let kBudzUnselectColor = UIColor.init(red: (92/255), green: (92/255), blue: (92/255), alpha: 1.0)
    static let kStrainSelectColor = UIColor.init(red: (244/255), green: (196/255), blue: (47/255), alpha: 1.0)
    static let kQuestionColor = UIColor.init(red: 0.075, green: 0.416, blue: 0.612, alpha: 1.0)
    static let kJournalColor = UIColor.init(red: 0.345, green: 0.541, blue: 0.259, alpha: 1.0)
    static let kGroupColor = UIColor.init(red: 0.667, green: 0.404, blue: 0.196, alpha: 1.0)
    static let kStrainColor = UIColor.init(red:0.957, green:0.769, blue:0.290, alpha:1.000)
    static let kBudzColor = UIColor.init(red:0.420, green:0.114, blue:0.396, alpha:1.000)
    
}

//MARK:- Numbers
let kZero: CGFloat = 0.0
let kOne: CGFloat = 1.0
let kHalf: CGFloat = 0.5
let kTwo: CGFloat = 2.0
let kHundred: CGFloat = 100.0
let kDefaultAnimationDuration = 0.3


struct StoryBoardConstant {
    
    static let QA           = "QAStoryBoard"
    static let Profile      = "ProfileView"
    static let Budz         = "BudzStoryBoard"
    static let Main         = "Main"
    
}
//MARK:- Messages

struct Alert {
    
    static let kEmptyCredentails    = "Please provide your credentails to proceed.".localized
    static let kWrongEmail          = "Invalid Email".localized
	static let kEmptyEmail          = "Email address is missing.".localized
	static let kEmptyPassword       = "Password is missing.".localized
	static let kPasswordNotMatch    = "Password not match with confirm password.".localized
	static let kUserNameMissing     = "UserName is missing.".localized
	static let kUserImageMissing     = "User image is missing.".localized
}

let kErrorTitle                     = "Error".localized
let kInformationMissingTitle        = "Information Missing".localized
let kOKBtnTitle                     = "OK".localized
let kCancelBtnTitle                 = "Cancel".localized
let kDismissBtnTitle                = "Dismiss".localized
let kTryAgainBtnTitle               = "Try Again".localized

let kDescriptionHere                = "Description Here...".localized

var kNetworkNotAvailableMessage = "It appears that you are not connected with internet. Please check your internet connection and try again.".localized
var kServerNotReachableMessage = "We are unable to connect our server at the moment. Please check your device internet settings or try later.".localized
var kFacebookSigninFailedMessage = "We are unable to get your identity from Facebook. Please check your Facebook profile settings and then try again.".localized

enum DataType: String {
	case Image				= "0"

}

enum StrainSurveyType: String {
    case Medical                    = "0"
    case Mood                       = "1"
    case Disease                    = "2"
    case Negative                   = "3"
    case Flavor                     = "4"
    
}
enum ActivityLog:String {
    case strainAdd          = "0"
    case followingBud       = "1"
    case QuestionAsked      = "2"
    case Answered           = "3"
    case Liked              = "4"
    case Favourites         = "5"
    case AddedJournal       = "6"
    case StartedJournal     = "7"
    case CreatedGroup       = "8"
    case JoinedGroup        = "9"
    case FollowingTags      = "10"
    case JoinedHealingBud   = "11"
    
    
}
enum StrainDataType: String {
    case Header                 = "0"
    case ButtonChoose			= "1"
    case Description			= "2"
    case SurveyResult			= "3"
    case DetailSurvey			= "4"
    case TextWithImage			= "5"
    case ImageSubmit			= "6"
    case ReviewTotal			= "7"
    case CommentCell			= "8"
    case AddYourcomment			= "9"
    case AddImage               = "10"
    case ShowImage              = "11"
    case AddRating              = "12"
    case TellExperience			= "13"
    case SubmitComment			= "14"
    
    case LocateThisBud			= "15"
    case NearStrain             = "16"
    case StrainBud              = "17"
    
    case StrainAddInfo          = "18"
    case StrainShowDes          = "19"
    case StrainShowType         = "20"
    case StrainShowCrossBreed   = "21"
    case StrainShowCare         = "22"
    case StrainShowEditHeading  = "23"
    case StrainShowUserEdit     = "24"
}


enum AddNewStrain: String {

    case HeaderView         = "0"
    case ImageUpload        = "1"
    case AddInfo            = "2"
    case AddType            = "3"
    case AddBreed           = "4"
    case AddCare            = "5"
    case AddNotes           = "6"
    case Submit             = "7"
}



enum StrainFilter: String {
    
    case NameKeyword            = "0"
    case StrainMatchingText     = "1"
    case Button                 = "2"
    case FilterBy               = "3"
    case TextFieldSearch        = "4"
}


enum  JournalListing : String {
    case ExpandCell = "0"
    case DetailCell = "1"
    case LineCell   = "2"
}
enum JournalCell : String{
    case AddCell     = "0"
    case JournalCell = "1"
    
}
enum TagsCell : String{
    case tags       = "0"
    case tagEdit    = "1"
    case treatment  = "2"
    
}
enum mainSettingCell: String{
    case normalCell = "0"
    case switchCell = "1"
}
enum businessListingSettings: String{
    case titleCell      = "0"
    case premiumCell    = "1"
    case billingCell    = "2"
    case amountCell     = "3"
    case mybusinessCell = "4"
}
enum journalSettings: String{
    case quickEntryCell      = "0"
    case reminderCell        = "1"
    case dataCell            = "2"

}
enum notifications_Alerts: String{
    case mainHeadingCell        = "0"
    case notificationCell       = "1"
    case subHeadingCell         = "2"
    case notificationCell2      = "3"
    
}
enum profileSettings: String{
    case profileSettingsTitleCell                     = "0"
    case profileSettingsDetailCell                    = "1"
    case profileSettingsEmailCell                     = "2"
    case profileSettingsMedicalConditionsCell         = "3"
    case profileSettingsUserInfo                      = "4"
    
}
enum reminderSettings: String{
    case reminderSettingsSwitchCell  = "0"
    case reminderSettingsTimerCell   = "1"
}
enum dataSettings : String{
    case dataSettingsWifiCell           = "0"
    case dataSettingsSyncNotification   = "1"
    case dataSettingsBackupCell         = "2"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
      static let IS_IPHONE_5_OR_LESS          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH <= 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
