//
//  CookiesManager.swift
//  Travolution
//
//  Created by Hemant Singh on 04/07/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import Foundation
import UIKit
import Result
import Moya
import RxSwift

public final class LoaderPlugin: PluginType {
    
    /// Called by the provider as soon as the request is about to start
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        return result
    }
    
    /// Called by the provider as soon as a response arrives
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
    }
}
