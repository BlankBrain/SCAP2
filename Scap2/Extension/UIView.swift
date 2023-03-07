//
//  UIView.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 2/3/23.
//

import Foundation
import UIKit

extension UIView {
    func showCountdownPopup(message: String, duration: TimeInterval = 5, actionTitle: String = "Action", cancelTitle: String = "Cancel", actionHandler: @escaping () -> Void) {
        
        // Create the popup view
        let popupView = UIView(frame: UIScreen.main.bounds)
        popupView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Create the message label
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.center = CGPoint(x: popupView.center.x, y: popupView.center.y - 50)
        popupView.addSubview(messageLabel)
        
        // Create the countdown label
        let countdownLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countdownLabel.text = "\(Int(duration))"
        countdownLabel.textAlignment = .center
        countdownLabel.center = CGPoint(x: popupView.center.x, y: popupView.center.y)
        popupView.addSubview(countdownLabel)
        
//        // Create the action button
//        let actionButton = UIButton(type: .system)
//        actionButton.setTitle(actionTitle, for: .normal)
//        actionButton.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
//        actionButton.center = CGPoint(x: popupView.center.x, y: popupView.center.y + 50)
//        popupView.addSubview(actionButton)
//        
//        // Create the cancel button
//        let cancelButton = UIButton(type: .system)
//        cancelButton.setTitle(cancelTitle, for: .normal)
//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
//        cancelButton.center = CGPoint(x: popupView.center.x, y: popupView.center.y + 100)
//        popupView.addSubview(cancelButton)
        
        // Add the popup view to the current view
        self.addSubview(popupView)
        
        // Start the countdown timer
        var countdownDuration = duration
        var countdownTimer: Timer?
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdownDuration -= 1
            countdownLabel.text = "\(Int(countdownDuration))"
            
            // If the countdown reaches 0, dismiss the popup and call the action handler
            if countdownDuration == 0 {
                countdownTimer?.invalidate()
                popupView.removeFromSuperview()
                actionHandler()
            }
        }
    }
    
    // Action button handler
//    @objc func actionButtonTapped(_ sender: UIButton) {
//        // Call the action handler and dismiss the popup
//        guard let popupView = sender.superview else {
//            return
//        }
//        let countdownLabel = popupView.subviews[1] as! UILabel
//        countdownLabel.text = "0"
//        countdownTimer?.invalidate()
//        popupView.removeFromSuperview()
//        actionHandler?()
//    }
//
//    // Cancel button handler
//    @objc func cancelButtonTapped(_ sender: UIButton) {
//        // Cancel the countdown and dismiss the popup
//        guard let popupView = sender.superview else {
//            return
//        }
//        let countdownLabel = popupView.subviews[1] as! UILabel
//        countdownLabel.text = "0"
//        countdownTimer?.invalidate()
//        popupView.removeFromSuperview()
//    }
    
    
}
extension UIView {
    static let progressBarTag = 100 // A unique tag to identify the progress bar view
    
    static func showProgressBar() {
        // Check if a progress bar view already exists on the current window
        if let existingProgressBar = UIApplication.shared.windows.first(where: { $0.viewWithTag(progressBarTag) != nil })?.viewWithTag(progressBarTag) {
            // If a progress bar view already exists, bring it to the front and return
            existingProgressBar.superview?.bringSubviewToFront(existingProgressBar)
            return
        }
        
        // Create a new progress bar view
        let progressBarView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        progressBarView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        progressBarView.layer.cornerRadius = 10
        progressBarView.tag = progressBarTag
        
        // Create the progress bar indicator
        let progressBarIndicator = UIActivityIndicatorView(style: .whiteLarge)
        progressBarIndicator.center = CGPoint(x: progressBarView.bounds.width / 2, y: progressBarView.bounds.height / 2)
        progressBarIndicator.startAnimating()
        progressBarView.addSubview(progressBarIndicator)
        
        // Add the progress bar view to the current window
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            progressBarView.center = window.center
            window.addSubview(progressBarView)
        }
    }
    
    static func hideProgressBar() {
        // Find the progress bar view on the current window and remove it
        UIApplication.shared.windows.first(where: { $0.viewWithTag(progressBarTag) != nil })?.viewWithTag(progressBarTag)?.removeFromSuperview()
    }
}
