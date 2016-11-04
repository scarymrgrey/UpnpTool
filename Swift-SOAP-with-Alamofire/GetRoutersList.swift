//
//  GetRoutersList.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Victor Gelmutdinov on 03/11/2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
enum UpnpError : ErrorType{
    case RuntimeError
}
class GetRoutersList :PExecutable ,GCDAsyncUdpSocketDelegate{
    
    
    //ssdp stuff
    var ssdpAddres          = "239.255.255.250"
    var ssdpPort:UInt16     = 1900
    var ssdpSocket:GCDAsyncUdpSocket!
    var ssdpSocketRec:GCDAsyncUdpSocket!
    var error : NSError?
    var onSuccess : (Response->Void)!
    var onError : (UPNPError->Void)!
    let mSearchData = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMAN: \"ssdp:discover\"\r\nMX: 3\r\nST:urn:schemas-upnp-org:device:InternetGatewayDevice:1\r\nUSER-AGENT: iOS UPnP/1.1 AddPortMappingApp/1.0\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding) //all devices
    
    
    class Response {
        var DocumentUrl : String!
        var RouterDescription : String!
        var RouterIp : String!
    }
    
    func Execute(onSuccess : (Response->Void),onError : (UPNPError->Void)){
        self.onError = onError
        self.onSuccess = onSuccess
        //send M-Search
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        ssdpSocket.sendData(mSearchData!, toHost: ssdpAddres, port: ssdpPort, withTimeout: 1, tag: 0)
        
        //bind for responses
        do{
            try ssdpSocket.bindToPort(ssdpPort)
            try ssdpSocket.joinMulticastGroup(ssdpAddres)
            try ssdpSocket.beginReceiving()
        }catch let err{
            print(err)
            let upnpError = UPNPError()
            upnpError.ErrType = err
            upnpError.Message  = "ssdpSocket problem"
            onError(upnpError)
        }
    }
    func getComponentFromString(source : String,component : String) -> String? {
        return source.componentsSeparatedByString("\r\n").filter { (s) -> Bool in
            s.localizedCaseInsensitiveContainsString(component)
            }.first
    }
    // MARK: SSDP
    @objc func udpSocket(sock: GCDAsyncUdpSocket, didReceiveData data: NSData, fromAddress address: NSData, withFilterContext filterContext: AnyObject?) {
        var host: NSString?
        var port1: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port1, fromAddress: address)
        print("From \(host!)")
        let gotdata = String(data: data, encoding: NSUTF8StringEncoding)!
        print(gotdata)
      
        if let locationStr = getComponentFromString(gotdata,component: "location") {
            do {
                let devider = locationStr.rangeOfString(":")
                guard devider != nil else {
                    throw UpnpError.RuntimeError
                }
                let xmlUrlString = locationStr.substringFromIndex(devider!.endIndex).stringByReplacingOccurrencesOfString(" ", withString:"")
                let res = Response()
                res.DocumentUrl = xmlUrlString
                res.RouterDescription = getComponentFromString(gotdata,component: "server")
                res.RouterIp = host! as String
                onSuccess(res)
            }catch let err{
                print(err)
                let upnpError = UPNPError()
                upnpError.ErrType = err
                upnpError.Message  = "'Location' parsing problem"
                onError(upnpError)
            }
        }
    }
}
