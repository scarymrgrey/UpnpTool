//
//  ViewController.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Krzysztof Deneka on 04.08.2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash
import StringExtensionHTML
import AEXML
import CocoaAsyncSocket
import Fuzi

class ViewController: UITableViewController {
    var routers : [GetRoutersList.Response] = []
    var buttonToSourceUrl = [UIButton:String]()
    var tappedButton : UIButton!
    var routeListQuery = GetRoutersList()
    @IBOutlet var Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        routeListQuery.Execute({ resp in
            if(!self.routers.contains{innerresp in
                return innerresp.DocumentUrl == resp.DocumentUrl
                }){
                self.routers.append(resp)
                self.Table.reloadData()
                self.dismissViewControllerAnimated(false, completion: nil)
            }
            
            }, onError: { e in
                print(e)
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routers.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell1", forIndexPath: indexPath) as! TableCell
        cell.IPLabel.text = routers[indexPath.row].RouterIp
        cell.DescLabel.text = routers[indexPath.row].RouterDescription
        buttonToSourceUrl[cell.ChooseButton] = routers[indexPath.row].DocumentUrl
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addrulesegue"{
            let destContr = segue.destinationViewController as! AddRuleController
            destContr.SourceUrl = buttonToSourceUrl[tappedButton]
        }
    }
    @IBAction func ChooseButtonTapped(sender: UIButton) {
        tappedButton = sender
    }
  
    
}

