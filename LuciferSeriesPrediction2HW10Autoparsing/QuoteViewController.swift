//
//  QuoteViewController.swift
//  LuciferSeriesPrediction2HW10Autoparsing
//
//  Created by Olga Yurchuk on 16.09.2022.
//

import UIKit

class QuoteViewController: UIViewController {
    
    private var quotes: [Quote] = []
    let quoteLink = "https://lucifer-quotes.vercel.app/api/quotes"
    var imageLink = "https://images.immediate.co.uk/production/volatile/sites/3/2021/05/LUCIFER_6_TOM_ELLIS-0364e96.jpg"
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchQuote()
        
   }

    private func fetchQuote() {
        guard let url = URL(string: quoteLink) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(data)
            do {
                self.quotes = try JSONDecoder().decode([Quote].self, from: data)
            } catch let error {
                print(error.localizedDescription )
            }
            
            DispatchQueue.main.async {
                self.authorLabel.text = self.quotes[0].author
                self.quoteLabel.text = self.quotes[0].quote
                self.fetchImageAdress(author: self.quotes[0].author)
                self.fetchImage()
            }
        }.resume()
    }
    
    private func fetchImageAdress(author: String) {
        switch author {
        case "Lucifer Morningstar": imageLink = CharacterPicturesLinks.lucifer.rawValue
        case "Chloe Decker": imageLink = CharacterPicturesLinks.chloe.rawValue
        case "Amenadiel": imageLink = CharacterPicturesLinks.amenadiel.rawValue
        case "Mazikeen Smith": imageLink = CharacterPicturesLinks.mazikeen.rawValue
        case "Dan Espinoza": imageLink = CharacterPicturesLinks.dan.rawValue
        case "Linda Martin": imageLink = CharacterPicturesLinks.linda.rawValue
        case "Trixie": imageLink = CharacterPicturesLinks.trixie.rawValue
        default:
            imageLink = "https://images.immediate.co.uk/production/volatile/sites/3/2021/08/Lucifer_season_6_cast-8338d9f.jpg"
        }
    }
    
    private func fetchImage(){
        
        guard let url = URL(string: imageLink) else {return}

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("error")
                return
            }
            
            DispatchQueue.main.async {
                self.characterImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }.resume()
        
    }

}
