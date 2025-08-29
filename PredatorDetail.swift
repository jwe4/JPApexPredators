//
//  PredatorDetail.swift
//  JPApexPredators
//
//  Created by Jim Weaver on 8/27/25.
//

import SwiftUI


struct PredatorDetail: View {
    let predator: ApexPredator
    
    var body: some View {
        GeometryReader { geo in
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                // Background image
                Image(predator.type.rawValue)
                    .resizable()
                    .scaledToFit()
                    .overlay{
                        LinearGradient(stops: [Gradient.Stop(color: .clear, location:0.8),
//                                               Gradient.Stop(color: .red, location:0.33),
//                                               Gradient.Stop(color: .blue, location:0.66),
                                               Gradient.Stop(color: .black, location:1),
                                              ], startPoint: .top, endPoint: .bottom)
                    }
                
                // Dino image
                Image(predator.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width/1.5, height: geo.size.height/3.7)
                    .scaleEffect(x: -1)
                    .shadow(color: .black, radius: 7)
                    .offset(y: 20)
            }
            VStack(alignment: .leading) {
                // Dino name
                Text(predator.name)
                    .font(.largeTitle)
                
                // Current location
                
                // Appears in
                Text("Appears In:")
                ForEach(predator.movies, id: \.self) {
                   movie  in Text("•" + movie)
                        .font(.subheadline)
                }
                
                // Movie moments
                Text("Movie Moments")
                    .font(.title)
                    .padding(.top, 15)
                
                ForEach(predator.movieScenes) {
                    scene in Text(scene.movie)
                        .font(.title2)
                        .padding(.vertical,1)
                    Text(scene.sceneDescription)
                        .padding(.bottom,15)
                }
                
                // Link to webpage
                
                Text("Read More:")
                    .font(.caption)
                Link(predator.link, destination: URL(string: predator.link)!)
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            .padding()
            .padding(.bottom)
            .frame(width: geo.size.width, alignment: .leading)
        }
  
    }
        .ignoresSafeArea()
    }
}

#Preview {
    PredatorDetail(predator: Predators().apexPredators[2])
        .preferredColorScheme(.dark)
}
