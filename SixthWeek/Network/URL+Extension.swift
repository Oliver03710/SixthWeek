//
//  URL+Extension.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/08.
//

import Foundation

extension URL {
    
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return baseURL + endPoint
    }
    
}
