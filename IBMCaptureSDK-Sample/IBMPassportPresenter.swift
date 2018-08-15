//
//  IBMPassportTable.swift
//  IBMCaptureSDK-Sample
//
//  Created on 07/04/2016.
//  Copyright © 2016 Future Workshops. All rights reserved.
//

import Foundation
import IBMCaptureSDK

enum FirstRowData:Int {
    case type = 0,
    subType,
    countryCode,
    givenName,
    surname,
    count
}

enum SecondRowData:Int {
    case number = 0,
    nationality,
    birthdate,
    sex,
    expiration,
    personalId,
    count
}

protocol IBMPassportPresenter {
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath:IndexPath, withData data: ICPMRZData?) -> UITableViewCell
}

extension IBMPassportPresenter {
    
    typealias FieldDisplay = (value:String, checked:Bool)
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func titleForSection(_ section:Int) -> String {
        return (section == 0 ? "Top Line" : "Bottom Line")
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return (section == 0 ? FirstRowData.count.rawValue : SecondRowData.count.rawValue)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath:IndexPath, withData data: ICPMRZData?) -> UITableViewCell {
        let identifier = String(describing: type(of: self))
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            return configCell(cell, forRowAtIndexPath: indexPath, withData: data)
        }
        
        return configCell(cell, forRowAtIndexPath: indexPath, withData: data)
    }
    
    func configCell(_ cell: UITableViewCell, forRowAtIndexPath indexPath:IndexPath, withData data: ICPMRZData?) -> UITableViewCell {
        
        cell.textLabel?.text = titleForFieldAtIndex(indexPath)
        
        guard let data = data else {
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .none
            return cell
        }
        
        let field:FieldDisplay?
        if (indexPath as NSIndexPath).section == 0 {
            field = firstRowFieldAtIndex(indexPath.row, onData: data)
        } else {
            field = secondRowFieldAtIndex(indexPath.row, onData: data)
        }
        
        cell.detailTextLabel?.text = field?.value
        cell.accessoryType = (field?.checked == true ? .checkmark : .none)
        
        return cell
    }
    
    func titleForFieldAtIndex(_ indexPath:IndexPath) -> String {
        
        if let rowData = FirstRowData(rawValue: (indexPath as NSIndexPath).row) , (indexPath as NSIndexPath).section == 0 {
            switch rowData {
            case .type:
                return "Type"
            case .subType:
                return "SubType"
            case .countryCode:
                return "Country code"
            case .givenName:
                return "Given Name"
            case .surname:
                return "Surname"
            case .count:
                return ""
            }
        }
        
        if let rowData = SecondRowData(rawValue: (indexPath as NSIndexPath).row) , (indexPath as NSIndexPath).section == 1 {
            switch rowData {
            case .number:
                return "Passport Number"
            case .nationality:
                return "Nationality"
            case .birthdate:
                return "Birthdate"
            case .sex:
                return "Sex"
            case .expiration:
                return "Expiration"
            case .personalId:
                return "Personal ID"
            case .count:
                return ""
            }
        }
        
        return ""
    }
    
    func firstRowFieldAtIndex(_ index:Int, onData data:ICPMRZData) -> FieldDisplay? {
        guard let rowData = FirstRowData(rawValue: index) else {
            return nil
        }
        
        switch rowData {
        case .type:
            return (data.type.value, data.type.checked)
        case .subType:
            return (data.subType.value, data.type.checked)
        case .countryCode:
            return (data.countryCode.value, data.type.checked)
        case .givenName:
            return (data.givenName.value, data.type.checked)
        case .surname:
            return (data.surname.value, data.type.checked)
        case .count:
            return nil
        }
    }
    
    func secondRowFieldAtIndex(_ index:Int, onData data:ICPMRZData) -> FieldDisplay? {
        guard let rowData = SecondRowData(rawValue: index) else {
            return nil
        }
        
        switch rowData {
        case .number:
            return (data.passportNumber.value, data.passportNumber.checked)
        case .nationality:
            return (data.nationality.value, data.nationality.checked)
        case .birthdate:
            return tupleForDate(data.birthdate)
        case .sex:
            return (data.sex.value, data.sex.checked)
        case .expiration:
            return tupleForDate(data.passportExpirationDate)
        case .personalId:
            return (data.personalId.value, data.personalId.checked)
        case .count:
            return nil
        }
    }
    
    func tupleForDate(_ input:ICPMRZField) -> FieldDisplay? {
        guard let date = input.valueAsDate() else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return (dateFormatter.stringFromDate(date), input.checked)
    }
}
