//
//  IBMBatchTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK
import IBMCaptureUISDK

extension ICPDocumentType {
    var description:String {
        return typeId
    }
}

class IBMBatchTableViewController: UITableViewController {

    let IBMBatchCellIdentifier = "IBMBatchCellIdentifier"
    let IBMBatchToDocumentSegue = "IBMBatchToDocumentSegue"
    
    var batchType:ICPBatchType!
    var capture:ICPCapture!
    var service:ICPDatacapService!
    var sessionManager:ICPSessionManager!
    var datacapHelper:ICPDatacapHelper!
    var batch:ICPBatch!
    var hud:MBProgressHUD? = nil
    var cameraController:ICPCameraController!
    
    lazy var ocrEngine:ICPOcrEngine = {
        let engine = ICPTesseractOcrEngine()
        return engine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        batch = capture.objectFactory?.batchWithService(nil, type: batchType)
        cameraController = ICPCameraController(objectFactory: self.capture.objectFactory!, batch: batch, currentDocument: nil, batchType: self.batchType, ocrEngine: self.ocrEngine, completionBlock: self.cameraControllerCompletion)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - Table view configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Documents"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batch?.documents.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IBMBatchCellIdentifier, for: indexPath)
        
        guard let document = batch?.documents[indexPath.row] else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = document.type?.typeId ?? "";
        cell.detailTextLabel?.text = "\(document.pages.count) pages"
        
        return cell
    }
    
    //MARK: - Camera Controller
    
    /**
        9. The ICPCameraController from the IBMCaptureUI is created using an ICPBatchType, and presented using the same method as any other UIViewController.
        The ICPCameraController creates an ICPBatch containing captured documents and images.
    */
    lazy var cameraControllerCompletion:ICPCameraControllerCompletionBlock = { [weak self] (controller, batch, batchType) -> Void in
        guard let sself = self else {
            return
        }
        sself.batch = batch
        sself.tableView?.reloadData()
        sself.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showCameraController() {
        cameraController.reloadWithBatch(batch, andBatchType: batchType)
        self.presentViewController(cameraController, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func addDocument(_ sender: AnyObject) {
        guard let type = batch?.type as? ICPBatchType else {
            return
        }
        
        let objects:[(String, ICPDocumentType)] = type.documentTypes.flatMap {
            let name = $0.typeId
            return (name, $0)
        }
        
        let selection = IBMSelectionTableViewController(itens: objects, selectionTitle: "Documents") { [weak self] (document) -> Void in
            guard let sself = self else {
                return
            }
            sself.capture.objectFactory?.documentWithBatch(sself.batch, type: document)
            sself.dismissViewControllerAnimated(true, completion: { () -> Void in
                self?.tableView.reloadData()
                self?.showCameraController()
            })
        }
        let navigationController = UINavigationController(rootViewController: selection)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func showError(_ error:NSError?) {
        guard let error = error else {
            return
        }
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Batch upload
    
    /**
     10. Submitting a batch is simple.
     During upload, the ICPDatacapServiceClient provides progress information which can show to the app user.
     */
    @IBAction func submitBatch(_ sender: UIBarButtonItem) {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.mode = .determinateHorizontalBar
        
        sessionManager.uploadBatch(batch, withProgressBlock: uploadBatchProgress(), andCompletion: uploadBatchCompletion(sender))
    }
    
    func uploadBatchProgress() -> ICPSessionManagerUpdateProgess {
        return { [weak self] (progress, object) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.hud?.labelText = object is ICPPage ? "Uploading page" : "Finishing"
                self?.hud?.progress = progress
            })
        }
    }
    
    func uploadBatchCompletion(_ sender:UIBarButtonItem) -> ICPSessionManagerUploadCompletion {
        sender.enabled = false
        return { [weak self] (success, result, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.hud?.hide(true)
                sender.enabled = true
                
                if let error = error {
                    self?.showError(error)
                } else {
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let documentTableViewController = segue.destination as? IBMDocumentTableViewController , segue.identifier == IBMBatchToDocumentSegue {
            
            guard let indexPath = self.tableView.indexPathForSelectedRow, let document = batch?.documents[indexPath.row] else {
                return
            }
            
            cameraController.reloadWithBatch(batch, andBatchType: batchType)
            documentTableViewController.cameraController = cameraController
            documentTableViewController.document = document
            documentTableViewController.objectFactory = capture.objectFactory
        }
    }
}
