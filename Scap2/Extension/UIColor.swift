//
//  UIColor.swift
//  OtpChat
//
//  Created by Md. Mehedi Hasan on 1/3/23.
//

import Foundation
import UIKit
extension UIColor {
    
    
    // Creates a random color.
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    
    // Creates a gradient color from an array of colors and a gradient direction.
    static func gradientColor(from colors: [UIColor], withDirection direction: GradientDirection, size: CGSize) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = direction.startPoint
        gradientLayer.endPoint = direction.endPoint
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: UIImage(cgImage: image))
    }
    
    // Creates a gradient color from an array of colors and a gradient direction.
    static func gradientColor(from colors: [UIColor], withDirection direction: GradientDirection, frame: CGRect) -> UIColor? {
        return gradientColor(from: colors, withDirection: direction, size: frame.size)
    }
    
    // Creates a gradient color from an array of colors and a gradient direction.
    static func gradientColor(from colors: [UIColor], withDirection direction: GradientDirection, view: UIView) -> UIColor? {
        return gradientColor(from: colors, withDirection: direction, size: view.bounds.size)
    }
    
    // Defines the direction of a gradient color.
    enum GradientDirection {
        case horizontal
        case vertical
        
        var startPoint: CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 0.0, y: 0.5)
            case .vertical:
                return CGPoint(x: 0.5, y: 0.0)
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 1.0, y: 0.5)
            case .vertical:
                return CGPoint(x: 0.5, y: 1.0)
            }
        }
    }
    
    // Converts a color from HEX format to UIColor format.
    static func fromHex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Converts a color from RGB format to UIColor format.
    static func fromRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // Converts a color from HSB format to UIColor format.
    static func fromHSB(_ hue: CGFloat, _ saturation: CGFloat, _ brightness: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hue: hue/360.0, saturation: saturation/100.0, brightness: brightness/100.0, alpha: alpha)
    }
    
    // Converts a color from CMYK format to UIColor format.
    static func fromCMYK(_ cyan: CGFloat, _ magenta: CGFloat, _ yellow: CGFloat, _ key: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let red = (1 - cyan) * (1 - key)
        let green = (1 - magenta) * (1 - key)
        let blue = (1 - yellow) * (1 - key)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Converts a color from UIColor format to HEX format.
    func toHex() -> String {
        guard let components = cgColor.components else { return "#000000" }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }
    
    // Converts a color from UIColor format to RGB format.
    func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let components = cgColor.components else { return (0, 0, 0, 0) }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]
        return (red * 255, green * 255, blue * 255, alpha)
    }
    
    // Converts a color from UIColor format to HSB format.
    func toHSB() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue * 360, saturation * 100, brightness * 100, alpha)
    }
    
    // Converts a color from UIColor format to CMYK format.
    func toCMYK() -> (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, key: CGFloat, alpha: CGFloat) {
        guard let components = cgColor.components else {
            return (0, 0, 0, 0, 0)
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let k = 1 - max(red, green, blue)
        let c = (1 - red - k) / (1 - k)
        let m = (1 - green - k) / (1 - k)
        let y = (1 - blue - k) / (1 - k)
        
        return (c, m, y, k, cgColor.alpha)
    }
    
    // Creates a color gradient between two colors.
    static func gradient(from startColor: UIColor, to endColor: UIColor, withHeight height: CGFloat) -> UIColor {
        let size = CGSize(width: 1, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: size)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.render(in: context)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: image)
    }
    
}
