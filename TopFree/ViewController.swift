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
                            
        })
        
        //disparo da execução da task
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

