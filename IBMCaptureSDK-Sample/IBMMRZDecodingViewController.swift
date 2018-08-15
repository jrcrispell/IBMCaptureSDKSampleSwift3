//
//  IBMMRZDecodingViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMMRZDecodingViewController: UIViewController, IBMPassportPresenter {

    let mrzDecoder = ICPMRZDecoder()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mrzText: UITextView!
    var data:ICPMRZData?
    var dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let actionButton = UIBarButtonItem(title: "Perform", style: .plain, target: self, action: #selector(IBMMRZDecodingViewController.performMRZ(_:)))
        self.navigationItem.rightBarButtonItem = actionButton
    }
    
    func performMRZ(_ sender:UIBarButtonItem) {
        
        defer {
            tableView?.reloadData()
        }
        
        mrzText?.resignFirstResponder()
        
        guard let text = mrzText?.text , text.characters.count > 0 else {
            data = nil
            return
        }
        
        //1: The decodeString(_:ofType:withMaxConfidence:) function will parse the provided string into an ICPMRZData object
        data = mrzDecoder.decodeString(text, ofType: .Complete, withMaxConfidence: NSNumber(integer: 1))
    }
}

extension IBMMRZDecodingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension IBMMRZDecodingViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableView(tableView, cellForRowAtIndexPath: indexPath, withData: self.data)
    }
}
