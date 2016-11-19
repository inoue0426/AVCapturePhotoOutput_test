//
//  ViewController.swift
//  AVCapturePhotoOutput_test
//
//  Created by 井上雄貴 on 2016/10/30.
//  Copyright © 2016年 井上雄貴. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    var captureSesssion: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    //    ↑ 書き換え AVCaptureStillImageOutput → AVCapturePhotoOutput
    
    @IBAction func takePhoto(_ sender: Any){
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    //    AVCapturePhotoSettingsという新しいClassがAVCapturePhotoOutputと一緒に追加された。
    //    フラッシュなどの細かい設定はAVCapturePhotoSettingsで行う
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSessionPreset1920x1080
        stillImageOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(stillImageOutput)) {
                    captureSesssion.addOutput(stillImageOutput)
                    captureSesssion.startRunning()
                    let captureVideoLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: captureSesssion)
                    captureVideoLayer.frame = self.imageView.bounds
                    captureVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.imageView.layer.addSublayer(captureVideoLayer)
                }
            }
        }
//        今回は📷のFront、Back、Dualの指定はしていないが、するとしたらこんな感じ
//        do {
//            var defaultVideoDevice: AVCaptureDevice?
//            defaultVideoDevice = dualCameraDevice
//        }
//            else if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
//                defaultVideoDevice = backCameraDevice
//            }
//            else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
//               defaultVideoDevice = frontCameraDevice
//            }
//            
//            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
//            
//            if session.canAddInput(videoDeviceInput) {
//                session.addInput(videoDeviceInput)
//                self.videoDeviceInput = videoDeviceInput
//                
//                DispatchQueue.main.async {
//                    let statusBarOrientation = UIApplication.shared.statusBarOrientation
//                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
//                    if statusBarOrientation != .unknown {
//                        if let videoOrientation = statusBarOrientation.videoOrientation {
//                            initialVideoOrientation = videoOrientation
//                        }
//                    }
//                    
//                    self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation
//                }
//            }
//            else {
//                print("Could not add video device input to the session")
//                setupResult = .configurationFailed
//                session.commitConfiguration()
//                return
//            }
//        }
            
        catch {
            print(error)
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        }
    }
}
