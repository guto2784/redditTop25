//
//  ViewController.swift
//  Reddit
//
//  Created by Augusto Valdez Barrios on 22/3/17.
//  Copyright © 2017 isy. All rights reserved.
//

import UIKit


class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var HUD: MBProgressHUD = MBProgressHUD()
    
    var entradas:[Entrada] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = Utils.sharedInstance.hexStringToUIColor(hex: "#66ccff")
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes =  [
            NSForegroundColorAttributeName : UIColor.white,
        ]
        
        self.navigationController!.navigationBar.isTranslucent = false
        
        entradas = BDManager.sharedInstance.obtenerEntradas()
       
        if entradas.count > 0 {
             tableView.reloadData()
        }else{
             obtenerEntradasReddit()
        }
    }
    
    func obtenerEntradasReddit(){
        
        self.HUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.HUD.label.text = "procesando..."
        
        DataManager.getTop25EntriesFromRedditWithSuccess { (data) -> Void in
            
            // 1
            var json: Any
            let dictionary:[String: Any]
            do {
                json = try JSONSerialization.jsonObject(with: data)
                
                dictionary = json as! [String: Any]
                if let nestedDictionary = dictionary["data"] as? [String: Any] {
                    
                    if let childrenDictionaryList = nestedDictionary["children"] as? [[String: Any]]{
                        
                        self.entradas = []
                        
                        for  currentChild  in childrenDictionaryList{
                            if let entrada = currentChild["data"] as? [String: Any] {
                                let entry = Entrada(json: entrada)
                                
                                print("Titulo: \(entry!.titulo)")
                                print("Autor: \(entry!.autor)")
                                print("fechaEntrada: \(entry!.fechaEntrada)")
                                print("thumbnail: \(entry!.thumbnail)")
                                print("numComentarios: \(entry!.numComentarios)")
                                print("subreddit: \(entry!.subreddit)")
                                
                                self.entradas.append(entry!)
                                
                            }
                        }
                        print("MOSTRANDO RESULTADOS.......")
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.guardarEntradas()
                            self.tableView.reloadData()
                        }
                    }
                }
                
            } catch {
                MBProgressHUD.hide(for: self.view, animated: true)
                print(error)
            }
            
        }
    }
    
    func guardarEntradas(){
        
        //borrar todas las entradas primero
        BDManager.sharedInstance.borrarEntradas()
        var i = 0
        for  entradaActual in entradas {
            i+=1
            BDManager.sharedInstance.insertarEntrada(idEntrada: i, entrada: entradaActual)
        }
    }
    
    @IBAction func refreshEntradas(_ sender: UIBarButtonItem) {
        
        DispatchQueue.main.async {
            self.obtenerEntradasReddit()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return entradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contentCell = tableView.dequeueReusableCell(withIdentifier: "EntradaCell", for: indexPath as IndexPath) as! EntradaCell
        
        let entrada =  entradas[indexPath.row]
        let index = indexPath.row + 1
        contentCell.entradaNro.text = index.description
        contentCell.titulo.text = entrada.titulo
        contentCell.autor.text = "por " + entrada.autor
        
        contentCell.thumbnail.image = entrada.fotoThumbnail
        contentCell.comentarios.text = entrada.numComentarios.description + " comentarios"
        contentCell.fecha.text = entrada.fechaEntrada
        contentCell.subreddit.text = "a r/" + entrada.subreddit
        
        return contentCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

