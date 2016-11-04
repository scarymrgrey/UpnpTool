//
//  GetXMLByAddressQuery.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Victor Gelmutdinov on 27/10/2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash
import StringExtensionHTML
import AEXML
import Fuzi

class GetXMLDataByAddressQuery : PExecutable{
    class Response {
        var DestinationURL : NSURL!
        var ControlURL : NSURL!
        var EventSubURL : NSURL!
        var SoapAction : String!
    }
    var xmlNSUrl : NSURL!
    func Execute(onSuccess : (Response->Void), onError :(UPNPError -> Void) ) {
         Alamofire.request(.GET, xmlNSUrl.absoluteString!, parameters: nil)
            .response {  (request, response, data, error) in
                let dataAsString = String(data: data!,encoding:NSUTF8StringEncoding)!
                do{
                    let dataAsString = String(data: data!,encoding:NSUTF8StringEncoding)!
                    let fuziDoc = try XMLDocument(string: dataAsString,encoding: NSUTF8StringEncoding)
                    let el = fuziDoc.xpath("//*[text()[contains(.,'WANIPConnection')]]").first
                    if let file = el?.parent!.children(tag: "SCPDURL") {
                        let destinationXmlFileName = file.first!.stringValue
                        let hostAndPort = "\(self.xmlNSUrl.host!):\(self.xmlNSUrl.port!)"
                        let destinationXmlUrl = NSURL(scheme: self.xmlNSUrl.scheme!, host: hostAndPort, path: destinationXmlFileName)
                        let controlURL = el!.parent!.children(tag: "controlURL").first!.stringValue
                        let eventSubURL = el!.parent!.children(tag: "eventSubURL").first!.stringValue
                        let res = GetXMLDataByAddressQuery.Response()
                        res.DestinationURL = destinationXmlUrl
                        res.ControlURL = NSURL(scheme: self.xmlNSUrl.scheme!, host: hostAndPort, path: controlURL)
                        res.EventSubURL = NSURL(scheme: self.xmlNSUrl.scheme!, host: hostAndPort, path: eventSubURL)
                        res.SoapAction = el!.stringValue
                        onSuccess(res)
                    }
                }catch let err{
                    let e = UPNPError(message: "error parsing XML", xml: dataAsString, err: err)
                    onError(e)
                }
        }
    }
}

