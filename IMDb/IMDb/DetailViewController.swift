//I, Johns Varughese Meppurath, student number 000759854, certify that this material is my original work.No other person's work has been used without due acknowledgement and I have not made my work available to anyone else
//  DetailViewController.swift
//  IMDb
//
//  Created by student on 2020-12-12.
//  Copyright © 2020 Mohawkcollege. All rights reserved.
//

import UIKit

//Class that conatins the movie deatils and the class also search for a movie using api call and store the appropriate deatils into the moive class
class DetailViewController: UIViewController {
    
    //Instance movie class is  created
    var movie: Movie!
    
    //UI elemets in Detailed view controlled which is connected to UI for input/output
   
    @IBOutlet var searchField: UITextField!
    
    @IBOutlet var YearLabel: UILabel!
    
    @IBOutlet var idLabel: UILabel!
    
    @IBOutlet var LabelPlot: UITextView!
    //poster variable to store the poster URL from API
    var poster: String!
    
    //When the this view apprears this function is called set the title and checks if the selected cell has already value , if yes assign all the values to UI
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
        if movie.imdbID == "" {
              navigationItem.title = "New Movie"
          } else {
              navigationItem.title = movie.Title
              YearLabel.text = movie.Year
              idLabel.text = movie.imdbID
              LabelPlot.text = movie.Plot
              poster = movie.Poster
            searchField.text = movie.Title
            
          }
      }
    
    
    //Search button is connected to this function where the API call is taking place and all the info realted to the API call is saved
    @IBAction func SeachClicked(_ sender: UIButton) {
        
        if let input = searchField.text {
            let updated = input.replacingOccurrences(of: " ", with: "+", options: .regularExpression)

               let url = URL(string: "https://www.omdbapi.com/?t=\(updated)&plot=full&apikey=mohawk")
               let task = URLSession.shared.dataTask(with: url!) {
                   data, repsonse, error in
                   if let jsonData = data {
                       OperationQueue.main.addOperation {
                           do {
                            let decoder = JSONDecoder()
                            let movie = try decoder.decode(Movie.self, from: jsonData)
                            self.idLabel.text = "\(movie.imdbID)"
                            self.YearLabel.text = movie.Year
                            self.LabelPlot.text = movie.Plot
                            self.navigationItem.title  = movie.Title
                            self.poster = movie.Poster
                          
                           } catch {
                            self.idLabel.text = ""
                            self.YearLabel.text = "Not found"
                            self.LabelPlot.text = ""
                            self.searchField.text = ""
                            self.poster = ""
                              
                           }
                       }
                   } else {
                       print("No data")
                   }
               }
               task.resume()
           }
    }
    //When the view disappears the colleced informations are stored 
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           if YearLabel.text != "" && YearLabel.text != "Not found" {
             
            movie.Title = searchField.text!
            movie.Year = YearLabel.text!
            movie.imdbID = idLabel.text!
            movie.Plot = LabelPlot.text!
            movie.Poster = poster!
           }
       }
    
}
