//
//  DataModel.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import Foundation


struct QuestionFromJSON: Codable {
    
    let question: String
    let type: String
    let branching: Int?
    let nextQuestion: Int?
    let nextQuestionsArray: [Int]?
    let answerVatiants: [String]?
    var answer: String?
    
    init(_ dictionary: [String: Any]) {
        question = dictionary["question"] as? String  ?? "No question"
        type = dictionary["type"] as? String  ?? "open"
        branching = dictionary["branching"] as? Int  ?? nil
        if branching != nil {
            nextQuestion = nil
            nextQuestionsArray = dictionary["nextQuestion"] as? [Int]  ?? nil
        } else {
            nextQuestion = dictionary["nextQuestion"] as? Int  ?? nil
            nextQuestionsArray = nil
        }
        answerVatiants = dictionary["answerVatiants"] as? [String]  ?? nil
        answer = nil
    }
    
}
