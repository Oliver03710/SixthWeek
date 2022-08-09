//
//  ClosureViewController.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var cardView: CardView!
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cardView.posterImageView.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
    }
    
    
    // MARK: - Selectors
    
    @objc func likeButtonClicked() {
        print("버튼 클릭")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커를 띄우겠습니까?", message: nil, okTitle: "띄우기") {
            let picker = UIColorPickerViewController()
            self.present(picker, animated: true)
        }
    }
    
    
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        showAlert(title: "배경색 변경", message: "배경색을 바꾸시겠습니까?", okTitle: "바꾸기") {
            self.view.backgroundColor = .gray
        }
    }
    
}



extension UIViewController {
    
    func showAlert(title: String, message: String?, okTitle: String, okAction: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let okay = UIAlertAction(title: okTitle, style: .default) { action in
            okAction()
        }
        
        alert.addAction(cancel)
        alert.addAction(okay)
        
        present(alert, animated: true)
        
    }
}
