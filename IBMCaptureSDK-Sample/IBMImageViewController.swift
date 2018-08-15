//
//  IBMImageViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMImageViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var activityIndicatorView : UIActivityIndicatorView!
    
    var image : UIImage!
    var cornersImageViews : Array<UIImageView> = []
    
    lazy var imageEngine : ICPImageEngine = {
        return ICPCoreImageImageEngine.init()
    }()
    
    // If the corners are not detected, place the draggable markers at the 4 corners of the image
    lazy var defaultPoints : Array<NSValue> = {
        
        let margin : CGFloat = 0.1 * self.image.size.width
        let topLeft = CGPoint.init(x: margin, y: margin)
        let topRight = CGPoint.init(x: self.image.size.width - margin, y: margin)
        let bottomRight = CGPoint.init(x: self.image.size.width - margin, y: self.image.size.height - margin)
        let bottomLeft = CGPoint.init(x: margin, y: self.image.size.height - margin)
        return [NSValue.init(cgPoint: topLeft), NSValue.init(cgPoint: topRight), NSValue.init(cgPoint: bottomRight), NSValue.init(cgPoint: bottomLeft)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
        
        self.detect()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(IBMImageViewController.deskew))
    }
    
    // This method uses the IBMCaptureUISDK image engine to find the 4 corners of a rectangle in the picture.
    func detect() {
        
        let completionBlock : ICPImageEngineEdgePointsDetectedBlock = { [weak self] (points: Array<NSValue>?) in
            
            if let weakSelf = self {
                weakSelf.activityIndicatorView.stopAnimating()
                
                if let detectedPoints = points {
                    if detectedPoints.count == 4 {
                        weakSelf.addCornersImageViews(detectedPoints)
                        return
                    }
                }
                weakSelf.addCornersImageViews(weakSelf.defaultPoints)
                
            }
        }
        
        self.activityIndicatorView.startAnimating()
        self.imageEngine.detectEdgePointsin: withInImage(self.image, withValidator: nil, andCompletionBlock: completionBlock)
        
    }
    
    // This methods uses the IBMCaptureUISDK image engine to deskew the document from the auto detected corners or corners placed by the user
    func deskew(){
        
        let completionBlock : ICPImageEngineImageProcessedBlock = { [weak self] (image : UIImage?) in
            
            if let weakSelf = self {
                weakSelf.activityIndicatorView.stopAnimating()
                if let deskewedImage = image {
                    weakSelf.imageView.image = deskewedImage
                }
                weakSelf.navigationItem.rightBarButtonItem = nil
                
            }
        }
        
        self.activityIndicatorView.startAnimating()
        self.imageEngine.deskewRect(withPoints: self.pointsFromCornersImageViews(), in: self.image, completionBlock: completionBlock)
        self.removeCornersImageViews()
        
    }
    
    // This method is used to convert point from UIImageView to UIImage and vice versa
    func translatePointToScale(_ point: CGPoint, imageViewToImageConversion : Bool) -> CGPoint {
        
        let imageViewSize = self.imageView.bounds.size
        let imageSize = self.image.size
        let imageWidthToHeightRatio = self.image.size.width / self.image.size.height
        
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        var scale : CGFloat
        if imageViewSize.width > imageViewSize.height {
            scale = imageViewSize.height / imageSize.height;
            let newWidth = self.imageView.bounds.size.height * imageWidthToHeightRatio
            xOffset = (self.imageView.bounds.size.width - newWidth) / 2
        } else {
            scale = imageViewSize.width / imageSize.width;
            let newHeight = self.imageView.bounds.size.width / imageWidthToHeightRatio
            yOffset = (self.imageView.bounds.size.height - newHeight) / 2
        }
        
        if imageViewToImageConversion {
            scale = 1 / scale
            let offsetPoint = CGPoint.init(x: point.x - xOffset, y: point.y - yOffset)
            return offsetPoint.applying(CGAffineTransform.identity.scaledBy(x: scale, y: scale))
        }else{
            var resultPoint = point.applying(CGAffineTransform.identity.scaledBy(x: scale, y: scale))
            resultPoint = CGPoint.init(x: resultPoint.x + xOffset, y: resultPoint.y + yOffset)
            return resultPoint
        }
    }
    
    func addCornersImageViews(_ points: Array<NSValue>!) {
        
        for i in 0...3 {
            let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(IBMImageViewController.handlePanGesture(_:)))
            let point : CGPoint = self.translatePointToScale(points[i].cgPointValue, imageViewToImageConversion: false)
            let imageView : UIImageView = self.cornerImageViewAtPoint(point)
            imageView.addGestureRecognizer(panGestureRecognizer)
            self.cornersImageViews.insert(imageView, at: i)
            self.imageView.addSubview(imageView)
        }
    }
    
    func removeCornersImageViews(){
        for i in 0...3 {
            self.cornersImageViews[i].removeFromSuperview()
        }
    }
    
    func cornerImageViewAtPoint(_ point: CGPoint) -> UIImageView{
        
        let cornerImageSize = CGSize.init(width: 30.0, height: 30.0)
        let cornerImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 3 * cornerImageSize.width, height: 3 * cornerImageSize.height))
        cornerImageView.image = UIImage.whiteDotImage()
        cornerImageView.center = point
        cornerImageView.contentMode = UIViewContentMode.center
        cornerImageView.isUserInteractionEnabled = true
        return cornerImageView
    }
    
    func pointsFromCornersImageViews () -> Array<NSValue> {
        
        var results : Array<NSValue> = []
        for i in 0...3 {
            let point : NSValue = NSValue.init(cgPoint: self.translatePointToScale(self.cornersImageViews[i].center, imageViewToImageConversion: true))
            results.insert(point, at: i)
        }
        return results
        
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer){
        
        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view?.center = CGPoint.init(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
    }
    
}
