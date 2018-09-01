//
//  UnfoldViewController.swift
//  Demo-iOS
//
//  Created by Alexander Khitev on 8/31/18.
//  Copyright © 2018 PocketSVG. All rights reserved.
//

import UIKit
import PocketSVG

class UnfoldViewController: UIViewController {
    
    private let containerView = ContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
        addContainerView()
    }
    
    private func setupSettings() {
        view.backgroundColor = .white
    }
    
    private func addContainerView() {
        let secondView = UIView()
        secondView.backgroundColor = .orange
        containerView.frame = UIScreen.main.bounds.insetBy(dx: 47, dy: 47)
        secondView.frame = containerView.frame.insetBy(dx: 50, dy: 50)
        containerView.backgroundColor = .green
        containerView.layer.zPosition = 200
        view.addSubview(containerView)
        //        containerView.insertSubview(secondView, at: 0)
    }
    
    
}

private class ContainerView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let svgURL = Bundle.main.url(forResource: "RP1Template12-Border-Mask", withExtension: "svg")!
        let svgPaths = SVGBezierPath.pathsFromSVG(at: svgURL)
        let context = UIGraphicsGetCurrentContext()!
        debugPrint("original rect", rect)
        debugPrint("updated rect", rect.insetBy(dx: 1.5, dy: 1.5))
        SVGDrawPaths(svgPaths, context, rect.insetBy(dx: 1.5, dy: 1.5), UIColor.clear.cgColor, UIColor.black.cgColor)
        
        //        for svgPath in svgPaths {
        //            var cgPath = svgPath.cgPath.resizePath(to: rect.insetBy(dx: 1.5, dy: 1.5))
        //            context.addPath(cgPath)
        //        }
        //
        //        let color = UIColor.black.cgColor
        //        context.setStrokeColor(color)
        //        context.setLineWidth(3)
        //        context.setFillColor(UIColor.clear.cgColor)
        //        context.drawPath(using: .fillStroke)
        
        //        SVGDrawPaths(svgPaths, context, rect.insetBy(dx: 1.5, dy: 1.5), UIColor.clear.cgColor, UIColor.black.cgColor)
        
    }
    
    // works
    
    //    override func draw(_ rect: CGRect) {
    //        super.draw(rect)
    //        let svgURL = Bundle.main.url(forResource: "RP1Template12-Border-Mask", withExtension: "svg")!
    //        let svgPaths = SVGBezierPath.pathsFromSVG(at: svgURL)
    //        let context = UIGraphicsGetCurrentContext()!
    //        for svgPath in svgPaths {
    //            let cgPath = svgPath.cgPath.resizePath(to: rect.insetBy(dx: 1.5, dy: 1.5))
    //            context.addPath(cgPath)
    //        }
    //
    //        let color = UIColor.black.cgColor
    //        context.setStrokeColor(color)
    //        context.setLineWidth(3)
    //        context.setFillColor(UIColor.clear.cgColor)
    //        //        context.drawPath(using: .fillStroke)
    //
    //        SVGDrawPaths(svgPaths, context, rect.insetBy(dx: 1.5, dy: 1.5), UIColor.clear.cgColor, UIColor.black.cgColor)
    //
    //    }
    
}

extension CGPath {
    
    
    func resizePath(to frame: CGRect) -> CGPath {
        let boundingBox = self.boundingBox
        
        let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
        let viewAspectRatio = frame.width / frame.height
        
        var scaleFactor: CGFloat = 1
        if boundingBoxAspectRatio > viewAspectRatio {
            // Width is limiting factor
            scaleFactor = frame.width / boundingBox.width
        } else {
            // Height is limiting factor
            scaleFactor = frame.height / boundingBox.height
        }
        // Scaling the path ...
        var scaleTransform = CGAffineTransform.identity
        // Scale down the path first
        scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
        // Then translate the path to the upper left corner
        scaleTransform = scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)
        
        // If you want to be fancy you could also center the path in the view
        // i.e. if you don't want it to stick to the top.
        // It is done by calculating the heigth and width difference and translating
        // half the scaled value of that in both x and y (the scaled side will be 0)
        let scaledSize = boundingBox.size.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let centerOffset = CGSize(width: (frame.width - scaledSize.width) / (scaleFactor * 2), height: (frame.height - scaledSize.height) / (scaleFactor * 2))
        debugPrint("centerOffset", centerOffset, "scaleFactor", scaleFactor)
        
        scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
        // End of "center in view" transformation code
        
        return self.copy(using: &scaleTransform)!
    }
    
}
