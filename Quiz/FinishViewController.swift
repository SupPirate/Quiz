//
//  FinishViewController.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var quiz = QuizFile()

  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

extension FinishViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quiz.questions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
    let questionLabel = cell.viewWithTag(1010) as! UILabel
    let answerLabel = cell.viewWithTag(1011) as! UILabel
    
    questionLabel.text = quiz.questions[indexPath.row].question
    answerLabel.text = quiz.questions[indexPath.row].answer ?? "No answer"
    
    return cell
  }
  
  
}
