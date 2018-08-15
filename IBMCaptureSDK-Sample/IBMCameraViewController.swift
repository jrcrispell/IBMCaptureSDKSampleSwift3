//
//  IBMCameraViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK
import IBMCaptureUISDK

class IBMCameraViewController: UIViewController, ICPCameraViewDelegate {

    let IBMCameraControllerToPage = "IBMCameraControllerToPage"
    let IBMCameraControllerToManualDeskewImageView = "IBMCameraControllerToManualDeskewImageView"
    
    @IBOutlet weak var cameraView : ICPCameraView!
    @IBOutlet weak var label : UILabel!
    
    var objectFactory:ICPObjectFactory!
    var demo : IBMDemo?
    var sessionManager:ICPSessionManager!
    
    deinit{
        self._removeNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.cameraView.delegate = self
        
        //Optional setup
        self.cameraView.minimumScreenPercentage = 0.5
        self.cameraView.maximumAspectRatio = 6
        self.cameraView.minimumAspectRatio = 0.2
        self.cameraView.accelerationThreshold = 0.1
        self.cameraView.detectDocumentsWithTextOnly = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cameraView.restartPreview()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IBMCameraViewController._stopPreview), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IBMCameraViewController._restartPreview), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cameraView.stopPreview()
        
        self._removeNotificationObservers()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let pageViewController = segue.destination as? IBMPageViewController , segue.identifier == IBMCameraControllerToPage{
            
            let capture = ICPCapture.instance(with: .nonPersistent)
            let objectFactory = capture?.objectFactory
            let page = objectFactory?.page(with: nil, type: nil)
            page?.modifiedImage = sender as? UIImage
            pageViewController.sessionManager = sessionManager
            pageViewController.page = page
            pageViewController.demo = self.demo
            
        }else if let imageViewController = segue.destination as? IBMImageViewController , segue.identifier == IBMCameraControllerToManualDeskewImageView{
            imageViewController.image = sender as? UIImage
        }
    }
    
    func _restartPreview(){
        self.cameraView.restartPreview()
    }
    
    func _stopPreview(){
        self.cameraView.stopPreview()
    }
    
    func _removeNotificationObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: ICPCameraViewDelegate
    
    func cameraView(_ cameraView: ICPCameraView, didTakeOriginalPhoto originalPhoto: UIImage?, modifiedPhoto: UIImage?) {
        
        if(self.demo == .cameraView){
            self.performSegue(withIdentifier: IBMCameraControllerToPage, sender: modifiedPhoto)
        }else if(self.demo == .manualDeskew){
            self.performSegue(withIdentifier: IBMCameraControllerToManualDeskewImageView, sender: originalPhoto)
        }
        
    }
    
    func cameraViewDidDetectDocument(_ cameraView: ICPCameraView){
        self.cameraView.takePhoto()
    }
    
    func cameraView(_ cameraView: ICPCameraView, didChange cameraState: ICPCameraViewState) {
        if (cameraState == .lookingForDocument) {
            self.label.text = "Looking for document ..."
        }else if(cameraState == .cameraMoving){
            self.label.text = "Hold camera in place"
        }else if(cameraState == .invalidRatio){
            self.label.text = "Document has invalid aspect ratio"
        }else if(cameraState == .documentTooSmall){
            self.label.text = "Bring camera closer"
        }else if(cameraState == .documentDetected){
            self.label.text = "Document Detected"
        }else if(cameraState == .cannotDetectTextInDocument){
            self.label.text = "Cannot detect text"
        }else{
            self.label.text = ""
        }
    }

}
