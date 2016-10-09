//
//  PokeCell.swift
//  pokedex3
//
//  Created by Norbert Czirjak on 2016. 09. 28..
//  Copyright © 2016. Norbert Czirjak. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //pokemon classt tartalmazza
    var pokemon: Pokemon!
    
    // a pokecelleket lekerekitjuk
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
    }
    
    
    func configureCell(_ pokemon: Pokemon) {
        
        //pokemon object
        self.pokemon = pokemon
        
        // cell label update
        nameLbl.text = self.pokemon.name.capitalized
        // cell img update
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    
    
    
    
}
