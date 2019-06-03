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
  
  var quiz = QuizFile()
  var numberOfCurrentQuestion = Int?(nil)
//  var branchToChoose = 0
  
  var checkedItems = [Bool]()


  override func viewDidLoad() {
    super.viewDidLoad()
    prepapreViewForQuestion()
    guard let currentQuestion = numberOfCurrentQuestion else {
      return
    }
    questionTitle.text = quiz.questions[currentQuestion].question
    if quiz.questions[currentQuestion].answerVariants != nil {
      for _ in quiz.questions[currentQuestion].answerVariants! {
        checkedItems.append(false)
      }
    }
  }
  
  func prepapreViewForQuestion() {
    guard let currentQuestion = numberOfCurrentQuestion else {
      return
    }
    let typeOfCurrentQuestion = quiz.questions[currentQuestion].type
    switch typeOfCurrentQuestion {
    case "choice":
      textField.isHidden = true
    case "date":
      textField.isHidden = true
      tableView.isHidden = true
    default:
      tableView.isHidden = true
    }
    nextButton.isHidden = true
  }
  
  @IBAction func done() {
    nextButton.isHidden = false
    quiz.questions[numberOfCurrentQuestion!].answer = textField.text
    quiz.updateInformation()
  }
  
  @IBAction func nextQuestion(_ sender: UIButton) {
    guard let currentQuestion = numberOfCurrentQuestion else {
      return
    }
    var branchToChoose = 0
    if checkedItems.count > 0 {
      for (index,item) in checkedItems.enumerated() {
        if item {
          quiz.questions[currentQuestion].answer = quiz.questions[currentQuestion].answerVariants![index]
          quiz.updateInformation()
          branchToChoose = index
          break
        }
      }
    }
    if quiz.questions[currentQuestion].branching != nil {
      performSegue(withIdentifier: "NextQuestion", sender: quiz.questions[currentQuestion].nextQuestionsArray![branchToChoose])
    } else if quiz.questions[currentQuestion].nextQuestion != nil {
      performSegue(withIdentifier: "NextQuestion", sender: quiz.questions[currentQuestion].nextQuestion)
    } else {
      performSegue(withIdentifier: "Finish", sender: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as? QuestionViewController
    vc?.numberOfCurrentQuestion = sender as? Int ?? nil
  }
  
}


extension QuestionViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quiz.questions[numberOfCurrentQuestion!].answerVariants?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell", for: indexPath)
    let answerVariantLabel = cell.viewWithTag(1000) as! UILabel
    answerVariantLabel.text = quiz.questions[numberOfCurrentQuestion!].answerVariants![indexPath.row]
    cell.accessoryType = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    for (index,_) in checkedItems.enumerated() {
      if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) {
        cell.accessoryType = .none
        checkedItems[index] = false
      }
    }
    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
      checkedItems[indexPath.row] = true
      nextButton.isHidden = false
    }
  }
  
}
