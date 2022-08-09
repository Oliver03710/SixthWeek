//
//  EndPoint.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/08.
//

import Foundation

enum EndPoint {
    case blog
    case cafe
    
    // 저장 프로퍼티를 못 쓰는 이유?
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
}
