//
//  ViewController.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/08.
//

import UIKit

import SwiftyJSON

/*
 1. html tag <> </> 기능 활용
 2. 문자열을 대체 메서드
 * response에서 처리하는 것과 보여지는 셀 등에서 처리하는 것의 차이
 */

/*
 TableView automaticDimension
  - 컨텐츠 양에 따라서 셀 높이가 자유롭게
  - 조건: 레이블 NumberOfLines 0
  - 조건: tableView Height AutomaticDimension
  - 조건: 오토레이아웃
 */

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false  // false: 두줄 / true: 0줄
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        searchBlog()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension    // 모든 섹션의 셀에 대해서 유동적!
    }
    
    
    // MARK: - Network
    
    func searchBlog() {
        
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
            print(json)
            
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue)
            }
            
            // 테이블 뷰 갱신 Or APIManager 호출
            self.searchCafe()
            
        }
    }
    
    func searchCafe() {
        
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            
            print(json)

            json["documents"].arrayValue.forEach { self.cafeList.append($0["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")) }

            print(self.blogList)
            print(self.cafeList)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
        tableView.reloadData()
    }
}


// MARK: - Extension: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   // 조건문 처리하여 특정 셀에서만 유동적으로 처리
    }
    
}

class kakaoCell: UITableViewCell {
  
    @IBOutlet weak var testLabel: UILabel!
    
}


