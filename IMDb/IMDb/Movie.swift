//
//  Movie.swift
//  IMDb
//
//  Created by student on 2020-12-11.
//  Copyright © 2020 Mohawkcollege. All rights reserved.
//

import UIKit
//Movie class to store and initialize the movie variables 
class Movie:Codable {
    var Title: String
    var Year: String
    var Plot: String
    var Poster: String
    var imdbID: String
    
    //initializng the variables
       init() {
           self.Title = "New Movie"
           self.Year = ""
           self.Plot = ""
           self.Poster = ""
           self.imdbID = ""
          
       }
       

    
}
