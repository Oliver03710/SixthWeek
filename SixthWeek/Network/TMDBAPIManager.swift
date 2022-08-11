//
//  TMDBAPIManager.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    private init() { }
    
    static let shared = TMDBAPIManager()
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"

    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {

        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"

        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData(queue: .global()) { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                var stillArray: [String] = []
                let image = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
                stillArray.append(contentsOf: image) // print vs dump ->
                
                completionHandler(image)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        // 순서보장 X, 2. 언제 끝날 지 모름 3. Limit (ex. 1초에 5번 Block) -> 다음주 해결
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
        
        var posterList: [[String]] = []
        
        // asyne / await (iOS 13 이상) -> 아래처럼 중괄호가 많은 구조를 해결하기 위해
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
