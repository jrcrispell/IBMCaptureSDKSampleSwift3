//
//  UIImage+Extension.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func whiteDotImage () -> UIImage {
        
        let size = CGSize.init(width: 10.0, height: 10.0)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(UIColor.white.cgColor);
        context?.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        
        let image : UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}
