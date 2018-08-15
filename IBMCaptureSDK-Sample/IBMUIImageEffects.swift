//
//  IBMUIImage.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import CoreImage

class IBMUIImageEffects {
    static func CIBlackAndWhite(_ image:UIImage?) -> UIImage? {
        
        guard let cgImage = image?.cgImage else {
            return image
        }

        let originalImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIColorMonochrome", withInputParameters: [kCIInputImageKey:originalImage, "inputIntensity":NSNumber(value: 1.0 as Float), "inputColor": CIColor(color: UIColor.white)])
        
        guard let outputImage = filter?.outputImage else {
            return image
        }
        
        let context = CIContext(options: nil)
        let imageReference = context.createCGImage(outputImage, from: outputImage.extent)
        let newImage = UIImage(cgImage: imageReference!)
        
        return newImage
    }
}
