//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Norbert Czirjak on 2016. 10. 02..
//  Copyright © 2016. Norbert Czirjak. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLbl.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = img
        currentEvoImg.image = img
        attackLbl.text = pokemon.attack
        
        pokemon.downloadPokemonDetail {
            
            print("itt van a cucc?")
            //a downloadPokemonDetail func ide tolti le az eredmenyeket
            // amit itt irunk meg kodot, az csak a network call complete utan fog meghivodni
            self.updateUI()
            
        }
    }
    
    func updateUI() {
        
        print("defenselbl")
        print(pokemon.defense)
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        descriptionLbl.text = pokemon.description
        pokedexLbl.text = "\(pokemon.pokedexId)"
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "No evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLbl.text = str
        }
        
        
        
        
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
