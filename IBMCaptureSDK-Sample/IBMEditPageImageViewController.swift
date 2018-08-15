//
//  IBMEditPageImageViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMEditPageImageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let IBMEditPageCellIdentifier = "IBMEditPageCellIdentifier"
    let imageEditor = ICPCoreImageImageEngine()
    
    enum IBMEditTool:Int {
        case deskew = 0, crop, bw, grayscale, rotate, edge, count
    }
    
    @IBOutlet weak var pageImage:UIImageView!
    @IBOutlet weak var tableView:UITableView!
    
    var originalImage:UIImage!
    var changeNotifier:((UIImage)->Void)?
    
    var modifiedImage:UIImage! {
        get {
            return pageImage.image ?? originalImage
        }
        set {
            pageImage.image = newValue
            changeNotifier?(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImage.image = originalImage
    }
    
    //MARK: Table view configuration
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Edit Tools"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IBMEditTool.count.rawValue
    }
    
    func titleForItem(_ item:Int) -> String {
        guard let tool = IBMEditTool(rawValue: item) else {
            return ""
        }
        switch tool {
        case .deskew: return "Deskew"
        case .crop: return "Crop"
        case .bw: return "B&W"
        case .grayscale: return "Grayscale"
        case .rotate: return "Rotate 90"
        case .edge: return "Detect Edges"
        case .count: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IBMEditPageCellIdentifier, for: indexPath)
        cell.textLabel?.text = titleForItem((indexPath as NSIndexPath).row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let tool = IBMEditTool(rawValue: (indexPath as NSIndexPath).row), let image = (pageImage.image ?? originalImage) else {
            return
        }
        
        switch tool {
        case .deskew:
            deskew(image)
        case .crop:
            crop(image)
        case .bw:
            blackAndWhite(image)
        case .grayscale:
            grayscale(image)
        case .rotate:
            rotateImage(image)
        case .edge:
            detectEdges(image)
        case .count:
            return
        }
    }
    
    //MARK: Actions
    @IBAction func resetImage(_ sender: AnyObject) {
        modifiedImage = originalImage
    }
    
    
    //MARK: Tools
    func deskew(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        imageEditor.detectEdgesAndDeskewImage(image, withValidator:  nil) { [weak self] (deskedImage) -> Void in
            hud.hide(true)
            guard let deskedImage = deskedImage else {
                return
            }
            self?.modifiedImage = deskedImage
        }
    }
    
    func crop(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let rect = CGRect(x: image.size.width * 0.5,
            y: image.size.height * 0.5,
            width: image.size.width * 0.5,
            height: image.size.height * 0.5);
        imageEditor.cropRect(rect, inImage: image) { [weak self] (cropedImage) -> Void in
            hud.hide(true)
            guard let cropedImage = cropedImage else {
                return
            }
            self?.modifiedImage = cropedImage
        }
    }
    
    func blackAndWhite(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        imageEditor.applyFilter(.BlackAndWhite, toImage: image) { [weak self] (blackWhiteImage) -> Void in
            hud.hide(true)
            guard let blackWhiteImage = blackWhiteImage else {
                return
            }
            self?.modifiedImage = blackWhiteImage
        }
    }
    
    func grayscale(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        imageEditor.applyFilter(.Grayscale, toImage: image) { [weak self] (grayscaleImage) -> Void in
            hud.hide(true)
            guard let grayscaleImage = grayscaleImage else {
                return
            }
            self?.modifiedImage = grayscaleImage
        }
    }
    
    func rotateImage(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        imageEditor.rotateToLeftImage(image) { [weak self] (rotatedImage) -> Void in
            hud.hide(true)
            guard let rotatedImage = rotatedImage else {
                return
            }
            self?.modifiedImage = rotatedImage
        }
    }
    
    func detectEdges(_ image:UIImage) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        imageEditor.detectEdgePointsInImage(image, withValidator:nil) { [weak self] (points) -> Void in
            hud.hide(true)
            
            let alertMessage:String
            
            defer {
                if let alert = self?.alertController(title: "Edges", message: alertMessage) {
                    self?.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            guard let nsPoints = points , nsPoints.count > 0 else {
                alertMessage = "Couldn't detect the edges"
                return
            }
            
            var messageString = ""
            
            for (index, nsPoint) in nsPoints.enumerate() {
                let cgPoint = nsPoint.CGPointValue()
                let x = String(format: "%.2f", cgPoint.x)
                let y = String(format: "%.2f", cgPoint.y)
                
                messageString = "\(messageString)\n Edge \(index): \(x) x \(y)"
            }
            
            alertMessage = messageString
        }
        
    }
    
    func alertController(title:String, message:String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
}
