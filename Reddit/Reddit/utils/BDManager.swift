//
//  BDManager.swift
//  Reddit
//
//  Created by Augusto Valdez Barrios on 25/4/17.
//  Copyright © 2017 isy. All rights reserved.
//

import UIKit

class BDManager: NSObject {
    
    static let sharedInstance = BDManager()
    
    var databasePath = NSString()
    
    func crearBD(){
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        
        let docsDir = dirPaths[0]
        
        databasePath = (docsDir as NSString).appendingPathComponent("REDDIT_DB.db") as NSString

        let redditDB = FMDatabase(path: databasePath as String)
        
        if redditDB == nil {
            print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
        }
        
        
        if (redditDB?.open())! {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS ENTRADA(id_entrada INTEGER PRIMARY KEY, titulo varchar(200), autor varchar(30), fecha_entrada varchar(50), thumbnail varchar(200), num_comentarios INTEGER, subrredit varchar(30))"
            if !(redditDB?.executeStatements(sql_stmt))! {
                print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
            }
            redditDB?.close()
        } else {
            print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
        }
        
    }
    
    
    func obtenerEntradas() -> [Entrada]{
        
        let redditDB = FMDatabase(path: databasePath as String)
        var entradasList:[Entrada] = []
        
        let maximo = "25"
        
        if (redditDB?.open())! {
            let querySQL = "SELECT id_entrada, titulo, autor, fecha_entrada, thumbnail, num_comentarios, subrredit FROM ENTRADA order by id_entrada DESC limit \(maximo)"
            let results:FMResultSet? = redditDB?.executeQuery(querySQL,
                                                              withArgumentsIn: nil)
            
            while results?.next() == true {
                
                let tituloBD = results!.string(forColumn: "titulo")!
                let autorBD = results!.string(forColumn: "autor")!
                let fechaEntradaBD = results!.string(forColumn: "fecha_entrada")!
                let thumbnailBD = results!.string(forColumn: "thumbnail")!
                let numComentariosBD = results!.int(forColumn: "num_comentarios")
                let subrreditBD = results!.string(forColumn: "subrredit")!
    
                let entradaActual = Entrada(titulo: tituloBD, autor: autorBD, fechaEntrada: fechaEntradaBD, thumbnail: thumbnailBD, numComentarios: Int(numComentariosBD), subreddit: subrreditBD)
                entradasList.append(entradaActual!)
            }
            
            redditDB?.close()
        } else {
            print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
        }
        
        return entradasList
    }
    
    func insertarEntrada(idEntrada : Int, entrada : Entrada){
        
        let redditDB = FMDatabase(path: databasePath as String)
        
        if (redditDB?.open())! {
            
            print(entrada.titulo)
            let tituloAux = entrada.titulo.replacingOccurrences(of: "'", with: "`")
            
            let insertSQL = "INSERT INTO ENTRADA (id_entrada, titulo, autor, fecha_entrada, thumbnail, num_comentarios, subrredit) VALUES (\(idEntrada),  '\(tituloAux)', '\(entrada.autor)', '\(entrada.fechaEntrada)', '\(entrada.thumbnail)', \(entrada.numComentarios), '\(entrada.subreddit)')"
            
            
            let result = redditDB?.executeUpdate(insertSQL, withArgumentsIn: nil)
            
            if !result! {
                print("Failed to add ENTRADA")
                print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
            } else {
                print("entrada Added")
                
            }
            redditDB?.close()
        } else {
            print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
        }
    }
    
    func borrarEntradas(){
        
        let redditDB = FMDatabase(path: databasePath as String)
        
        if (redditDB?.open())! {
            
            let deleteSQL = "DELETE FROM ENTRADA"
            
            let result = redditDB?.executeUpdate(deleteSQL,
                                                 withArgumentsIn: nil)
            
            if !result! {
                print("Failed to delete ENTRADA")
                print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
            } else {
                print("deleted ENTRADA")
                
            }
            redditDB?.close()
        } else {
            print("Error: \(String(describing: redditDB?.lastErrorMessage()))")
        }

    }


}
