//
//  Emotion.swift
//  MoodySnapper
//
//  Created by Dzulfikar on 14/05/23.
//

import Foundation

enum Emotion: String, CaseIterable {
    case SURPRISE = "Surprise"
    case HAPPY = "Happy"
    case NEUTRAL = "Neutral"
    case ANGRY = "Angry"
    case DISGUST = "Disgust"
    case FEAR = "Fear"
    case SAD = "Sad"
    
    init?(id : Int) {
        switch id {
        case 1: self = .SURPRISE
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

struct EmotionScene {
    let emotion: Emotion
    let animation: String
    
    static func animation(emotion: Emotion) -> String {
        switch emotion {
        case .SURPRISE:
            return "Fox_Somersault_InPlace.scn"
        case .HAPPY:
            return "Fox_Jump.scn"
        case .NEUTRAL:
            return "Fox_Idle.scn"
        case .ANGRY:
            return "Fox_Attack_Paws.scn"
        case .DISGUST:
            return "Fox_Sit2_Idle.scn"
        case .FEAR:
            return "Fox_Run_InPlace.scn"
        case .SAD:
            return "Fox_Sit_No.scn"
        return "Fox_Idle.scn"
        }
    }
    
    static let list: [EmotionScene] = [
        EmotionScene(emotion: Emotion.SURPRISE, animation: "Fox_Somersault_InPlace.scn"),
        EmotionScene(emotion: Emotion.HAPPY, animation: "Fox_Jump.scn"),
        EmotionScene(emotion: Emotion.NEUTRAL, animation: "Fox_Idle.scn"),
        EmotionScene(emotion: Emotion.ANGRY, animation: "Fox_Attack_Paws.scn"),
        EmotionScene(emotion: Emotion.DISGUST, animation: "Fox_Sit2_Idle.scn"),
        EmotionScene(emotion: Emotion.FEAR, animation: "Fox_Run_InPlace.scn"),
        EmotionScene(emotion: Emotion.SAD, animation: "Fox_Sit_No.scn"),
    ]
}

