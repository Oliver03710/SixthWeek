//
//  CardView.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/09.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class
 2. File's Owner -> 확장성이 높다.
 */

/*
 View:
 - 인터페이스 빌터 UI 초기화 구문: required init?
    - 프로토콜 초기화 구문: required -> 초기화 구문이 프로토콜로 명세되어 있음
 - 코드 UI 초기화 구문: override init
 
 */

protocol A {
    func example()
    init()
}

class CardView: UIView {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
        
        // 카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 true로 나옴
        // 뷰는 위에서 보면 알 수 있듯이, 코드로 추가한 UI이기 때문에 오토리사이징이 내부적으로 처리 됨.
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
}
