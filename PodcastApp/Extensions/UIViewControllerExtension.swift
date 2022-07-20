//
//  UIViewControllerExtension.swift
//  PodcastApp
//
//  Created by Daisoreanu Laurentiu on 19.07.2022.
//

import Foundation
import UIKit

extension UIViewController {
    var backgroundColor: UIColor? {
        return self.view.backgroundColor
    }
    
    func add(child vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.pinAllEdges(toFill: self.view)
        vc.didMove(toParent: self)
    }
    
    func removeChild() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
