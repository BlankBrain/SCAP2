//
//  Constants.swift
//  Scap2
//
//  Created by Md. Mehedi Hasan on 8/3/23.
//

import Foundation
import UIKit

let  APPDELEGATE =  UIApplication.shared.delegate as! AppDelegate
let preferenceHelper = PreferenceHelper.preferenceHelper

let isConsolePrint = true

public func printE(_ items: Any..., separator: String = "", terminator: String = "") {
    if isConsolePrint {
        debugPrint(items)
    }
}
struct MeasureUnit
{
   static let MINUTES = " min"
   static let KM = " Km"
   static let MILE = " Mile"
}
let TRUE = 1
let FALSE = 0


//MARK: WebService
struct WebService
{
    static let BASE_URL =    ""
    static let IMAGE_BASE_URL =    ""

    
}

//MARK: Segue

struct SEGUE
{
    static let  INTRO_TO_HOME = "loginToChat"
    static let  HOME_TO_PROFILE = "homeToProfile"
    static let  INTRO_TO_SIGNUP = "introToSignUp"
    static let  SIGNUP_TO_CHAT = "signUpToChat"

    


    

    
}

//MARK: Params

struct PARAMS
{
    static let _ID = "_id"
    static let ID = "id"
    static let USER_ID = "user_id"
    static let TOKEN = "token"
    static let PHONE = "phone"
    static let PASSWORD = "password"
    static let EMAIL = "email"
    static let  FIRST_NAME = "first_name"
    static let  LAST_NAME = "last_name"
    static let  NAME = "name";
    
}
////MARK: Messages
//struct Message {
//    let sender: String
//    let message: String
//    let timestamp: Int
//}
//MARK: date Format
struct DateFormat
{
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let WEB   = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    static let DATE_TIME_FORMAT_HISTORY = "dd MMMM yyyy, hh:mm a"
    
    static let HISTORY_TIME_FORMAT = "hh:mm a"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_MM_DD_YYYY = "MM/dd/yyyy"
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd hh:mm a"
    static let SCHEDUALE_DATE_FORMATE = "EEEE d MMMM 'at' HH:mm"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
    
    
}

struct Google
{
    static let  OK = "OK"
    static let  STATUS = "status"
    static let  RESULTS = "results"
    static let  KEY = "key"
    static let  EMAIL = "email"
    static let  ID = "id"
}
enum Day: Int
{
    case SUN = 0
    case MON = 1
    case TUE = 2
    case WED = 3
    case THU = 4
    case FRI = 5
    case SAT = 6
    func text() -> String
    {
        switch self
        {
            
        case .SUN : return "SUN"
        case .MON : return "MON"
        case .TUE : return "TUE"
        case .WED : return "WED"
        case .THU: return "THU"
        case .FRI : return "FRI"
        case .SAT : return "SAT"
        }
    }
}
struct Gender
{
    static let MALE = "male";
    static let FEMALE = "female";
}

