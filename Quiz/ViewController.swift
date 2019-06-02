//
//  ViewController.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var quiz = QuizFile("https://raw.githubusercontent.com/SupPirate/JSONLink/master/quiz.json")
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func startQuiz(_ sender: UIButton) {
    if quiz.informationWasDownloaded {
      performSegue(withIdentifier: "ShowQuestion", sender: 0)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as? QuestionViewController
    vc?.numberOfCurrentQuestion = sender as? Int ?? nil
  }
  
}

