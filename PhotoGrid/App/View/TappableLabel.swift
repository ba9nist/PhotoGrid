//
//  TappableLabel.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 01.12.2023.
//

import UIKit

class TappableLabel: UILabel {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        backgroundColor = Colors.bgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        backgroundColor = .white
    }
}
