//
//  UIViewExtension.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func pinAllEdges(toFill parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // Shadow
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    // Corner radius
    @IBInspectable var cornerRadius: Bool {
        get {
            return self.layer.cornerRadius != 0.0
        }
        
        set {
            self.layer.cornerRadius = 4.0
        }
    }
    
    // Corner radius
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            if newValue > 0.0 {
                self.layer.borderWidth = newValue
            }
        }
    }
    
    // Corner radius
    @IBInspectable var borderColour: UIColor {
        get {
            if let color  = self.layer.borderColor {
                return  UIColor(cgColor: color)
            }
            return UIColor.clear
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    fileprivate func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                               shadowOffset: CGSize = CGSize.zero,
                               shadowOpacity: Float = 0.2,
                               shadowRadius: CGFloat = 5.0,
                               cornerRadius: CGFloat = 15.0) {
        let layer = self.layer
        layer.masksToBounds = false
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        //        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
    
}
