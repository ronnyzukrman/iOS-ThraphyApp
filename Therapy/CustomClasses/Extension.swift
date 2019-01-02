//
//  Extension.swift
//  loginWithApi
//
//  Created by SIERRA on 6/6/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable
{ // show progress hud
    func showProgress() {
        // loader starts
        let size = CGSize(width: 50, height:50)
        self.startAnimating(size, message:"Loading", messageFont: UIFont.systemFont(ofSize: 18.0), type: NVActivityIndicatorType.ballRotateChase, color: UIColor.white, padding: 1, displayTimeThreshold: nil, minimumDisplayTime: nil)
    }

    
    // hide progress hud
    func hideProgress() {
        // stop loader
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.stopAnimating() }
    }
    

    func alert(title:String?,message:String?)
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
       
    
}
extension UIView{
    // Shadow OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 0.5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
