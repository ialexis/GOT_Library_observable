//
//  PersonasVM.swift
//  GOT_Library
//
//  Created by Ivan Alexis Abad on 2/13/24.
//

import SwiftUI

final class PelisVM:ObservableObject {
    
    @Published var movies: [peli] = []
    
    @MainActor func getAllMovies() {
        Task {
            do {
                movies = try await Network.shared.getAllMovies().results
                
            }
        }
    }
}
