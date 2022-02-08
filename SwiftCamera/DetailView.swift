//
//  DetailView.swift
//  SwiftCamera
//
//  Created by dev on 2022/01/28.
//

import SwiftUI

struct DetailView: View {
    let className: String
    let image: UIImage?
    
    var body: some View {
        let pokemon = Pokemon(className: self.className)
        
        VStack{
            HStack{
                Spacer()
                Spacer()
                if self.image != nil {
                    Image(uiImage: self.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100, alignment: .trailing)
                } else {
                    Rectangle()
                        .fill(.black)
                        .frame(width: 100, height: 100, alignment: .trailing)
                        .padding(.leading)
                }
                List {
                    Text("No. " + String(format: "%03d", pokemon!.no))
                    Text(pokemon!.name)
                    Text(pokemon!.category)
                    HStack{
                        Text("タイプ")
                        Spacer()
                        Text(pokemon!.type)
                    }
                    HStack{
                        Text("たかさ")
                        Spacer()
                        Text(String(pokemon!.height) + " m")
                    }
                    HStack{
                        Text("おもさ")
                        Spacer()
                        Text(String(pokemon!.weight) + " kg")
                    }
                }
                .background(.white)
                .onAppear {
                    UITableView.appearance().backgroundColor = .white
                }
            }
            .frame(width: 400, height: 320, alignment: .center)
            Text(pokemon!.caption)
                .padding(.all)
        }
        .padding(.all)
    }
}

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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(className: "diglett", image: nil)
    }
}

