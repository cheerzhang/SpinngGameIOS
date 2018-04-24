//
//  RoundedActionButton.swift
//  minigames
//
//  Created by Wayne Lai on 22/8/17.
//  Copyright © 2017 Wayne Lai. All rights reserved.
//

import UIKit

@IBDesignable class RoundedActionButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    addTarget(self, action: #selector(self.btnTouchDown), for: .touchDown)
    addTarget(self, action: #selector(self.btnRelease), for: .touchDragExit)
    addTarget(self, action: #selector(self.btnRelease), for: .touchUpInside)
  }
  
  @objc func btnTouchDown() {
    UIView.animate(withDuration: 0.1) {
      self.transform = .init(scaleX: 0.90, y: 0.90)
    }
  }
  
  @objc func btnRelease() {
    UIView.animate(withDuration: 0.3) {
      self.transform = .identity
    }
  }
  
}
