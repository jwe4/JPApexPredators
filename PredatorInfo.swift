//
//  PredatorInfo.swift
//  JPApexPredators
//
//  Created by YourName on 9/4/25.
//

import SwiftUI
import MapKit

struct PredatorInfo: View {
    let predator: ApexPredator

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: predator.type.icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .offset(x: -5, y: -5)
                    }
                    .background(predator.type.background)

                VStack(alignment: .leading, spacing: 16) {
                    Text(predator.name)
                        .font(.largeTitle)
                        .bold()

                    Text("Movies")
                        .font(.title3)
                        .bold()
                        .padding(.top, 8)

                    ForEach(predator.movieScenes) { scene in
                        Text(scene.movie)
                            .bold()
                        Text(scene.sceneDescription)
                            .italic()
                            .padding(.bottom, 8)
                    }

                    Text("Link to more info")
                        .font(.title3)
                        .bold()

                    Link(predator.link, destination: URL(string: predator.link)!)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .ignoresSafeArea()
        .toolbarBackground(.automatic)
    }
}

struct PredatorInfo_Previews: PreviewProvider {
    static var previews: some View {
        PredatorInfo(predator: Predators().apexPredators[2])
            .preferredColorScheme(.dark)
    }
}
