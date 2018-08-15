//
//  ViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit



class IBMLoginController: UITableViewController,  UITextFieldDelegate {

    enum IBMLoginControllerSection : Int {
        case address = 0, user, password, stationId
    }
    
    let IBMLoginToConfigSegueIdentifier = "IBMLoginToConfigSegueIdentifier"
    let IBMTextFieldCellID = "IBMTextFieldCell"
    
    var demo : IBMDemo?
    var baseURL = "http://ecm1.fws.io:8070/ServicewTM.svc"
    var username = "admin"
    var password = "admin"
    var stationId = "1"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? IBMServiceConfigurationController , segue.identifier == IBMLoginToConfigSegueIdentifier{
            
            // 2. In order to access a remote service we ask the user to enter a URL and credentials.
            //    Credentials are managed by the NSURLCredential class.
            //    Please see IBMServiceConfigurationController.m next.
            
            controller.baseURL =     URL(string: self.baseURL)
            controller.credential =  URLCredential(user: self.username, password: self.password, persistence: .none)
            controller.stationId = self.stationId
            controller.demo = self.demo
        }
    }
    
    //MARK: UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = IBMLoginControllerSection(rawValue: section)!
        switch section{
        case .address: return "URL Address"
        case .user: return "Username"
        case .password: return "Password"
        case .stationId: return "Station Id"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IBMTextFieldCellID, for: indexPath) as! IBMTextFieldCell
        cell.textField.tag = (indexPath as NSIndexPath).section
        cell.textField.isSecureTextEntry = false
        cell.textField.keyboardType = .default
        
        let section = IBMLoginControllerSection(rawValue: (indexPath as NSIndexPath).section)!
        
        switch section{
        case .address:
            cell.textField.text = self.baseURL
            cell.textField.keyboardType = .URL;
        case .user:
            cell.textField.text = self.username;
        case .password:
            cell.textField.text = self.password
            cell.textField.isSecureTextEntry = true
        case .stationId:
            cell.textField.text = self.stationId
        }
        
        return cell
    
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldValue = textField.text else {
            return true
        }
        
        let newString = (textFieldValue as NSString).replacingCharacters(in: range, with: string)
        
        let section = IBMLoginControllerSection(rawValue: textField.tag)!
        
        switch section{
        case .address: self.baseURL = newString
        case .user: self.username = newString
        case .password: self.password = newString
        case .stationId: self.stationId =  newString.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        return true
    }

}

