//
//  MyProvider.swift
//  Travolution
//
//  Created by Hemant Singh on 02/08/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

