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
                        .padding(.leading)
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(className: "diglett", image: nil)
    }
}

