//
//  CreatGameViewController.swift
//  Hoops
//
//  Created by Yanbo Fang on 10/14/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import UIKit

class CreatGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var gameName: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var level: UIPickerView!
    @IBOutlet weak var maxPlayers: UITextField!
    @IBOutlet weak var gameDescription: UITextView!
    
    
    var court: Int = 1
    
    var levelData: [String] = [String]()

    // returns the number of 'columns' to display.
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return 4
    }
    
    //put data in to title
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levelData[row]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //connect data
        self.level.delegate = self
        self.level.dataSource = self
        
        //input level data
        levelData = ["Novice", "Amatuer", "Pro", "All Star"]
        
        // Do any additional setup after loading the view.
    }

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if saveButton === sender as AnyObject?{
            let gameName = gameName.text ?? ""

            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the game to be passed to GamesTableViewController after the unwind segue.
            game = Games.init(gameName: gameName, maxPlayers: maxPlayers, currentNumPlayers: 1, month: Int, date: <#T##Int#>, startTime: <#T##Int#>, endTime: <#T##Int#>, level: String, teamBlue: [Player], teamRed: <#T##[Player]#>)
        }
    }
    */
    
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        uploadData()
        
        self.navigationController?.popViewController(animated: true)
        
    }
    func uploadData() {
        
        //Parse the date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYYMMdd"
        let strDate = dateformatter.string(from: date.date)
        
        //Parse the time
        dateformatter.dateFormat = "HHmmss"
        let strTime = dateformatter.string(from: time.date)
        
        
        //replace all the space in description with %20
        var newDescription = ""
        for char in gameDescription.text.characters{
            if(char == " "){
                newDescription = newDescription + "%20"
            }
            else{
                newDescription = newDescription + String(char)
            }
        }
        
        let tempUrl1 = "http://minh.heliohost.org/hoops/database_op.php?function=addGame&court_id=" + String(court) + "&date=" + strDate
        let tempUrl2 = "&time=" + strTime + "&description=" + newDescription
        let tempUrl3 = "&current_player_count=" + String(1) + "&max_player_count=" + maxPlayers.text!
        let tempUrl4 = "&user_id=" + String(1)
        let url = NSURL(string: tempUrl1 + tempUrl2 + tempUrl3 + tempUrl4)
        let request = URLRequest(url: url as! URL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("request failed \(error)")
                return
            }
        }
        task.resume()
    }

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
