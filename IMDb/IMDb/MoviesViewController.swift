//I, Johns Varughese Meppurath, student number 000759854, certify that this material is my original work.No other person's work has been used without due acknowledgement and I have not made my work available to anyone else
//  MoviesViewController.swift
//  IMDb
//
//  Created by student on 2020-12-11.
//  Copyright © 2020 Mohawkcollege. All rights reserved.
//

import UIKit
//The class that hold the CollectionView and related logic
class MoviesViewController: UICollectionViewController,UIImagePickerControllerDelegate {
    //instance of imgaestore class
    let imageStore = ImageStore()

   enum PhotoError: Error {
       case imageCreationError
       case missingImageURL
   }
   //when the page is loaded this function will be called and the view will be loaded
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //declare movie array to store the Movies
    var movies = [Movie]()
    //URLsession variable which will be used to get the poster image from image url
   private let session: URLSession = {
          let config = URLSessionConfiguration.default
          return URLSession(configuration: config)
      }()
  //function to return the number of collection view items
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    //collection view cell is created with the default image and when the url for the orginal poster is provided the function will get the image using session task and display as the poster and if the poster image is not avilabel the dealft image is displayed.  Also the imagestore class is used to store the new image and if the image is alredy in the imagestore the function will make use of the stored image.
      override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        if movies[indexPath.row].Title == "New Movie" || movies[indexPath.row].Poster == "N/A" {
            cell.MovieImage.image = UIImage(named: "movie_reel")
            
          
        }else{
              let fileUrl = URL(string: movies[indexPath.row].Poster)
            let photoKey = movies[indexPath.row].imdbID
            if let image = imageStore.image(forKey: photoKey) {
                OperationQueue.main.addOperation {
                  cell.MovieImage.image = image
                }
                
                
            }else{
                       let request = URLRequest(url: fileUrl!)
                     //  print("here")
                           let task = session.dataTask(with: request) {
                               (data, response, error) in
                               
                               let result = self.processImageRequest(data: data,
                                                                     error: error)
                               if case let .success(image) = result {
                                 self.imageStore.setImage(image, forKey: photoKey)
                                    OperationQueue.main.addOperation {
                                   cell.MovieImage.image = image
                                   }
                               }
                           }
                       task.resume()
            }
        }
        
        return cell
    }
    //return the processed image from the passed data variable
    private func processImageRequest(data: Data?,
                                     error: Error?) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }



    
    
    //New moive is added to the array . This function is connected to the Add button in UI
    @IBAction func newMovie(_ sender: UIBarButtonItem) {
       // let img = UIImage(named: "movie_reel")
               let movie = Movie()
               movies.append(movie)
              
        //collectionView?.reloadData()
              let indexPath = IndexPath(row: movies.count - 1, section: 0)
               collectionView.insertItems(at: [indexPath])
    }
    
    
    
    
    //Show Segue is defined for each UI collection view . The movie details for the seclected item is passed to the view controller
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if let cell = sender as? UICollectionViewCell,
                let indexPath = self.collectionView.indexPath(for: cell) {
                 // print(indexPath.row)
                //print(movies[indexPath.row].Poster)
                let movie = movies[indexPath.row]
                                      let detailViewController = segue.destination as! DetailViewController
                               detailViewController.movie = movie
            }
        

        
          
            }
    //when the app returns to the main page this function is called and all the updated information will be showen in the UI
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
}



