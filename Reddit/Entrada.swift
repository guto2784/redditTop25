import Foundation
import UIKit

public struct Entrada : Decodable{
    
    public let titulo: String
    public let autor: String
    public let fechaEntrada: String
    public let thumbnail: String
    public let numComentarios: Int
    public let subreddit: String
    public let fotoThumbnail: UIImage
    
    
    public init?(json: [String: Any]) {

        guard let title: String = "title" <~~ json else{
            return nil
        }
        
        let author : String = ("author" <~~ json)!
        
        let created : Int = ("created" <~~ json)!
        
        guard let thumbnailAux: String = "thumbnail" <~~ json else{
            return nil
        }
        
        let  numComments : Int = ("num_comments" <~~ json)!
        
        let subredditAux : String = ("subreddit" <~~ json)!

        
        self.titulo = title
        self.autor = author
        
        let fecha:TimeInterval = Double(created)
        let date = Date(timeIntervalSince1970: (fecha))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY HH:mm:ss"
        let dateString = formatter.string(from: date as Date)
        
        self.fechaEntrada = dateString
        self.thumbnail = thumbnailAux
        self.numComentarios = numComments
        self.subreddit = subredditAux
        
        var fotoAux = UIImage()
        
        if let data = NSData(contentsOf: NSURL(string: thumbnailAux)! as URL)  {
            fotoAux = UIImage(data: data as Data)!
        }
        self.fotoThumbnail = fotoAux
        
    }
    
    public init?(titulo: String, autor : String, fechaEntrada: String, thumbnail: String, numComentarios: Int, subreddit: String) {
        
        self.titulo = titulo
        self.autor = autor
        self.fechaEntrada = fechaEntrada
        self.thumbnail = thumbnail
        self.numComentarios = numComentarios
        self.subreddit = subreddit
        
        var fotoAux = UIImage()
        
        if let data = NSData(contentsOf: NSURL(string: thumbnail)! as URL)  {
            fotoAux = UIImage(data: data as Data)!
        }
        self.fotoThumbnail = fotoAux
    }

    
}

