//
//  FaceDetectionUtil.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import Foundation
import Vision
import UIKit


struct FaceDetectionUtil {
    static func detectFace(image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let faceCropSize = CGSize(width: 224, height: 224)
        
        // Create a request to detect faces
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print("Face detection error: \(error)")
                completion(nil)
                return
            }
            
            guard let results = request.results as? [VNFaceObservation], let face = results.first else {
                print("No face found in the image.")
                completion(nil)
                return
            }
            
            // Calculate the crop rectangle based on the detected face
            let boundingBox = face.boundingBox
            let imageSize = CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
            let faceRect = VNImageRectForNormalizedRect(boundingBox, Int(imageSize.width), Int(imageSize.height))
            
            // Perform the actual cropping
            if let croppedImage = cgImage.cropping(to: faceRect) {
                // Create a new UIImage with the cropped CGImage
                let resizedImage = UIImage(cgImage: croppedImage).resize(to: faceCropSize)
                // Return the cropped and resized image
                // You may want to further process or handle the image as per your requirements
                completion(resizedImage)
            } else {
                completion(nil)
            }
        }
        
        // Create a Vision request handler and perform face detection
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Face detection request failed: \(error)")
            completion(nil)
        }
    }

}
