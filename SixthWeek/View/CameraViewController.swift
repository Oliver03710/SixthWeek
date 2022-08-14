//
//  CameraViewController.swift
//  SixthWeek
//
//  Created by Junhee Yoon on 2022/08/12.
//

import UIKit
import PhotosUI

import Alamofire
import SwiftyJSON
import YPImagePicker

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var phPickerButton: UIButton!
    
    // UIImagePickerController 1.
    let picker = UIImagePickerController()
    
    var itemPrividers: [NSItemProvider] = []
    var iterator: IndexingIterator<[NSItemProvider]>?
    
    private var itemQuantityDescription: String? {
        didSet {
            phPickerButton.setNeedsUpdateConfiguration()
        }
    }
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImagePickerController 2.
        picker.delegate = self
        
        configureButtons()
    }
    
    
    // MARK: - Helper Functions
    
    func displayNextImage() {
        if let itemProvider = iterator?.next(), itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = resultImageView.image
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    
                    guard let self = self, let image = image as? UIImage, self.resultImageView.image == previousImage else { return }
                    self.resultImageView.image = image
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayNextImage()
    }
    
    func configureButtons() {
        
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "PHPicker Button With Configuration"
        configuration.subtitle = "Subtitles"
//        configuration.showsActivityIndicator = true
//        configuration.image = UIImage(systemName: "star.fill")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 20
        
        phPickerButton.configuration = configuration
        
        phPickerButton.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.image = button.isHighlighted ? UIImage(systemName: "cart.fill.badge.plus") : UIImage(systemName: "cart.badge.plus")
            button.configuration = config
            
        }
        
//        phPickerButton.configurationUpdateHandler = {
//
//            [unowned self] button in
//
//            var config = button.configuration
//            config?.image = button.isHighlighted ? UIImage(systemName: "cart.fill.badge.plus") : UIImage(systemName: "cart.badge.plus")
//            config?.subtitle = self.itemQuantityDescription
//            button.configuration = config
//
            
        
    }
    
    
    // MARK: - IBActions
    
    //OpenSource
    @IBAction func YPImagePickerButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    //UIImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트 / 얼럿")
            return }
        
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
    }
    
    //UIImagePickerController
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 사용자에게 토스트 / 얼럿")
            return }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        present(picker, animated: true)
        
    }

    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    }
    
    // 이미지뷰 이미지 -> 네이버 -> 얼굴 분석 요청 -> 응답
    // 문자열이 아닌 파일, 이미지, PDF 파일 자체가 그대로 전송 되지 않음 -> 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서어베게 전달이 되는 지 명시 = Content-Type
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "Le0T6RdwB7YZnztbsZwC",
            "X-Naver-Client-Secret": "e1t4dUIBrc"
//            "Content-Type": "multipart/form-data" -> 안써도 된다. 라이브러리에 내장이 되어 있음
        ]
        
        // UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달
        guard let imageData = resultImageView.image?.jpegData(compressionQuality: 0.3) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func PHPickerButtonTapped(_ sender: Any) {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        
        let phPicker = PHPickerViewController(configuration: configuration)
        phPicker.delegate = self
        present(phPicker, animated: true)
        
    }
}


// MARK: - Extension: UIImagePickerControllerDelegate

// UINavigationController를 상속받고 있음 3.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController 4. 사진이나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        // 원본, 편집, 메타 데이터 등 - infoKey
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
    }
    
    // UIImagePickerController 5. 취소 버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }

}


// MARK: - Extension: PHPickerViewControllerDelegate
extension CameraViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
//        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//
//            let previousImage = resultImageView.image
//            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
//                    guard let self = self, let image = image as? UIImage, self.resultImageView.image == previousImage else { return }
//                    self.resultImageView.image = image
//                }
//            }
//        }
        
        itemPrividers = results.map(\.itemProvider)
        iterator = itemPrividers.makeIterator()
        displayNextImage()
    }
    
    
    
}


