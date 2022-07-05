//
//  Pokemon.swift
//  SwiftCamera
//
//  Created by dev on 2022/02/12.
//

import Foundation

struct Pokemon {
    var no: Int = 0
    var name: String = ""
    var category: String = ""
    var type: String = ""
    var height: Float = 0
    var weight: Float = 0
    var caption: String = ""
    
    init?(className: String) {
        switch className {
        case "bulbasaur":
            self.no = 1
            self.name = "フシギダネ"
            self.category = "たねポケモン"
            self.type = "くさ / どく"
            self.height = 0.7
            self.weight = 6.9
            self.caption = "うまれたときから　せなかに　しょくぶつの　タネが　あって　すこしずつ　おおきく　そだつ。"
        case "diglett":
            self.no = 50
            self.name = "ディグダ"
            self.category = "もぐらポケモン"
            self.type = "じめん"
            self.height = 0.2
            self.weight = 0.8
            self.caption = "ディグダの　とおったあとの　だいちは　ほどよく　たがやされて　さいこうの　はたけに　なる。"
        case "porygon":
            self.no = 137
            self.name = "ポリゴン"
            self.category = "バーチャルポケモン"
            self.type = "ノーマル"
            self.height = 0.8
            self.weight = 36.5
            self.caption = "さいこうの　かがくりょくを　つかい　せかいで　はじめて　プログラムにより　つくられた　じんこうの　ポケモン。"
        default:
            break
        }
    }
}
