//
//  PExecutable.swift
//  Swift-SOAP-with-Alamofire
//
//  Created by Victor Gelmutdinov on 03/11/2016.
//  Copyright © 2016 biz.blastar. All rights reserved.
//

import Foundation
protocol PExecutable {
    associatedtype TResponse
    func Execute(onSuccess : (TResponse -> Void),onError : (UPNPError->Void)) ;
}
class UPNPError {
    var Message : String!
    var XML : String!
    var ErrType : ErrorType!
    convenience init(message : String,xml : String!,err :  ErrorType) {
        self.init()
        Message = message
        XML = xml
        ErrType = err
        
    }
}
