//
//  ViewController.swift
//  Quiz
//
//  Created by admin on 29/05/2019.
//  Copyright © 2019 medisafe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var questionsFile = [QuestionFromJSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromURL("https://raw.githubusercontent.com/SupPirate/JSONLink/master/quiz.json")
        
    }
    
    func getDataFromURL(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            guard let jsonArray = json as? [[String: Any]] else {
                return
            }
            for dic in jsonArray{
                self.questionsFile.append(QuestionFromJSON(dic))
            }
            self.saveDataOnDisk(Data: data!)
        })
        task.resume()
    }

    func saveDataOnDisk(Data: Data) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("Questions.json")
            print(documentsURL)
            print(fileURL)
            try Data.write(to: fileURL, options: .atomic)
        } catch { }
    }
    
    func readDataFromDisk() -> Data? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("Questions.json").path
        if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
            return data
        }
        return nil
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? QuestionViewController
        vc?.typeOfCurrentQuestion = sender as? String
    }
    
    @IBAction func startQuiz(_ sender: UIButton) {
        let nextQuestionType = questionsFile.first?.type
        performSegue(withIdentifier: "ShowQuestion", sender: nextQuestionType ?? "open")
    }
  
}

