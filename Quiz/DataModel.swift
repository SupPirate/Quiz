//
//  DataModel.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import Foundation


class QuestionFromJSON: Codable {
  
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
    answerVatiants = dictionary["answerVariants"] as? [String]  ?? nil
    answer = nil
  }
  
}


class QuizFile: Codable {
  
  var questions = [QuestionFromJSON]()
  var informationWasDownloaded = false
  
  init(_ link:String) {
    let url: URL = URL(string: link)!
    let urlSession = URLSession.shared
    let urlRequest = NSMutableURLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
    
    let task = urlSession.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
      guard let _:Data = data, let _:URLResponse = response  , error == nil else {
        return
      }
      self.setDataToVar(data: data!)
      self.saveDataOnDisk(data: data!)
      print("Done init(_ link:String)")
    })
    task.resume()
  }
  
  init() {
    let data = readDataFromDisk()
    setDataToVar(data: data!)
    print("Done init()")
  }
  
  func updateInformation() {
    do {
      let jsonEncoder = JSONEncoder()
      jsonEncoder.outputFormatting = .prettyPrinted
      let jsonData = try jsonEncoder.encode(questions)
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = documentsURL.appendingPathComponent("Questions.json")
      try jsonData.write(to: fileURL, options: .atomic)
      print("Done updateInformation()")
    } catch {
      print("Fail to encode questions")
    }
  }
  
  private func setDataToVar(data: Data) {
    let json = try? JSONSerialization.jsonObject(with: data, options: [])
    guard let jsonArray = json as? [[String: Any]] else {
      return
    }
    for dictionary in jsonArray{
      self.questions.append(QuestionFromJSON(dictionary))
    }
    self.informationWasDownloaded = true
  }
  
  private func saveDataOnDisk(data: Data) {
    do {
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = documentsURL.appendingPathComponent("Questions.json")
      print("Documents URL: \(documentsURL)")
      print("File URL: \(fileURL)")
      try data.write(to: fileURL, options: .atomic)
      print("Done saveDataOnDisk(Data: Data)")
    } catch {
      print("Save failed")
    }
  }
  
  private func readDataFromDisk() -> Data? {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent("Questions.json").path
    guard FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) else {
      return nil
    }
    print("Done readDataFromDisk()")
    return data
  }
  
}
