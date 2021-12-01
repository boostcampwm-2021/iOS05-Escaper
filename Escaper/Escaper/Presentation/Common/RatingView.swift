//
//  RatingView.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/25.
//

import UIKit

class RatingView: UIView {
    enum RatingImageKind {
        case star
        case lock
    }

    enum RatingImageState {
        case filled(kind: RatingImageKind)
        case unfilled(kind: RatingImageKind)

        var image: UIImage? {
            switch self {
            case .filled(let kind):
                switch kind {
                case .star:
                    return EDSImage.starFilled.value
                case .lock:
                    return EDSImage.lockFilled.value
                }
            case .unfilled(let kind):
                switch kind {
                case .star:
                    return EDSImage.starUnfilled.value
                case .lock:
                    return EDSImage.lockUnfilled.value
                }
            }
        }
    }

    enum FillMode {
        case full
        case half
        case precise
    }

    var fullRating = 5
    var currentRating: Double = 0 {
        didSet {
            if oldValue != currentRating {
                self.update()
            }
        }
    }
    var fillMode: FillMode = .precise
    var starSize = 20 {
        didSet {
            self.update()
        }
    }
    var starSpacing = 5
    var updateOnTouch = false
    var didFinishTouchingCosmos: ((Double) -> Void)?
    var imageKind: RatingImageKind = .star
    private var viewSize = CGSize()
    override open var intrinsicContentSize: CGSize { return self.viewSize }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.update()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.update()
    }

    func update() {
        let layers = self.createStarLayers()
        self.layer.sublayers = layers
        self.updateSize(layers)
        guard updateOnTouch else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = self.touchLocationFromBeginningOfRating(touches) else { return }
        self.onDidTouch(location)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = self.touchLocationFromBeginningOfRating(touches) else { return }
        self.onDidTouch(location)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.didFinishTouchingCosmos?(currentRating)
    }

    func touchLocationFromBeginningOfRating(_ touches: Set<UITouch>) -> CGFloat? {
        guard let touch = touches.first else { return nil }
        let location = touch.location(in: self).x
        return location
    }

    func onDidTouch(_ locationX: CGFloat) {
        let calculatedTouchRating = self.touchRating(locationX)
        if self.updateOnTouch {
            self.currentRating = calculatedTouchRating
        }
    }

    func touchRating(_ position: CGFloat) -> Double {
        var rating = self.preciseRating(position: Double(position))
        if self.fillMode == .half {
            rating += 0.2
        }
        if self.fillMode == .full {
            rating += 0.45
        }
        rating = self.displayedRatingFromPreciseRating(rating)
        let minTouchRating = 0.5
        rating = max(minTouchRating, rating)
        return rating
    }

    func displayedRatingFromPreciseRating(_ preciseRating: Double) -> Double {
        let starFloorNumber = floor(preciseRating)
        let singleStarRemainder = preciseRating - starFloorNumber
        var displayedRating = starFloorNumber + starFillLevel(ratingRemainder: singleStarRemainder)
        displayedRating = min(Double(self.fullRating), displayedRating)
        displayedRating = max(0, displayedRating)
        return displayedRating
    }

    func preciseRating(position: Double) -> Double {
        if position < 0 { return 0 }
        var positionRemainder = position
        var rating: Double = Double(Int(position / Double((self.starSize + self.starSpacing))))
        if Int(rating) > self.fullRating {
            return Double(self.fullRating)
        }
        positionRemainder -= rating * Double((self.starSize + self.starSpacing))
        if positionRemainder > Double(self.starSize) {
            rating += 1
        } else {
            rating += positionRemainder / Double(self.starSize)
        }
        return rating
    }
}

private extension RatingView {
    func createStarLayers() -> [CALayer] {
        var ratingRemainder = self.numberOfFilledStars()
        var starLayers = [CALayer]()
        for _ in 0..<fullRating {
            let fillLevel = self.starFillLevel(ratingRemainder: ratingRemainder)
            let starLayer = self.createCompositeStarLayer(starFillLevel: fillLevel)
            starLayers.append(starLayer)
            ratingRemainder -= 1
        }
        self.positioningStarLayers(starLayers)
        return starLayers
    }

    func numberOfFilledStars() -> Double {
        guard self.currentRating < Double(self.fullRating) else { return Double(self.fullRating) }
        guard self.currentRating >= 0 else { return 0 }
        return self.currentRating
    }

    func starFillLevel(ratingRemainder: Double) -> Double {
        var value = ratingRemainder
        if value > 1 { value = 1 }
        if value < 0 { value = 0 }
        switch self.fillMode {
        case .full:
            return round(value)
        case .half:
            return round(value * 2) / 2
        case .precise:
            return value
        }
    }

    func createCompositeStarLayer(starFillLevel: Double) -> CALayer {
        if starFillLevel == 1 {
            return self.createStarLayer(isFilled: true)
        }
        if starFillLevel == 0 {
            return self.createStarLayer(isFilled: false)
        }
        return self.createPartialStarLayer(starFillLevel: starFillLevel)
    }

    func createStarLayer(isFilled: Bool) -> CALayer {
        guard let image = isFilled ? RatingImageState.filled(kind: self.imageKind).image : RatingImageState.unfilled(kind: self.imageKind).image else { return CALayer() }
        let containerLayer = self.createContainerLayer(self.starSize)
        let imageLayer = self.createContainerLayer(self.starSize)
        containerLayer.addSublayer(imageLayer)
        imageLayer.contents = image.cgImage
        imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
        return containerLayer
    }

    func createPartialStarLayer(starFillLevel: Double) -> CALayer {
        let filledStarLayer = self.createStarLayer(isFilled: true)
        let unfilledStarLayer = self.createStarLayer(isFilled: false)
        let parentLayer = CALayer()
        parentLayer.contentsScale = UIScreen.main.scale
        parentLayer.bounds = CGRect(origin: CGPoint(), size: filledStarLayer.bounds.size)
        parentLayer.anchorPoint = CGPoint()
        parentLayer.addSublayer(unfilledStarLayer)
        parentLayer.addSublayer(filledStarLayer)
        filledStarLayer.bounds.size.width *= CGFloat(starFillLevel)
        return parentLayer
    }

    func createContainerLayer(_ size: Int) -> CALayer {
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        layer.anchorPoint = CGPoint()
        layer.masksToBounds = true
        layer.bounds.size = CGSize(width: size, height: size)
        layer.isOpaque = true
        return layer
    }

    func positioningStarLayers(_ layers: [CALayer]) {
        var positionX: CGFloat = 0
        for layer in layers {
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(self.starSpacing)
        }
    }

    func updateSize(_ layers: [CALayer]) {
        self.viewSize = sizeToFitLayers(layers)
        self.invalidateIntrinsicContentSize()
        self.frame.size = self.intrinsicContentSize
    }

    func sizeToFitLayers(_ layers: [CALayer]) -> CGSize {
        var size = CGSize()
        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
            }
            if layer.frame.maxY > size.height {
                size.height = layer.frame.maxY
            }
        }
        return size
    }
}
