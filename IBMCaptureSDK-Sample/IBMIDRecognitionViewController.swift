//
//  IBMIDRecognitionViewController.swift
//  IBMCaptureSDK-Sample
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMIDRecognitionViewController: UIViewController, IBMPassportPresenter {

    var data:ICPMRZData?
    
    //1 - For the id processing, we gonna use and tesseract OCR engine with a trained data specific for the passport font type
    lazy var ocrEngine = ICPTesseractOcrEngine(tessDataPrefixes: ["mrz"], andTessdataAbsolutePath: Bundle.main.bundlePath)
    lazy var idProcessor:ICPIDProcessor = { [unowned self] in
       return ICPIDProcessor(OCREngine: self.ocrEngine)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "us_passport")
        let action = UIBarButtonItem(title: "Recognize", style: .plain, target: self, action: #selector(IBMIDRecognitionViewController.recognizeId(_:)))
        self.navigationItem.rightBarButtonItem = action
    }
    
    func recognizeId(_ sender:UIBarButtonItem) {
        guard let image = imageView.image else {
            data = nil
            tableView?.reloadData()
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        
        idProcessor.processPassportImage(image) { [weak self] (mrzString, mrzData) in
            hud.hide(true)
            self?.data = mrzData
            self?.tableView?.reloadData()
        }
    }
}

extension IBMIDRecognitionViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension IBMIDRecognitionViewController : UITableViewDataSource {
    
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
