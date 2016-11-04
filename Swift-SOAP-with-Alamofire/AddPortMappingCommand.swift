//
//  GetCountriesQuery.swift
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
import CocoaAsyncSocket
import Fuzi
class AddPortMappingCommand : PExecutable{
    var Url : NSURL!
    var SoapAction  : String!
    var NewRemoteHost : String!
    var NewExternalPort : String!
    var NewProtocol : String!
    var NewInternalPort : String!
    var NewInternalClient : String!
    var NewEnabled : String!
    var NewPortMappingDescription : String!
    var NewLeasureDuration : String!
    
    func Execute(onSuccess : (Void ->Void),onError : (UPNPError -> Void)) {
        let soapRequest = AEXMLDocument()
        let envelopeAttributes = ["xmlns:SOAP-ENV" : "http://schemas.xmlsoap.org/soap/envelope/"]
        let envelope = soapRequest.addChild(name: "SOAP-ENV:Envelope", attributes: envelopeAttributes)
        let body = envelope.addChild(name: "SOAP-ENV:Body")
        let bodyNode = body.addChild(name: "ns1:AddPortMapping",attributes: ["xmlns:ns1":SoapAction])
        bodyNode.addChild(name: "NewRemoteHost",value: NewRemoteHost)
        bodyNode.addChild(name: "NewExternalPort",value: NewExternalPort)
        bodyNode.addChild(name: "NewProtocol",value: NewProtocol)
        bodyNode.addChild(name: "NewInternalPort",value: NewInternalPort)
        bodyNode.addChild(name: "NewInternalClient",value: NewInternalClient)
        bodyNode.addChild(name: "NewEnabled",value: NewEnabled)
        bodyNode.addChild(name: "NewPortMappingDescription",value: NewPortMappingDescription)
        bodyNode.addChild(name: "NewLeasureDuration",value: NewLeasureDuration)
        let soapLenth = String(soapRequest.xmlString.characters.count)
        
        let mutableR = NSMutableURLRequest(URL: Url!)
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("\(SoapAction)#AddPortMapping", forHTTPHeaderField: "SOAPAction")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.HTTPMethod = "POST"
        mutableR.HTTPBody = soapRequest.xmlString.dataUsingEncoding(NSUTF8StringEncoding)
        print(mutableR)
        Alamofire.request(mutableR)
            .responseString { response in
                if let xmlString = response.result.value {
                    do {
                        let doc = try XMLDocument(string: xmlString)
                        onSuccess()
                    }catch let err{
                        let upnpError = UPNPError()
                        upnpError.ErrType = err
                        upnpError.Message = "Error parsing AddPortMappingResponse from XML"
                        upnpError.XML = xmlString
                        onError(upnpError)
                    }
                }else{
                    print("error fetching XML")
                    onError(UPNPError(message: "error fetching XML",xml: "",err: UpnpError.RuntimeError))
                }
        }
    }
}
