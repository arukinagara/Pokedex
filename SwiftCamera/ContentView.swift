//
//  ContentView.swift
//  SwiftCamera
//
//  Created by dev on 2022/01/24.
//

import SwiftUI
import Combine
import AVFoundation
import VideoToolbox

final class CameraModel: ObservableObject {
    private let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    @Published var objectOverlays: [ObjectOverlay]!
    
    @Published var image: CVPixelBuffer?
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
        
        service.$objectOverlays.sink { [weak self] (val) in
            self?.objectOverlays = val
        }
        .store(in: &self.subscriptions)
        
        service.$image.sink { [weak self] (val) in
            self?.image = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}

struct CameraView: View {
    @StateObject var model = CameraModel()
    @State var currentZoomFactor: CGFloat = 1.0
    @State private var showingSheet = false
    @State var className: String = ""
    @State var cgimage: CGImage?
    @State var uiimage: UIImage?
    
    let synthesizer = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
    
    var captureButton: some View {
        Button(action: {
            if model.objectOverlays.count != 0 {
                // model.capturePhoto()
                VTCreateCGImageFromCVPixelBuffer(model.image!, options: nil, imageOut: &cgimage)
                self.cgimage = self.cgimage?.cropping(to: model.objectOverlays.first!.rect)
                self.uiimage = UIImage(cgImage: self.cgimage!)
                self.className = model.objectOverlays.first!.className
                
                let pokemon = Pokemon(className: self.className)
                
                let name = AVSpeechUtterance.init(string: pokemon!.name)
                let category = AVSpeechUtterance.init(string: pokemon!.category)
                let caption = AVSpeechUtterance.init(string: pokemon!.caption)
                name.voice = voice
                category.voice = voice
                caption.voice = voice
                synthesizer.speak(name)
                synthesizer.speak(category)
                synthesizer.speak(caption)
                
                self.showingSheet.toggle()
            }
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 80, height: 10, alignment: .center)
                )
                .overlay(
                    Circle()
                        .fill(Color.black)
                        .frame(width: 45, height: 45, alignment: .center)
                )
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 25, height: 25, alignment: .center)
                )
        })
    }
    
    var capturedPhotoThumbnail: some View {
        Group {
            if self.uiimage != nil {
                Image(uiImage: self.uiimage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring(), value: CGPoint.zero)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(.black)
            }
        }
    }
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
        })
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Button(action: {
                        model.switchFlash()
                    }, label: {
                        Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 20, weight: .medium, design: .default))
                    })
                    .accentColor(model.isFlashOn ? .yellow : .white)
                    
                    ZStack{
                        CameraPreview(session: model.session)
                            .gesture(
                                DragGesture().onChanged({ (val) in
                                    //  Only accept vertical drag
                                    if abs(val.translation.height) > abs(val.translation.width) {
                                        //  Get the percentage of vertical screen space covered by drag
                                        let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                        //  Calculate new zoom factor
                                        let calc = currentZoomFactor + percentage
                                        //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                        //  Store the newly calculated zoom factor
                                        currentZoomFactor = zoomFactor
                                        //  Sets the zoom factor to the capture device session
                                        model.zoom(with: zoomFactor)
                                    }
                                })
                            )
                            .onAppear {
                                model.configure()
                            }
                            .alert(isPresented: $model.showAlertError, content: {
                                Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                    model.alertError.primaryAction?()
                                }))
                            })
                            .overlay(
                                Group {
                                    if model.willCapturePhoto {
                                        Color.black
                                    }
                                }
                            )
                            .animation(.easeInOut, value: model.willCapturePhoto)
                        OverlayView(overlays: model.objectOverlays)
                    }
                    
                    HStack {
                        capturedPhotoThumbnail
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                        flipCameraButton
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            DetailView(className: self.className, image: self.uiimage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
