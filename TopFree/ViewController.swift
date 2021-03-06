//
//  ViewController.swift
//  TopFree
//
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var session: NSURLSession?
    
    @IBOutlet weak var appIconImageView: UIImageView!
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        
        //cria um configuracao de sessao default
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //cria uma sessao com a configuracao default
        session = NSURLSession(configuration: sessionConfig)

        //URL de acesso a API do itunes, que retorna o aplicativo gratuito no topo do ranking na app store
        var url = NSURL (string:"https://itunes.apple.com/br/rss/topfreeapplications/limit=1/json")
        
        //definição da task que faz umq requisição para saber qual app gratuito está melhor no ranking
        var task = session!.dataTaskWithURL(url!,
                           completionHandler: {
                                (data: NSData!, response:NSURLResponse!, error: NSError!) -> Void in
                            
                            //ações efetuadas quando a execução da task se completa
                            
                            let string = NSString(data: data, encoding: NSUTF8StringEncoding)

                            println(string)
                            
                            if let appName = self.getTopFreeAppName(data){
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.appNameLabel.text = appName
                                })
                            }
                            
                            if let appImageURL = self.getTopFreeAppImage(data){
                                
                                self.downloadAppImage(appImageURL)
                                
                            }


                            
        })
        
        //disparo da execução da task
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getTopFreeAppName(data: NSData) -> String? {
        
        var jsonError: NSError?
        
        //cria um dicionario [String:AnyObject] do JSON
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)  as? [String:AnyObject]{
            
            //permite leitura dos valore do JSON...
            
            //tenta criar um dicionario a partir da chave "feed"
            if let feed = json["feed"] as? [String:AnyObject] {
                
                if let entry = feed["entry"] as? [String:AnyObject] {
                    
                    if let name = entry["im:name"] as? [String:AnyObject]{
                        
                        if let label = name["label"] as? String{
                            
                            return label
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func getTopFreeAppImage(data: NSData) -> String? {
        
        var jsonError: NSError?
        
        //cria um dicionario [String:AnyObject] do JSON
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)  as? [String:AnyObject]{
            
            //permite leitura dos valore do JSON...
            
            //tenta criar um dicionario a partir da chave "feed"
            if let feed = json["feed"] as? [String:AnyObject] {
                
                if let entry = feed["entry"] as? [String:AnyObject] {
                    
                    if let name = entry["im:image"] as? [AnyObject]{
                        
                        if let image = name[2] as? [String: AnyObject]{
                            
                            if let label = image["label"] as? String{
                                return label
                            }
                            
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /**
    Função que configura uma task para donwload de imagem do URL do parâmetro
    */
    func downloadAppImage(imageURL : String) {
        
        let url = NSURL (string: imageURL)
        
        //outra maneira de criar uma sessao
        //retorna um singleton (sessao compartilhada)
        var imageSession = NSURLSession.sharedSession()
        
        //cria uma task do tipo download
        var imageTask = imageSession.downloadTaskWithURL(url!) {
            (url: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            //recebe o binário da imagem
            if let imageData = NSData(contentsOfURL: url){
                
                //transforma o binario em UIImage e atualiza a tela na thread principal
                
                dispatch_async(dispatch_get_main_queue() , {
                    self.appIconImageView.image = UIImage(data: imageData)
                })
                
            }
        }
        imageTask.resume()
    }

    
}

