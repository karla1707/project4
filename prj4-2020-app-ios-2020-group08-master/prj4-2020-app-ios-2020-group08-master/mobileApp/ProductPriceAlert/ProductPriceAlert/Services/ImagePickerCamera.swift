//
//  ImagePickerCamera.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 04.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

/*
 Takes care of the image picking for the camera
 */

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @Binding var image: UIImage
    @Binding var isShown: Bool

    var sourceType: UIImagePickerController.SourceType = .camera
    
    init(image: Binding<UIImage>, isShown: Binding<Bool>){
        _image = image
        _isShown = isShown
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiImage
            isShown = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct ImagePicker: UIViewControllerRepresentable{
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    @Binding var image: UIImage
    @Binding var isShown:Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    } 
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image,isShown:$isShown)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}
