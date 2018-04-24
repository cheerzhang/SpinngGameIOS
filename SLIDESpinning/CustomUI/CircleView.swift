//
//  CircleView.swift
//  SLIDESpinning
//
//  Created by Wayne Lai on 13/12/17.
//  Copyright © 2017 Wayne Lai. All rights reserved.
//

import UIKit

/// Defines a segment of the pie chart
struct CCView {
  
  /// The name of the segment
  var name : String
  
  var value : CGFloat
  
}

class CircleView: UIView {
  
  /// An array of structs representing the segments of the pie chart
  var segments = [CCView]() {
    didSet { setNeedsDisplay() } // re-draw view when the values get set
  }
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    let size = self.bounds.size
    
    
    // radius is the half the frame's width or height (whichever is smallest)
    let radius = min(frame.width, frame.height) * 0.5
    
    // center of the view
    let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
    
    // enumerate the total value of the segments by using reduce to sum them
    let valueCount = segments.reduce(0, {$0 + $1.value})
    
    var startAngle = -CGFloat.pi * 0.5 - 0.4
    
    context.translateBy (x: size.width / 2, y: size.height / 2)
    context.scaleBy (x: -1, y: 1)
    
    // loop through the values array
    for segment in segments {
      
      // update the end angle of the segment
      let endAngle = startAngle - .pi * 2 * (segment.value / valueCount)
      
      centreArcPerpendicular(text: segment.name, context: context, radius: radius - 25, angle: startAngle, colour: UIColor.white, font: UIFont.boldSystemFont(ofSize: 20), clockwise: true)
      
      // update starting angle of the next segment to the ending angle of this segment
      startAngle = endAngle
    }
    
//    centreArcPerpendicular(text: "Anticlockwise", context: context, radius: 100, angle: CGFloat(-(Double.pi / 2)), colour: UIColor.red, font: UIFont.systemFont(ofSize: 16), clockwise: false)
//    centre(text: "Hello flat world", context: context, radius: 0, angle: 0 , colour: UIColor.yellow, font: UIFont.systemFont(ofSize: 16), slantAngle: CGFloat(Double.pi / 4))
  }
}





