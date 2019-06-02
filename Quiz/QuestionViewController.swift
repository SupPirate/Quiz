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

  override func viewDidLoad() {
    super.viewDidLoad()
    prepapreViewForQuestion()
    guard let currentQuestion = numberOfCurrentQuestion else {
      return
    }
    questionTitle.text = quiz.questions[currentQuestion].question
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
    nextButton.isHidden = false
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
    guard quiz.questions[currentQuestion].nextQuestion != nil else {
      performSegue(withIdentifier: "Finish", sender: nil)
      return
    }
    if (quiz.questions[currentQuestion].branching != nil) {
      performSegue(withIdentifier: "NextQuestion", sender: quiz.questions[currentQuestion].nextQuestionsArray![0])
    } else {
      performSegue(withIdentifier: "NextQuestion", sender: quiz.questions[currentQuestion].nextQuestion)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as? QuestionViewController
    vc?.numberOfCurrentQuestion = sender as? Int ?? nil
  }
  
}
