		//
//  AddRuleController.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Victor Gelmutdinov on 03/11/2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import Foundation
import UIKit
class AddRuleController: UIViewController {
    var SourceUrl : String!
    
    @IBOutlet weak var NewRemoteHost: UITextField!
    
    @IBOutlet weak var NewExternalPort: UITextField!
    
    @IBOutlet weak var NewProtocol: UITextField!
    
    @IBOutlet weak var NewInternalPort: UITextField!
    
    @IBOutlet weak var NewInternalClient: UITextField!
    
    @IBOutlet weak var NewEnabled: UITextField!
    
    @IBOutlet weak var NewPortMapping: UITextField!
    
    @IBOutlet weak var NewLeasureDuration: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func showInfoAlert(title : String,message : String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func AddRuleButtonTapped(sender: AnyObject) {
        // MARK: SSDP
        let xmlQuery = GetXMLDataByAddressQuery()
        let xmlNSUrl = NSURL(string: SourceUrl)!
        
        xmlQuery.xmlNSUrl = xmlNSUrl
        xmlQuery.Execute({ (response) in
            let addPortMappingCommand = AddPortMappingCommand()
            addPortMappingCommand.Url = response.ControlURL
            addPortMappingCommand.SoapAction = response.SoapAction
            addPortMappingCommand.NewRemoteHost = self.NewRemoteHost.text
            addPortMappingCommand.NewExternalPort = self.NewExternalPort.text
            addPortMappingCommand.NewProtocol = self.NewProtocol.text
            addPortMappingCommand.NewInternalPort = self.NewInternalPort.text
            addPortMappingCommand.NewInternalClient = self.NewInternalClient.text
            addPortMappingCommand.NewEnabled = self.NewEnabled.text
            addPortMappingCommand.NewPortMappingDescription = self.NewPortMapping.text
            addPortMappingCommand.NewLeasureDuration = self.NewLeasureDuration.text
            addPortMappingCommand.Execute({
                self.showInfoAlert("Rule added", message: "Rule added to mapping")
                }, onError: { (e) in
                    self.showInfoAlert(e.Message, message: String(e.ErrType))
            })
            }, onError: { (e) in
                self.showInfoAlert(e.Message, message: String(e.ErrType))
        })
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
