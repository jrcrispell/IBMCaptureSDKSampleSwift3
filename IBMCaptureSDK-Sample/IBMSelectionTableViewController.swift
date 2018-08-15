//
//  IBMSelectionTableViewController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit

class IBMSelectionTableViewController<T>: UITableViewController {

    let IBMSelectionCellIdentifier = "IBMSelectionCellIdentifier"
    
    let itens:[(String,T)]
    let selectionTitle:String
    let completion:((T)->Void)?
    
    init(itens:[(String,T)], selectionTitle:String, completion:((T)->Void)?) {
        self.itens = itens
        self.selectionTitle = selectionTitle
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.itens = []
        self.selectionTitle = ""
        self.completion = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.selectionTitle
        self.navigationItem.title = self.selectionTitle
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: IBMSelectionCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: IBMSelectionCellIdentifier)
        }
        
        let object = self.itens[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = object.0
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let completion = completion else {
            return
        }
        completion(itens[(indexPath as NSIndexPath).row].1)
    }
}
