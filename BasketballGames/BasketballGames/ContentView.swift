//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        VStack {
            Text("UNC Basketball")
                .font(.largeTitle)
                .fontWeight(.bold)
            List(results, id: \.id) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(item.team) vs. \(item.opponent)")
                        Text("\(item.date)")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(item.score.unc) - \(item.score.opponent)")
                        item.isHomeGame ? Text("Home") : Text("Away")
                            .font(.subheadline)
                    }
                }
            }
            .listStyle(.plain)
            .task {
                await loadData()
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data)
            {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
