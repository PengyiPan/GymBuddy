//
//  EditAttribute.swift
//  GymBuddy
//
//  Created by Justin (Zihao) Zhang on 12/3/14.
//  Copyright (c) 2014 Duke 2014 Fall CS316. All rights reserved.
//

import Foundation

enum EditAttribute {
    case EditFirstName
    case EditLastName
    case EditSignature
    case EditGender
    case EditPicture
    
    var description:String {
        switch self {
        case .EditFirstName:
            return "EditFirstName"
        case .EditLastName:
            return "EditLastName"
        case .EditSignature:
            return "EditSignature"
        case .EditGender:
            return "EditGender"
        case .EditPicture:
            return "EditPicture"
        }
    }
}

