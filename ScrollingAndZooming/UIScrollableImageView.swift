//
//  UIScrollableImageView.swift
//  ScrollingAndZooming
//
//  Created by paw on 29.11.2020.
//  Copyright © 2020 paw. All rights reserved.
//

import UIKit

class UIScrollableImageView: UIScrollView, UIScrollViewDelegate {
   private func centerImage(){
        let boundsSize = bounds.size
    var frameToCenter = imgView?.frame ?? CGRect.zero
    if frameToCenter.width < boundsSize.width {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.width)/2
    }else{
        frameToCenter.origin.x = 0
    }
    if frameToCenter.height < boundsSize.height {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.height)/2
    }else{
        frameToCenter.origin.y = 0
    }
        imgView.frame = frameToCenter
    }

    var imgView: UIImageView! = UIImageView()
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomTap))
        zoomTap.numberOfTapsRequired = 2
        return zoomTap
    }()
    
    func setup(with image: UIImage){
        //это стирает данные об хранящемся изображении в "imgView"
        imgView.removeFromSuperview()
        imgView = nil

        imgView = UIImageView(image: image)
        addSubview(imgView)
//        maximumZoomScale = 10
        
        
        //set max min zoom scale
        let boundsSize = bounds.size
        let imageSize = imgView.bounds.size
        print(boundsSize, imageSize)
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        print(xScale,yScale)
        let minScale = min(xScale, yScale)
        var maxScale: CGFloat = 0.1
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale<0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5{
            maxScale = max(1.0, minScale)
        }
        print(maxScale,minScale)
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
                decelerationRate = .normal
//        minimumZoomScale = 0.1
//        maximumZoomScale = 10
        minimumZoomScale = minScale
        maximumZoomScale = maxScale
        self.contentSize = image.size
        zoomScale = minimumZoomScale
        imgView.addGestureRecognizer(zoomingTap)
        imgView.isUserInteractionEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        setup(with: imgView.image!)
        centerImage()
        if #available(iOS 12.0, *) {
            backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        } else {
            backgroundColor = .white
            
        }
        
    }
    
    
    @objc func handleZoomTap(sender: UITapGestureRecognizer){
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    func zoom(point: CGPoint, animated: Bool) {
let currentScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        if minScale == maxScale && minScale > 1{
            return
        }
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRCT = zoomRect(scale: finalScale, center: point)
        
        zoom(to: zoomRCT, animated: animated)
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.width = bounds.size.width/scale
        zoomRect.size.height = bounds.size.height/scale

        zoomRect.origin.x = center.x - (zoomRect.size.width/2)
        zoomRect.origin.y = center.y - (zoomRect.size.height/2)

        return zoomRect
    }
    //MARK: - ScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
