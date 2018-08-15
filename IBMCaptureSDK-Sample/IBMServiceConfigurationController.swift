//
//  IBMServiceConfigurationController.swift
//  IBMCaptureSDK-Sample-Swift
//
//  Copyright (c) 2016 IBM Corporation. All rights reserved.
//

import UIKit
import IBMCaptureSDK

class IBMServiceConfigurationController: UITableViewController {
    
    enum IBMServiceConfigurationSection : Int {
        case application = 0, workflow, job, dco, count
    }
    
    let IBMServiceToBatchSegue = "IBMServiceToBatchSegue"
    let IBMServiceCellIdentifier = "IBMServiceCell"
    let IBMServiceToCheckProcessing = "IBMServiceToCheckProcessing"
    let IBMServiceToRecognizePageFields = "IBMServiceToRecognizePageFields"
    
    //MARK: Login configuration
    var demo : IBMDemo?
    var credential : URLCredential!
    var baseURL : URL!
    var stationId : String!
    
    var batchType:ICPBatchType? = nil
    
    //MARK: IBMCapture communication objects
    
    /**
        3. The main entry point to the `IBMCapture` library is the `ICPCapture` object.
        Here it is configured to manage transient (i.e. non persistent) objects.
        The responsibility to manage these objects is owned by the `ICPObjectFactory`, accessed
        via the `ICPCapture.objectFactory` method.
    */
    lazy var capture:ICPCapture = {
        return ICPCapture.instanceWithObjectFactoryType(.NonPersistent)!
    }()
    
    /**
        4. The ICPDatacapHelper object is used to connect to an IBM Datacap server and retrieve
        miscellaneous information such as avalible applications, workflows and DCO objects.
    */
    lazy var datacapHelper:ICPDatacapHelper = { [unowned self] in
        let datacapHelper = ICPDatacapHelper(datacapService: self.service, objectFactory: self.capture.objectFactory!, credential: self.credential)
        return datacapHelper
    }()
    
    /**
        5. The ICPDatacapService object is managed by the ICPObjectFactory. It is responsible to store
        information object the connection to an IBM Datacap application, for example URL, application, workflow settings. 
    */
    lazy var service:ICPDatacapService = { [unowned self] in
        let service = (self.capture.objectFactory?.datacapServiceWithBaseURL(self.baseURL!))!
        service.allowInvalidCertificates = true
        return service
    }()
    
    /**
        6. The ICPSessionManager has the responsibility to connect to an IBM Datacap server application
        and perform methods such as retrieving profiles and uploading batches.
     */
    lazy var sessionManager:ICPSessionManager = { [unowned self] in
        if let sessionManager = self.capture.datacapSessionManagerForService(self.service, withCredential: self.credential) {
            return sessionManager
        }
        let sessionManager = ICPSessionManager(objectFactory: self.capture.objectFactory!, service: self.service, andCredentials: self.credential)
        return sessionManager
    }()
    
    //MARK: View configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        self.service.station = self.capture.objectFactory?.stationWithStationId(withStationId: self.stationId, andIndex: 0, andDescription: "")
        self.service.application = self.capture.objectFactory?.application(withName: "CarLoan")
        self.service.workflow = self.capture.objectFactory?.workflow(withWorkflowId: "CarLoan", andIndex: 2)
        self.service.job = self.capture.objectFactory?.job(withJobId: "Mobile Job", andIndex: 16)
        self.service.setupDCO = self.capture.objectFactory?.setupDCO(withName: "CarLoan")
    }
    
    //MARK: Table view configuration
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return IBMServiceConfigurationSection.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForSection(section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IBMServiceCellIdentifier, for: indexPath)
        
        guard let section = IBMServiceConfigurationSection(rawValue: (indexPath as NSIndexPath).section) else {
            cell.textLabel?.text = nil
            return cell
        }
        
        switch section {
        case .application:
            cell.textLabel?.text = service.application?.name ?? ""
            break
        case .workflow:
            cell.textLabel?.text = service.workflow?.workflowId ?? ""
            break
        case .job:
            cell.textLabel?.text = service.job?.jobId ?? ""
            break
        case .dco:
            cell.textLabel?.text = service.setupDCO?.name ?? ""
            break
        case .count:
            cell.textLabel?.text = nil
            break
        }
        
        cell.textLabel?.alpha = (cell.textLabel?.text == nil ? 0.3 : 1.0);
        cell.textLabel?.text = cell.textLabel?.text ?? "Please complete";
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = IBMServiceConfigurationSection(rawValue: (indexPath as NSIndexPath).section) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        switch section {
        case .application:
            getApplicationAndGoToSelection()
        case .workflow:
            getWorkflowAndGoToSelection()
        case .job:
            getJobAndGoToSelection()
        case .dco:
            getDCOAndGoToSelection()
        case .count:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func titleForSection(_ section:Int) -> String {
        guard let sectionType = IBMServiceConfigurationSection(rawValue: section) else {
            return ""
        }
        
        switch sectionType {
        case .application: return "Application"
        case .workflow: return "Workflow"
        case .job: return "Job"
        case .dco: return "DCO"
        default: return ""
        }
    }
    
    // MARK: Actions
    
    /** 
        8. After configuration has been setup, the service client can be used to connect to the IBM Datacap application
        in order to retrieve profile information.
    
        Downloading profile information retrieves the setup DCO from the application, and parses it into an object model
        containing the various types needed to create a batch of documents for upload.
    */
    @IBAction func connect(_ sender: AnyObject) {
        guard let _ = service.application,
            let _ = service.workflow,
            let _ = service.job,
            let _ = service.setupDCO else {
                showInvalidInformation()
                return
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        
        self.sessionManager.downloadBatchType(self.withSetup: service.setupDCO!) { [weak self] (success, batchType, error) -> Void in
            hud?.hide(true)
            guard let sself = self, let batchType = batchType , error == nil else {
                self?.showError(error! as NSError?)
                return
            }
            sself.batchType = batchType
            
            if self?.demo == .CheckProcessing{
                sself.performSegue(withIdentifier: sself.IBMServiceToCheckProcessing, sender: sself)
            }else if(self?.demo == .RecognizePageFields){
                sself.performSegue(withIdentifier: sself.IBMServiceToRecognizePageFields, sender: sself)
            }else{
                sself.performSegue(withIdentifier: sself.IBMServiceToBatchSegue, sender: sself)
            }
        }
    }
    
    func showInvalidInformation() {
        showAlert(title: "Cannot continue", message: "Please complete the service configuration in the right order")
    }
    
    func showError(_ error:NSError?) {
        guard let error = error else {
            return
        }
        
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func showAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let batchViewController = segue.destination as? IBMBatchTableViewController , segue.identifier == IBMServiceToBatchSegue {
            batchViewController.sessionManager = sessionManager
            batchViewController.service = service
            batchViewController.batchType = batchType
            batchViewController.capture = capture
            batchViewController.datacapHelper = datacapHelper
            
        }else if let checkCountrySelectionController = segue.destination as? IBMCheckCountrySelectionController , segue.identifier == IBMServiceToCheckProcessing {
            checkCountrySelectionController.service = service
            checkCountrySelectionController.capture = capture
            checkCountrySelectionController.credential = credential
            checkCountrySelectionController.sessionManager = sessionManager
            checkCountrySelectionController.demo = self.demo

        }else if let pageViewController = segue.destination as? IBMPageViewController , segue.identifier == IBMServiceToRecognizePageFields {
            pageViewController.service = service
            pageViewController.sessionManager = sessionManager
            pageViewController.credential = credential
            pageViewController.demo = self.demo
            
            let fieldType = capture.objectFactory?.fieldTypeWithTypeId("Text")
            
            let page = capture.objectFactory?.pageWithDocument(nil, type: nil)
            let image = UIImage(named: "optional_insurance")
            
            page?.modifiedImage = image
            
            let field = capture.objectFactory?.fieldWithObject(page, type: fieldType!)
            field!.position = ICPRect(origin: ICPPoint(x: 0, y: 0), size: ICPSizeMake(Double.init((image?.size.width)!), Double.init((image?.size.height)!)))
            
            pageViewController.page = page
        }
    }
    
    func goToSelection<T>(_ section:Int, parser:@escaping (T)->(String,T)?, response:@escaping (T)->Void) -> ([T], NSError?) -> Void
    {
        return { [weak self] (result, error) -> Void in

            let indexPath = IndexPath(row: 0, section: section)
            
            guard error == nil else {
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.showError(error)
                return
            }

            let title = self?.titleForSection(section) ?? ""
            
            let objects:[(String, T)] = result.flatMap(parser)
            
            let selection = IBMSelectionTableViewController(itens: objects, selectionTitle: title) { [weak self] (selectedObject) -> Void in
                self?.dismiss(animated: true, completion: nil)
                response(selectedObject)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            let navigationController = UINavigationController(rootViewController: selection)
            self?.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func getApplicationAndGoToSelection() {
        
        let selection = goToSelection(IBMServiceConfigurationSection.application.rawValue, parser: { (object) -> (String, ICPApplication)? in
            let name = object.name
            return (name, object)
        }, response: { [weak self] (selectedObject) -> Void in
            self?.service.application = selectedObject
        })
        
        _getApplications(selection)
    }
    
    func getWorkflowAndGoToSelection() {
        
        let selection = goToSelection(IBMServiceConfigurationSection.workflow.rawValue, parser: { (object) -> (String, ICPWorkflow)? in
            let name = object.workflowId
            return (name, object)
        }, response: { [weak self] (selectedObject) -> Void in
            self?.service.workflow = selectedObject
        })
        
        _getWorkflows(application: service.application!, completion: selection)
    }

    func getJobAndGoToSelection() {
        
        let selection = goToSelection(IBMServiceConfigurationSection.job.rawValue, parser: { (object) -> (String, ICPJob)? in
            let name = object.jobId
            return (name, object)
        }, response: { [weak self] (selectedObject) -> Void in
            self?.service.job = selectedObject
        })
        
        _getJobs(application: service.application!, workflow: service.workflow!, completion: selection)
    }

    func getDCOAndGoToSelection() {
        
        let selection = goToSelection(IBMServiceConfigurationSection.dco.rawValue, parser: { (object) -> (String, ICPSetupDCO)? in
            let name = object.name
            return (name, object)
        }, response: { [weak self] (selectedObject) -> Void in
            self?.service.setupDCO = selectedObject
        })
        
        _getDCOs(application: service.application!, completion: selection)
    }
    
    // MARK: IBMCapture getters
    
    // 7. The following four methods - _getApplications, _getWorkflows, _getJobs
    //    and _getDCOs retrieve information from the Datacap server via the ICPDatacapHelper instance.
    //
    //    A common use of the IBM Datacap Mobile SDK would be to provide these settings in a manner that is invisible to the user
    //    of the product for example, embedding them in the App, or providing them via a remote service.
    
    fileprivate func _getApplications(_ completion:([ICPApplication], NSError?) -> Void) {
        datacapHelper.getApplicationListWithCompletionBlock { (sucess, applications, error) -> Void in
            completion(applications ?? [], error)
        }
    }

    fileprivate func _getWorkflows(application:ICPApplication, completion:([ICPWorkflow],NSError?) -> Void) {
        
        datacapHelper.getWorkflowListForApplication(application) { (success, workflows, error) -> Void in
            completion(workflows ?? [], error)
        }
    }
    
    fileprivate func _getJobs(application:ICPApplication, workflow:ICPWorkflow, completion:([ICPJob],NSError?)->Void) {
        
        datacapHelper.getJobListForApplication(application, workflow: workflow) { (success, jobs, error) -> Void in
            completion(jobs ?? [], error)
        }
    }
    
    fileprivate func _getDCOs(application:ICPApplication, completion:([ICPSetupDCO], NSError?) -> Void) {
        
        datacapHelper.getSetupDCOsForApplication(application) { (success, setups, error) -> Void in
            completion(setups ?? [], error)
        }
    }
    
}
