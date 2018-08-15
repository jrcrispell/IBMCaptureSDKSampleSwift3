//
//  IBMCheckCountrySelectionController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMCheckCountrySelectionController: UITableViewController {

    let IBMCheckCountryToPageSegueUK = "IBMCheckCountryToPageSegue_UK"
    let IBMCheckCountryToPageSegueUS = "IBMCheckCountryToPageSegue_US"
    
    var service : ICPDatacapService!
    var capture : ICPCapture!
    var sessionManager:ICPSessionManager!
    var credential : URLCredential!
    var demo : IBMDemo?
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let page = capture.objectFactory?.pageWithDocument(nil, type: nil)
        
        
        if let pageViewController = segue.destinationViewController as? IBMPageViewController  {
            
            pageViewController.service = service
            pageViewController.sessionManager = sessionManager
            pageViewController.credential = credential
            pageViewController.demo = self.demo
            
            switch segue.identifier! {
            case IBMCheckCountryToPageSegueUK:
                pageViewController.checkCountry = ICPCheckCountry.UK
                page?.modifiedImage = UIImage(named: "UK_check")
                break
                
            case IBMCheckCountryToPageSegueUS:
                pageViewController.checkCountry = ICPCheckCountry.USA
                page?.modifiedImage = UIImage(named: "US_check")
                
                break
            default:
                break
                
                        }
            
            pageViewController.page = page
            
        }
    }
    
}
