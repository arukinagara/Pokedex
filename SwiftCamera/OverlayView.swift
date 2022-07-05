//
//  OverlayView.swift
//  SwiftCamera
//
//  Created by dev on 2022/01/26.
//

import SwiftUI
import AVFoundation

struct OverlayView: View {
    var overlays: [ObjectOverlay]
    
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    private let edgeOffset: CGFloat = 2.0
    private let labelOffset: CGFloat = 10.0
    
    private let cornerRadius: CGFloat = 10.0
    private let stringBgAlpha: CGFloat = 0.7
    private let lineWidth: CGFloat = 3
    private let stringFontColor = UIColor.white
    private let stringHorizontalSpacing: CGFloat = 13.0
    private let stringVerticalSpacing: CGFloat = 7.0
    
    var body: some View {
        GeometryReader { reader in
            ForEach(overlays, id: \.id) { overlay in
                let confidenceValue = Int(overlay.confidence * 100.0)
                let nameString = "\(overlay.className)  (\(confidenceValue)%)"
                let nameStringSize = nameString.size(usingFont: self.displayFont)
                
                let convertedRectWork = overlay.rect.applying(CGAffineTransform(scaleX: reader.size.width / overlay.imageSize.width, y: reader.size.height / overlay.imageSize.height))
                
                let convertedRect = CGRect(x: max(convertedRectWork.origin.x, edgeOffset), y: max(convertedRectWork.origin.y, edgeOffset), width: convertedRectWork.width, height: convertedRectWork.height)
                
                Rectangle()
                    .stroke(Color(overlay.displayColor), lineWidth: 3)
                    .frame(width: convertedRect.width, height: convertedRect.height).position(x: convertedRect.midX, y: convertedRect.midY)
                
                let stringBgRect = CGRect(x: convertedRect.origin.x - 1.5, y: convertedRect.origin.y - (2 * stringVerticalSpacing + nameStringSize.height), width: 2 * stringHorizontalSpacing + nameStringSize.width, height: 2 * stringVerticalSpacing + nameStringSize.height)
                
                Rectangle()
                    .fill(Color(overlay.displayColor))
                    .frame(width: stringBgRect.width, height: stringBgRect.height).position(x: stringBgRect.midX, y: stringBgRect.midY)
                
                Text(nameString)
                    .frame(width: stringBgRect.width, height: stringBgRect.height).position(x: stringBgRect.midX, y: stringBgRect.midY)

            }
        }
    }
}

struct OverlayView_Previews: PreviewProvider {
    static let overlay = ObjectOverlay(confidence: 1, className: "diglett", rect: CGRect(x: 200, y: 200, width: 300, height: 300), displayColor: UIColor.red, imageSize: CGSize(width: 750, height: 1334))
    static let overlays = [overlay]
    
    static var previews: some View {
        OverlayView(overlays: overlays)
    }
}

