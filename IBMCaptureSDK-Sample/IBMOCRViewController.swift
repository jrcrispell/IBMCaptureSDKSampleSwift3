//
//  IBMOCRViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMOCRViewController: UIViewController {

    let IBMOCRMetadataCellIdentifier = "IBMOCRMetadataCellIdentifier"
    
    @IBOutlet weak var ocrImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var metadataTableView: UITableView!
    
    let metadata:[String:AnyObject?] = [:]
    let ocrEngine = ICPTesseractOcrEngine(tessDataPrefixes: ["eng"], andTessdataAbsolutePath: Bundle.mainBundle().bundlePath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ocrImage.image = UIImage(named: "demo")
        textLabel.text = "Text:"
    }
    
    //MARK: Actions
    @IBAction func performOCR(_ sender: AnyObject) {
        guard let image = ocrImage.image else {
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        let predefinedRect = CGRect(x: 312.0, y: 464.0, width: 450.0, height: 68.0)
        
        ocrEngine.recognizeTextInImage(image, withRect: predefinedRect, whitelist: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ()", highlightChars: false) { [weak self] (textImage, text, metadata) -> Void in
            hud.hide(true)
            self?.ocrImage.image = textImage
            self?.textLabel.text = "Text: \(text)"
        }
    }
}
