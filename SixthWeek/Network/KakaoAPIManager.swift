//
//  KakaoAPIManager.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    private init() { }
    
    static let shared = KakaoAPIManager()
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    // Alarmofire + SwiftyJSON
    // 검색키워드
    // 인증키
    func callRequest(type: EndPoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        print(#function)
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.requestURL + query
        
        //Alarmofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
}
