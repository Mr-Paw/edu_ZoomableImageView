//
//  UIScrollableImageView.swift
//  ScrollingAndZooming
//
//  Created by paw on 29.11.2020.
//  Copyright © 2020 paw. All rights reserved.
//

import UIKit
import SwiftUI

class ZoomableImageView: UIScrollView {
    var imgView: UIImageView! = UIImageView()
    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        recognizer.numberOfTapsRequired = 2
        return recognizer
    }()

    /// must be called after view has appeared (e. g. in ``viewDidAppear(_:)``), otherwise image will display incorrectly
    func setup(with image: UIImage?){
        // clear existing image view before creating a new one
        imgView?.removeFromSuperview()
        imgView = nil

        guard let image else {
            return
        }

        imgView = UIImageView(image: image)
        addSubview(imgView)

        let boundsSize = bounds.size
        let imageSize = imgView.bounds.size
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height

        // calculate the min scale using image x and y ratios, so the image displays just right in minimum scale
        let minScale = min(xScale, yScale)
        // how many times the image should be able to zoom in
        var maxScale: CGFloat = 5

        // hide indicators
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        decelerationRate = .fast // when user lifts his/her finger from the screen, this can specify how scrollview should decelerate

        minimumZoomScale = minScale
        maximumZoomScale = maxScale
        zoomScale = minimumZoomScale
        contentSize = image.size

        imgView.addGestureRecognizer(doubleTapRecognizer)
        // enable interaction so double tap gesture can be recognized
        imgView.isUserInteractionEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
        backgroundColor = .clear
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }

    private func centerImage(){
        let boundsSize = bounds.size
        var frameToCenter = imgView?.frame ?? CGRect.zero
        if frameToCenter.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.width)/2
        } else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.height)/2
        } else {
            frameToCenter.origin.y = 0
        }
        imgView?.frame = frameToCenter
    }

    private func zoom(point: CGPoint) {
        let currentScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        if minScale == maxScale && minScale > 1 {
            // why even try to zoom if the scale is the same
            return
        }
        // if current scale is min, zoom in, otherwise zoom out
        let scale = (currentScale == minScale) ? maxScale : minScale
        let zoomRect = zoomRect(scale: scale, center: point)
        zoom(to: zoomRect, animated: true)
    }
    
    // it crops the rect to scaled size, then moves it the the location
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        
        return zoomRect
    }
}

// MARK: - Delegate
extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imgView }
    func scrollViewDidZoom(_ scrollView: UIScrollView) { centerImage() }
}

// MARK: - @objc
@objc private extension ZoomableImageView {
    func handleDoubleTap(sender: UITapGestureRecognizer){
        let location = sender.location(in: sender.view)
        zoom(point: location)
    }
}

// MARK: - SwiftUI wrapper
struct ZoomableImage: UIViewRepresentable {
    var image: UIImage?
    func makeUIView(context: Context) -> ZoomableImageView {
        let view = ZoomableImageView()
        return view
    }

    func updateUIView(_ uiView: ZoomableImageView, context: Context) {
        updateImage(uiView)
    }

    private func updateImage(_ view: ZoomableImageView) {
        // check if image isn't the same as already set to not update the scroll view with the same image
        guard view.imgView.image != image else {
            return
        }
        // we MUST call this on the main queue, otherwise the UIScrollView will bug out
        DispatchQueue.main.async {
            view.setup(with: image)
        }
    }
}
