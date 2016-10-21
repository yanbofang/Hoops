//
//  GamesTableViewController.swift
//  Hoops
//
//  Created by Minh Tran on 10/9/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import UIKit

class GamesTableViewController: UITableViewController {
    
    @IBOutlet weak var GamesTable: UITableView! {
        didSet {
            self.GamesTable.reloadData()
        }
    }
    
    var games = [Games]()
    var getData = true
    
    var court: Int = 0 {
        didSet{
            DispatchQueue.global(qos: .userInitiated).async {
                if self.getData {
                    self.getData = false
                    self.downloadData()
                }
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    var data : NSMutableData = NSMutableData()
    var index  = 0
    
    func downloadData() {
        let url = NSURL(string: "http://minh.heliohost.org/hoops/database_op.php?function=getGames&court=" + String(court))
        let request = URLRequest(url: url as! URL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("request failed \(error)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as?
                    [AnyObject] {
                    for index in 0...json.count-1 {
                        if let item = json[index] as? [String: AnyObject] {
                            if let game_id = item["game_id"] as? String {
                                self.games.append(Games(
                                    gameName: item["description"] as! String,
                                    maxPlayers: Int(item["max_player_count"] as! String)!,
                                    currentNumPlayers: Int(item["current_player_count"] as! String)!,
                                    month: 10,
                                    date: 20,
                                    startTime: 5,
                                    endTime: 6,
                                    level: "Novice",
                                    teamBlue: [],
                                    teamRed: []
                                ))
                                print(item["description"] as! String)
                            }
                        }
                        self.GamesTable.reloadData()
                    }
                }
            } catch let parseError {
                print("parsing error: \(parseError)")
                let responseString = String(data: data, encoding: .utf8)
                print("raw response: \(responseString)")
            }
        }
        task.resume()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get game data
        DispatchQueue.global(qos: .userInitiated).async {
            if self.getData {
                self.getData = false
                self.downloadData()
            }
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.GamesTable.reloadData()
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GamesTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GamesTableViewCell
        
        // Fetches the appropriate game for the data source layout.
        let game = games[indexPath.row]
        
        // Configure the cell
        cell.gameName.text = game.gameName
        cell.level.text = game.level
        cell.month.text = String(game.month)
        cell.date.text = String(game.date)
        cell.players.text = String(game.currentNumPlayers)
        cell.maxPlayers.text = String(game.maxPlayers)
        cell.startTime.text = String(game.startTime)
        cell.endTime.text = String(game.endTime)
        
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
