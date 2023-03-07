//
//  CustomTextField.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//

import Foundation
import UIKit
class CustomTextField: UITextField {
    
    //MARK: - Properties
    
    var placeholderColor: UIColor = .gray {
        didSet {
            updatePlaceholder()
        }
    }
    
    var borderColor: UIColor = .gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    var leftPadding: CGFloat = 16.0 {
        didSet {
            updatePadding()
        }
    }
    
    var rightPadding: CGFloat = 16.0 {
        didSet {
            updatePadding()
        }
    }
    
    var isTextOnly: Bool = false {
        didSet {
            updateKeyboardType()
        }
    }
    
    var isNumberOnly: Bool = false {
        didSet {
            updateKeyboardType()
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    //MARK: - UI Setup
    
    private func setupUI() {
        borderStyle = .none
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        updatePadding()
        updatePlaceholder()
        updateKeyboardType()
    }
    
    //MARK: - Update UI
    
    private func updatePadding() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: frame.height))
        leftView.backgroundColor = .clear
        leftView.isUserInteractionEnabled = false
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: frame.height))
        rightView.backgroundColor = .clear
        rightView.isUserInteractionEnabled = false
        
        leftViewMode = .always
        rightViewMode = .always
        
        self.leftView = leftView
        self.rightView = rightView
    }
    
    private func updatePlaceholder() {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    private func updateKeyboardType() {
        if isTextOnly {
            keyboardType = .alphabet
        } else if isNumberOnly {
            keyboardType = .numberPad
        } else {
            keyboardType = .default
        }
    }
}

