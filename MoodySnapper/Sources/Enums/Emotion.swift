//
//  Emotion.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import Foundation

enum Emotion: String, CaseIterable {
    case SURPRISED = "Surprise"
    case HAPPY = "Happy"
    case NEUTRAL = "Neutral"
    case ANGRY = "Angry"
    case DISGUST = "Disgust"
    case FEAR = "Fear"
    case SAD = "Sad"
    
    init?(id : Int) {
        switch id {
        case 1: self = .SURPRISED
        case 2: self = .HAPPY
        case 3: self = .NEUTRAL
        case 4: self = .ANGRY
        case 5: self = .DISGUST
        case 6: self = .FEAR
        case 7: self = .SAD
        default: return nil
        }
    }
    
}

