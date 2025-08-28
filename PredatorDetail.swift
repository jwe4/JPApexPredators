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
                
                // Dino image
                Image(predator.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width/1.5, height: geo.size.height/3.7)
                    .scaleEffect(x: -1)
                    .shadow(color: .black, radius: 7)
                    .offset(y: 20)
            }
            
            // Dino name
            
            // Current location
            
            // Appears in
            
            // Movie moments
            
            // Link to webpage
        }
  
    }
        .ignoresSafeArea()
    }
}

#Preview {
    PredatorDetail(predator: Predators().apexPredators[2])
//        .preferredColorScheme(.dark)
}
