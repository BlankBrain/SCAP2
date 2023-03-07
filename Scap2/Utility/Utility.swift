//
//  Utility.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 26/2/23.
//

import Foundation
import UIKit

class Utility {
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var overlayView = UIView();
    static var mainView = UIView();

    static func showPopup(with message: String, on viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showLoading(color: UIColor = UIColor.white){
        DispatchQueue.main.async {
            if(!activityIndicator.isAnimating)
            {
                self.mainView = UIView()
                self.mainView.frame = UIScreen.main.bounds
                self.mainView.backgroundColor = UIColor.clear
                self.overlayView = UIView()
                self.activityIndicator = UIActivityIndicatorView()
                
                overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                overlayView.layer.zPosition = 1
                
                activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                activityIndicator.style = .gray
                overlayView.addSubview(activityIndicator)
                self.mainView.addSubview(overlayView)
                
                if APPDELEGATE.window?.viewWithTag(701) != nil
                {}
                else
                {
                    overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 701
                    UIApplication.shared.keyWindow?.addSubview(mainView)
                    activityIndicator.startAnimating()
                }
            }
        }
    }
    static func hideLoading() {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }
        //MARK: email validator
    static func isValidEmail(email: String) -> Bool {
        // Regular expression pattern for validating email addresses
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        
        // Use the regular expression object to match the email address
        let range = NSRange(location: 0, length: email.count)
        let matches = regex.matches(in: email, options: [], range: range)
        
        // Return true if at least one match was found
        return !matches.isEmpty
    }
    //MARK: phone validator
     static func isValidPhoneNumber(phoneNumber: String, min: Int, max: Int) -> Bool {
        // Regular expression pattern for validating phone numbers
        let pattern = "^\\d{\(min),\(max)}$"
        
        // Create a regular expression object
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        
        // Use the regular expression object to match the phone number
        let range = NSRange(location: 0, length: phoneNumber.count)
        let matches = regex.matches(in: phoneNumber, options: [], range: range)
        
        // Return true if at least one match was found
        return !matches.isEmpty
    }
    
}


class LoadingIndicator {
    static func create() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = UIColor.red
        indicator.startAnimating()
        indicator.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = UIColor.blue.cgColor
        animation.duration = 2.0
        animation.repeatCount = Float.infinity
        
        indicator.layer.add(animation, forKey: "backgroundColor")
        
        return indicator
    }
    
    static func stop(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}
//example
//let indicator = LoadingIndicator.create()
//view.addSubview(indicator)
//
//// ...
//
//LoadingIndicator.stop(indicator: indicator)

class TransitionAnimation {
    static func performTransition(view: UIView, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionCrossDissolve, animations: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: view, duration: duration, options: options, animations: {
            animations?()
        }, completion: { completed in
            completion?(completed)
        })
    }
}

//MARK: reachability
//@objc func reachabilityChanged(notification: Notification) {
//let reachability = notification.object as! Reachability
//
//switch reachability.connection {
//case .wifi, .cellular:
//    // Internet is available
//    print("Internet is available")
//case .none:
//    // Internet is not available
//    print("Internet is not available")
//
//    let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: .alert)
//    let retryAction = UIAlertAction(title: "Retry", style: .default) { (_) in
//        // Retry action
//        print("Retry")
//    }
//    let switchToMobileDataAction = UIAlertAction(title: "Switch to Mobile Data", style: .default) { (_) in
//        // Open cellular data settings
//        guard let url = URL(string: "App-Prefs:root=MOBILE_DATA_SETTINGS_ID") else { return }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
//    alertController.addAction(retryAction)
//    alertController.addAction(switchToMobileDataAction)
//
//    let rootViewController = self.window?.rootViewController
//    rootViewController?.present(alertController, animated: true, completion: nil)
//}
//}


// MARK: import library from  https://github.com/ashleymills/Reachability.swift 
