//
//  ViewController.swift
//  pokedex3
//
//  Created by Norbert Czirjak on 2016. 09. 28..
//  Copyright © 2016. Norbert Czirjak. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    // csinalunk egy tombot es inicializaljuk is
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    //ures tombkent inicializaljuk
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let charmander = Pokemon(name: "charmender", pokedexId: 4)
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
        
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            // loop
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    // parse a pokemon.csv es olyan formaba rakja amit tudunk jhasznalni
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType:"csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            
            for row in rows {
                
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                // a pokemon class initjevel letrehozzuk a pokemon objektumokat
                let poke = Pokemon(name: name, pokedexId: pokeId)
                //es a fent letrehozott pokemon tombbe beledobjuk
                pokemon.append(poke)
                
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //nem akarjuk h mind a 700at betoltse mert attol elszallna a progi
        // a dequeuereusablecell kiszedi a kepernon ktualisan megjelenithetot
        // es scrollozasnal betolti majd a kovetkezo adagot
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            //pokemon object
            //let pokemon = Pokemon(name: "Puki", pokedexId: indexPath.row)
            //let poke = pokemon[indexPath.row]
            
            //de a seacrhbar miatt ezt atirjuk
            let poke: Pokemon!
            
            if inSearchMode {
                // searchmodban pedig a filterezett tombot hasznaljuk
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            }
            else {
                //az eredeti tombot hasznaljuk ha nem search modban vagyunk
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
            
            // a PokeCell.swiftben definialt cellat meghivjuk es az itt letrehozott pokemon objektumot atadjuk neki
            // az objektumbol pedig kiszedi az adatokat a megjeleniteshez
            //cell.configureCell(pokemon)
            //search bar miatt ezt kiszedjuk es atkerul az else be
            //cell.configureCell(poke)
            
            
            return cell
        } else {
            // ha nem tudja kiszedni akkor egy ures collectionviewet adunk vissza
            return UICollectionViewCell()
        }
        
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Pokemon objekt alapu valtozot hoztunk letre
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        
        
    }
    

    // mennyi objektum van a collection viewben
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }else {
            return pokemon.count
        }
        
    }
    //hany szekciot tartalmaz a collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // cellak meretet segite definialni
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    // elrejteni a keyboardor
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // ha irunk a earchbarba akkor ez meghivodik
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            // keyboard hiding
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            //az eredeti pokemon listat filterezzuk
            // $0 az egy placeholder a pokemon object tartalmara
            // es ezeknek vesszuk a name valujat
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            // frissitjuk  a tablat
            collection.reloadData()
        }
        
        
    }
    
    // adatkuldesekhez kell a viewcontrollerek kozott
    // tehat a segueben anyobjectet fogunk kuldeni
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ha a seque identifier a pokemondetailvc
        if segue.identifier == "PokemonDetailVC" {
            // ha a seguq destnationje az a pokemondetailvc
            if let detailsVC = segue.destination as? PokemonDetailVC {
                // ha a sender tipusa pokemon osztaly
                if let poke = sender as? Pokemon {
                    // a detailsvc-ben levo pokemon valtozonak adjuk a poke erteket
                    detailsVC.pokemon = poke
                }
            }
        }
    }


}

