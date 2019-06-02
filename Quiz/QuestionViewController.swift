//
//  QuestionViewController.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var questionTitle: UILabel!
  
  var questionsFile = [QuestionFromJSON]()
  
  
  var typeOfCurrentQuestion: String?
  var count = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nextButton.isEnabled = false
    switch typeOfCurrentQuestion {
    case "choice":
      prepareForChoise()
    case "date":
      prepareForDate()
    default:
      prepareForOpen()
    }
    readDataFromDisk()
  }
  
  @IBAction func nextQuestion(_ sender: UIButton) {
    //        performSegue(withIdentifier: "NextQuestion", sender: "open") // choice open
    performSegue(withIdentifier: "Finish", sender: nil)
  }
  
  
  @IBAction func finishQuestion(_ sender: Any) {
  }
  
  @IBAction func tochDownRepeat(_ sender: Any) {
    
  }
  
  @IBAction func editingDidEnd(_ sender: Any) {
    questionsFile[0].answer = textField.text
    nextButton.isEnabled = true
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    do {
      let jsonData =  try jsonEncoder.encode(questionsFile)
      saveDataOnDisk(Data: jsonData)
    } catch {
      print("Error!")
    }
  }
  
  @IBAction func touchUpOutside(_ sender: Any) {
    print("Touch")
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as? QuestionViewController
    vc?.typeOfCurrentQuestion = sender as? String
  }
  
  func prepareForChoise() {
    textField.isHidden = true
  }
  
  func prepareForDate() {
    textField.isHidden = true
    tableView.isHidden = true
  }
  
  func prepareForOpen() {
    tableView.isHidden = true
  }
  
  
  func readDataFromDisk() {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let filePath = documentsURL.appendingPathComponent("Questions.json").path
    if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
      let json = try? JSONSerialization.jsonObject(with: data, options: [])
      guard let jsonArray = json as? [[String: Any]] else {
        return
      }
      for dic in jsonArray{
        self.questionsFile.append(QuestionFromJSON(dic))
      }
      print(self.questionsFile)
      questionTitle.text = questionsFile.first?.question
    }
  }
  
  func saveDataOnDisk(Data: Data) {
    do {
      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let fileURL = documentsURL.appendingPathComponent("Questions.json")
      print(documentsURL)
      print(fileURL)
      try Data.write(to: fileURL, options: .atomic)
      print("Saved!")
    } catch { }
  }
}
