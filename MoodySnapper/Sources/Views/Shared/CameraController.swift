//
//  CameraController.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 24/05/23.
//

import UIKit
import SwiftUI
import AVFoundation


class CameraController: UIViewController {
    private var permissionGranted = false // Flag for permission
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // For view dimensions
    
    override func viewDidLoad() {
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)

        switch UIDevice.current.orientation {
            // Home button on top
            case UIDeviceOrientation.portraitUpsideDown:
                self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
                     
            // Home button on right
            case UIDeviceOrientation.landscapeLeft:
                self.previewLayer.connection?.videoOrientation = .landscapeRight
                    
            // Home button on left
            case UIDeviceOrientation.landscapeRight:
                self.previewLayer.connection?.videoOrientation = .landscapeLeft
                     
            // Home button at bottom
            case UIDeviceOrientation.portrait:
                self.previewLayer.connection?.videoOrientation = .portrait
                        
            default:
                break
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission has been granted before
        case .authorized:
            permissionGranted = true
            
            // Permission has not been requested yet
        case .notDetermined:
            requestPermission()
            
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        // Access camera
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
                          
        screenRect = UIScreen.main.bounds

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen

        previewLayer.connection?.videoOrientation = .portrait
        
        // Updates to UI must be on main queue
       DispatchQueue.main.async { [weak self] in
           self!.view.layer.addSublayer(self!.previewLayer)
       }
    }
}

struct HostedCameraController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return CameraController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
