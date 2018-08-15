//
//  IBMDocumentTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureUISDK
import IBMCaptureSDK

class IBMDocumentTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let IBMDocumentCellIdentifier = "IBMDocumentCellIdentifier"
    let IBMDocumentToPageSegue = "IBMDocumentToPageSegue"
    
    var cameraController:ICPCameraController!
    var document:ICPDocument!
    var objectFactory:ICPObjectFactory!

    lazy var imagePickerController:UIImagePickerController = { [unowned self] in
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        return imagePickerController
    }()
    
    // MARK: - Table view configuration

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Pages"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document?.pages.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IBMDocumentCellIdentifier, for: indexPath)
        
        guard let page = document?.pages[indexPath.row] else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = page.type?.typeId ?? ""
        
        return cell
    }
    
    //MARK: - Actions
    @IBAction func addPage(_ sender: AnyObject) {
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        guard let documentType = document.type as? ICPDocumentType,
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        let objects:[(String, ICPPageType)] = documentType.pageTypes.flatMap {
            let name = $0.typeId
            return (name, $0)
        }
        
        let selection = IBMSelectionTableViewController(itens: objects, selectionTitle: "Pages") { [weak self] (pageType) -> Void in
            self?.dismissViewControllerAnimated(animated: true, completion: nil)
            guard let page = self?.objectFactory.page(with: self?.document, type: pageType) else {
                return
            }
            page.originalImage = image
            page.modifiedImage = image
            self?.tableView.reloadData()
        }
        let navigationController = UINavigationController(rootViewController: selection)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageController = segue.destination as? IBMPageViewController , segue.identifier == IBMDocumentToPageSegue {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let page = document.pages[indexPath.row]
            pageController.page = page
        }
    }
}
