//
//  CustomTimer.swift
//  PhotoGrid
//
//  Created by Yevhenii Boryspolets on 01.12.2023.
//

import Foundation

class CustomTimer {
    private var timer: Timer?
    private let timeInterval: TimeInterval
    private let repeats: Bool
    private let target: Any
    private let action: Selector
    
    init(time: TimeInterval, repeats: Bool, target: Any, action: Selector) {
        self.timeInterval = time
        self.repeats = repeats
        self.target = target
        self.action = action
    }
    func start() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: target, selector: action, userInfo: nil, repeats: repeats)
    }

    func reset() {
        stop()
        start()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
