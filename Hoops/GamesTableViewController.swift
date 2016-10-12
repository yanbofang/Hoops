//
//  GamesTableViewController.swift
//  Hoops
//
//  Created by Minh Tran on 10/9/16.
//  Copyright © 2016 Yanbo Fang. All rights reserved.
//

import UIKit

class GamesTableViewController: UITableViewController {
    
    var games = [Games]()
    
    var court: Int = 0 {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load sample data
        loadSampleGames()
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadSampleGames() {
        // For testing, load sample games
        let one = Player(username: "michael")
        let two = Player(username: "jeff")
        let three = Player(username: "three")
        let four = Player(username: "four")
        let game1 = Games(
            gameName: "Coolest Game of the Year",
            maxPlayers: 6,
            currentNumPlayers: 2,
            month: 10,
            date: 20,
            startTime: 5,
            endTime: 6,
            level: "Novice",
            teamBlue: [one, three, four],
            teamRed: [two]
        )
        
        let game2 = Games(
            gameName: "Lamest Game of the Year",
            maxPlayers: 8,
            currentNumPlayers: 5,
            month: 11,
            date: 21,
            startTime: 5,
            endTime: 6,
            level: "Novice",
            teamBlue: [one, three, four],
            teamRed: [two]
            )
        
        games += [game1, game2]
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
