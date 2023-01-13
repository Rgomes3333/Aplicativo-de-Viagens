//
//  DecodableData.swift
//  AluraViagens
//
//  Created by Ândriu Felipe Coelho on 28/01/21.
//

import Foundation

let sessaoDeViagens: [ViagemViewModel]? = load("server-response.json")

func load(_ filename: String) -> [ViagemViewModel]? {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError("error to read json dictionary")
        }
        
        guard let listaDeViagens = json["viagens"] as? [String: Any] else {
            fatalError("error to read travel list")
        }
        
        guard let jsonData = TiposDeViagens.jsonToData(listaDeViagens) else { return nil }
        
        let tiposDeViagens = TiposDeViagens.decodeJson(jsonData)//le fo json o que estamos trazendo
        
        var listaViagemViewModel: [ViagemViewModel] = []
        
        for sessao in listaDeViagens.keys {
            switch ViagemViewModelType(rawValue: sessao)  {
            case .destaques: //verificando o tipo
                if let destaques = tiposDeViagens?.destaques {//criando a viewmodel
                    let destaqueViewModel = ViagemDestaqueViewModel(destaques)
                    listaViagemViewModel.insert(destaqueViewModel, at: 0)
                }
                //criando ViewModel Ofertas
            case .ofertas:
            if let ofertas = tiposDeViagens?.ofertas {
                let ofertaViewModel = ViagemOfertaViewModel(ofertas)
                listaViagemViewModel.append(ofertaViewModel)
            }
            
            
            default:
                break
            }
        }
        
        return listaViagemViewModel
    } catch {
        fatalError("Couldn't parse")
    }
}
