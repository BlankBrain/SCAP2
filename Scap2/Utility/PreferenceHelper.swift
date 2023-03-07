//
//  PreferenceHelper.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//

import UIKit

class PreferenceHelper: NSObject
{
    //MARK:- Setting Preference Keys
    private let KEY_GOOGLE_KEY = "google_key";
    private let KEY_CONTACT_EMAIL = "contact_email"
    private let KEY_CONTACT_NUMBER = "contact_number"

    private let KEY_LANGUAGE = "language"
    private let KEY_TERMS_AND_CONDITION = "terms_and_condition"
    private let KEY_PRIVACY_AND_POLICY = "privacy_and_policy"
    private let KEY_USER_TOKEN = "user_token"

  

    //MARK:- User Preference Keys
    private let KEY_IS_SOUND_ON = "is_sound_on"
   

    //MARK:- User Preference Keys
    private let KEY_USER_ID = "user_id"
    private let KEY_USER_TYPE = "user_type"
    private let KEY_SESSION_TOKEN = "session_token"
    private let KEY_DEVICE_TOKEN = "device_token";
    private let KEY_CHAT_NAME = "chat_name"
    private let KEY_PHONE_NUMBER_MAX_LENGTH = "phone_number_max_length";
    private let KEY_PHONE_NUMBER_MIN_LENGTH = "phone_number_min_length";
    private let KEY_COUNTRY_CODE = "country_code"
   
   



    let ph = UserDefaults.standard;
    static let preferenceHelper = PreferenceHelper()

    private override init(){
    }

    deinit {
        printE("\(self) \(#function)")
    }

    //MARK:- Getter Setters
  
    
   
    
    func settCountryCode(CountryCode: String) {
        ph.set(CountryCode, forKey: KEY_COUNTRY_CODE);
        ph.synchronize();
    }
    func gettCountryCode() -> String{
        return (ph.value(forKey: KEY_COUNTRY_CODE) as? String) ?? ""
    }
   

    func setContactEmail(_ email:String){
        ph.set(email, forKey: KEY_CONTACT_EMAIL);
        ph.synchronize();
    }
    func getContactEmail() -> String{
        return (ph.value(forKey: KEY_CONTACT_EMAIL) as? String) ?? ""
    }

    func setChatName(_ name:String){
        ph.set(name, forKey: KEY_CHAT_NAME);
        ph.synchronize();
    }
    func getChatName() -> String{
        return (ph.value(forKey: KEY_CHAT_NAME) as? String) ?? ""
    }

    func setContactNumber(_ contact:String)
    {
        ph.set(contact, forKey: KEY_CONTACT_NUMBER);
        ph.synchronize();
    }
    func getContactNumber() -> String
    {
        return (ph.value(forKey: KEY_CONTACT_NUMBER) as? String) ?? ""
    }

    func setTermsAndCondition(_ url:String)
    {
        ph.set(url, forKey: KEY_TERMS_AND_CONDITION);
        ph.synchronize();
    }
    func getTermsAndCondition() -> String
    {
        return (ph.value(forKey: KEY_TERMS_AND_CONDITION) as? String) ?? ""
    }

    func setPrivacyPolicy(_ url:String)
    {
        ph.set(url, forKey: KEY_PRIVACY_AND_POLICY);
        ph.synchronize();
    }
    func getPrivacyPolicy() -> String
    {
        return (ph.value(forKey: KEY_PRIVACY_AND_POLICY) as? String) ?? ""
    }



  
   

    func setGoogleKey(_ googleKey:String)
    {
        ph.set(googleKey, forKey: KEY_GOOGLE_KEY);
        ph.synchronize();
    }
    func getGoogleKey() -> String
    {
        return (ph.value(forKey: KEY_GOOGLE_KEY) as? String) ?? ""
    }


   

    func setIsSoundOn(_ isOn:Bool)
    {
        ph.set(isOn, forKey: KEY_IS_SOUND_ON);
        ph.synchronize();
    }
    func getIsSoundOn() -> Bool
    {
        return (ph.value(forKey: KEY_IS_SOUND_ON) as? Bool) ?? true
    }

   

    func getMaxPhoneNumberLength() -> Int
    {
        return (ph.value(forKey: KEY_PHONE_NUMBER_MAX_LENGTH) as? Int) ?? 12
    }
    func setMaxPhoneNumberLength(_ length:Int)
    {
        ph.set(length, forKey: KEY_PHONE_NUMBER_MAX_LENGTH);
        ph.synchronize();
    }

    func getMinPhoneNumberLength() -> Int
    {
        return (ph.value(forKey: KEY_PHONE_NUMBER_MIN_LENGTH) as? Int) ?? 8
    }
    func setMinPhoneNumberLength(_ length:Int)
    {
        ph.set(length, forKey: KEY_PHONE_NUMBER_MIN_LENGTH);
        ph.synchronize();
    }

   

    

    //MARK:- Preference User Getter Setters
    func setDeviceToken(_ token:String)
    {
        ph.set(token, forKey: KEY_DEVICE_TOKEN);
        ph.synchronize();
    }
    func getDeviceToken() -> String
    {
        return (ph.value(forKey: KEY_DEVICE_TOKEN) as? String) ?? ""
    }

   

    func setUserId(_ userId:String)
    {
        ph.set(userId, forKey: KEY_USER_ID);
        ph.synchronize();
    }
    func getUserId() -> String
    {
        return (ph.value(forKey: KEY_USER_ID) as? String) ?? ""
    }
    func setUserType(_ userType:String)
    {
        ph.set(userType, forKey: KEY_USER_TYPE);
        ph.synchronize();
    }
    func getUserType() -> String
    {
        return (ph.value(forKey: KEY_USER_TYPE) as? String) ?? ""
    }

    func setSessionToken(_ sessionToken:String)
    {
        ph.set(sessionToken, forKey: KEY_SESSION_TOKEN);
        ph.synchronize();
    }
    func getSessionToken() -> String
    {
        return (ph.value(forKey: KEY_SESSION_TOKEN) as? String) ?? ""
    }
    

    func clearAll()
    {
        ph.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        ph.synchronize();
    }

   
    
    func getStatusMessage() -> String {
        return (ph.value(forKey: "setStatusMessage") as? String) ?? ""
    }
    func setAuthToken(_ token:String){
        ph.set(token, forKey: KEY_USER_TOKEN)
        ph.synchronize()
    }
    
    func getAuthToken() -> String{
        return (ph.value(forKey: KEY_USER_TOKEN) as? String) ?? ""

    }
}
