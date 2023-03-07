//
//  CustomButton.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//
import UIKit

class CustomButton: UIButton {
    
    //MARK: - Properties
    
    private let backgroundLayer = CAShapeLayer()
    
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateUI()
        }
    }
    
    var borderWidth: CGFloat = 2.0 {
        didSet {
            updateUI()
        }
    }
    
    var borderColor: UIColor = .white {
        didSet {
            updateUI()
        }
    }
    
    var backgroundColor1: UIColor = .blue {
        didSet {
            updateUI()
        }
    }
    
    var backgroundColor2: UIColor = .red {
        didSet {
            updateUI()
        }
    }
    
    var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5) {
        didSet {
            updateUI()
        }
    }
    
    var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5) {
        didSet {
            updateUI()
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
        layer.addSublayer(backgroundLayer)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        updateUI()
    }
    
    //MARK: - Update UI
    
    private func updateUI() {
        backgroundLayer.frame = bounds
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        backgroundLayer.path = path
        backgroundLayer.strokeColor = borderColor.cgColor
        backgroundLayer.lineWidth = borderWidth
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [backgroundColor1.cgColor, backgroundColor2.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        backgroundLayer.fillColor = nil
        backgroundLayer.addSublayer(gradient)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
    }
}
