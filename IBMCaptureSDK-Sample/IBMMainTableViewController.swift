//
//  IBMMainTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK
import IBMCaptureUISDK

class IBMMainTableViewController: UITableViewController {

    enum IBMMainTableSegue:String {
        case IBMMainToBatchSegue = "IBMMainToBatchSegue",
        IBMMainToImageEngineSegue = "IBMMainToImageEngineSegue",
        IBMMainToOCRSegue = "IBMMainToOCRSegue",
        IBMMainToBarcodeSegue = "IBMMainToBarcodeSegue",
        IBMMainToImageEditorSegue = "IBMMainToImageEditorSegue",
        IBMMainToCheckProcessing = "IBMMainToCheckProcessing",
        IBMMainToRecognizePageFields = "IBMMainToRecognizePageFields",
        IBMMainToCameraView = "IBMMainToCameraView",
        IBMMainToManualDeskew = "IBMMainToManualDeskew"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let imageEngineController = segue.destination as? IBMEditPageImageViewController , segue.identifier == IBMMainTableSegue.IBMMainToImageEngineSegue.rawValue {
            imageEngineController.originalImage = UIImage(named: "driver_demo")
            return
        }
        
        if let navController = segue.destination as? UINavigationController , segue.identifier == IBMMainTableSegue.IBMMainToImageEditorSegue.rawValue {
            let editor = createImageEditor()
            navController.showViewController(editor, sender: self)
        }
    
        if let loginViewController = segue.destination as? IBMLoginController , segue.identifier == IBMMainTableSegue.IBMMainToCheckProcessing.rawValue{
            loginViewController.demo = IBMDemo.checkProcessing
        }
        
        if let loginViewController = segue.destination as? IBMLoginController , segue.identifier == IBMMainTableSegue.IBMMainToRecognizePageFields.rawValue{
            loginViewController.demo = IBMDemo.recognizePageFields
        }
        
        if let cameraViewController = segue.destination as? IBMCameraViewController , segue.identifier == IBMMainTableSegue.IBMMainToCameraView.rawValue{
            cameraViewController.demo = IBMDemo.cameraView
        }
        
        if let cameraViewController = segue.destination as? IBMCameraViewController , segue.identifier == IBMMainTableSegue.IBMMainToManualDeskew.rawValue{
            cameraViewController.demo = IBMDemo.manualDeskew
        }
        
    }
    
    func createImageEditor() -> ICPImageEditingController {
        let image = UIImage(named: "driver_demo")
        let imageEngine = ICPCoreImageImageEngine()
        
        let imageEditingController = ICPImageEditingController(originaImage: image!, modifiedImage: image!, imageEngine: imageEngine, validator: nil) { [weak self] (controller, image, changed) -> Void in
            
            guard let sself = self else {
                return
            }
            
            sself.dismissViewControllerAnimated(true, completion: nil)
        }
        
        imageEditingController.tintColor = UIColor.purpleColor()
        
        let rotateLeft = ICPImageEditingAction(actionType: .RotateLeft)
        imageEditingController.addImageEditingAction(rotateLeft)
        
        let rotate = ICPImageEditingAction(actionType: .RotateRight)
        imageEditingController.addImageEditingAction(rotate)
        
        let deskew = ICPImageEditingAction(actionType: .Deskew)
        imageEditingController.addImageEditingAction(deskew)
        
        if let customFilterImage = UIImage(named: "filters") {
            let filters = ICPImageEditingAction(image:customFilterImage, actionType: .Filters)
            imageEditingController.addImageEditingAction(filters)
        }
        
        if let blackAndWhiteImage = UIImage(named: "black_and_white") {
            let blackAndWhite = ICPImageEditingAction(image: blackAndWhiteImage) {
                return IBMUIImageEffects.CIBlackAndWhite($0) ?? $0
            }
            imageEditingController.addImageEditingAction(blackAndWhite)
        }
        
        
        let autoDeskew = ICPImageEditingAction(actionType: .AutoDeskew)
        imageEditingController.runImageEditingActionOnPresentation(autoDeskew)
        
        return imageEditingController
    }
    
}
