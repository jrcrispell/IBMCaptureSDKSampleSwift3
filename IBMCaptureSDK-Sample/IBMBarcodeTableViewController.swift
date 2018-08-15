//
//  IBMBarcodeTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMBarcodeTableViewController: UITableViewController {

    let IBMBarcodeTableViewCellIdentifier = "IBMBarcodeTableViewCellIdentifier"
    let IBMBarcodeTableViewToBarcodeViewSegue = "IBMBarcodeTableViewToBarcodeViewSegue"
    
    enum IBMBarcodeType:Int, CustomStringConvertible {
        case document = 0,
        several,
        interleaved,
        code39,
        code39Extended,
        code93Extended,
        code93,
        code128,
        ean8,
        ean13,
        upca,
        upce,
        pdf417,
        dataMatrix,
        qrCode,
        aztec,
        count
        
        var description:String {
            switch self {
            case .document: return "Document"
            case .several: return "Different Types"
            case .interleaved: return "Interleaved 2 of 5"
            case .code39: return "Code 39"
            case .code39Extended: return "Code 39 Extended"
            case .code93: return "Code 93"
            case .code93Extended: return "Code 93 Extended"
            case .code128: return "Code 128"
            case .ean8: return "EAN8"
            case .ean13: return "EAN13"
            case .upca: return "UPCA"
            case .upce: return "UPCE"
            case .pdf417: return "PDF 417"
            case .dataMatrix: return "Data Matrix"
            case .qrCode: return "QRCode"
            case .aztec: return "Aztec"
            case .count: return ""
            }
        }
    }
    
    func icpType(_ barcodeType:IBMBarcodeType) -> ICPBarcodeType {
        switch barcodeType {
        case .Count, .Document, .Several: return .None
        case .Interleaved: return .Interleaved2of5
        case .Code39: return .Code39
        case .Code39Extended: return .Code39Extended
        case .Code93: return .Code93
        case .Code93Extended: return .Code93Extended
        case .Code128: return .Code128
        case .Ean8: return .EAN8
        case .Ean13: return .EAN13
        case .Upca: return .UPCA
        case .Upce: return .UPCE
        case .Pdf417: return .PDF417
        case .DataMatrix: return .DataMatrix
        case .QrCode: return .QRCode
        case .Aztec: return .Aztec
        }
    }
    
    func barcodeImage(_ barcodeType:IBMBarcodeType) -> UIImage? {
        
        let imageName:String
        
        switch barcodeType {
        case .count, .document: imageName = "carloan"
        case .several: imageName = "some_barcodes.jpg"
        case .interleaved: imageName = "barcode_itf.jpg"
        case .code39, .code39Extended: imageName = "barcode_code_39.jpg"
        case .code93, .code93Extended: imageName = "barcode_code_93.jpg"
        case .code128: imageName = "barcode_code_128.jpg"
        case .ean8: imageName = "barcode_ean_8.jpg"
        case .ean13: imageName = "barcode_ean_13_sup.jpg"
        case .upca: imageName = "barcode_upc_a.jpg"
        case .upce: imageName = "barcode_upc_e.jpg"
        case .pdf417: imageName = "barcode_ean_pdf_417.jpg"
        case .dataMatrix: imageName = "barcode_data_matrix.jpg"
        case .qrCode: imageName = "barcode_qr_code"
        case .aztec: imageName = "barcode_aztec.jpg"
        }
        
        return UIImage(named: imageName)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IBMBarcodeType.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IBMBarcodeTableViewCellIdentifier", for: indexPath)
        
        guard let type = IBMBarcodeType(rawValue: (indexPath as NSIndexPath).row) else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.textLabel?.text = "\(type)"
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let barcodeController = segue.destination as? IBMBarcodeViewController , segue.identifier == IBMBarcodeTableViewToBarcodeViewSegue {
            guard let indexPath = tableView.indexPathForSelectedRow, let type = IBMBarcodeType(rawValue: (indexPath as NSIndexPath).row) else {
                return
            }
            
            barcodeController.barcodeType = icpType(type)
            barcodeController.barcodeImage = barcodeImage(type)
            barcodeController.title = type.description
        }
    }
    
}
