//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Dante Cesa on 3/4/22.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText: String = ""
    @State private var selectedSort: String = "Alphabetical"
    let sorts: [String] = ["Alphabetical", "Country", "Favorites"]
    
    @StateObject var favorites: Favorites = Favorites()
    
    var body: some View {
        NavigationView {
            List {
                Picker("Sort Order", selection: $selectedSort) {
                    ForEach(sorts, id:\.self) { sort in
                        Text(sort)
                    }
                }
                .pickerStyle(.segmented)
                
                ForEach(filteredResorts) { resort in
                    NavigationLink {
                        ResortView(resort: resort)
                    } label: {
                        HStack {
                            Image(resort.country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .shadow(radius: 2)
                            
                            VStack(alignment: .leading) {
                                Text(resort.name)
                                    .font(.headline)
                                Text("\(resort.runs) runs")
                                    .foregroundColor(.secondary)
                            }
                            
                            if favorites.contains(resort) {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        if favorites.contains(resort) {
                            Button(action: {
                                favorites.remove(resort)
                            }, label: {
                                Text("Unfavorite")
                                    .foregroundColor(.primary)
                            })
                                .tint(.gray)
                        } else {
                            Button(action: {
                                favorites.add(resort)
                            }, label: {
                                Text("Favorite")
                                    .foregroundColor(.primary)
                            })
                                .tint(.yellow)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort…")
            
            WelcomeView()
        }
        .environmentObject(favorites)
        .phoneOnlyStackNavigationView()
    }
    
    var filteredResorts: [Resort] {
        var results: [Resort] = []
        
        if searchText.isEmpty {
            results = resorts
        } else {
            results = resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if selectedSort == "Alphabetical" {
            results.sort { $0.name < $1.name }
        } else if selectedSort == "Country" {
            results.sort { $0.country < $1.country }
        } else if selectedSort == "Favorites" {
            var tempFavorites: [Resort] = []
            var notFavorites: [Resort] = []
            
            for resort in resorts {
                if favorites.contains(resort) {
                    tempFavorites.insert(resort, at: 0)
                } else {
                    notFavorites.insert(resort, at: 0)
                }
            }
            tempFavorites.sort { $0.name < $1.name }
            notFavorites.sort { $0.name < $1.name }
            
            results = tempFavorites + notFavorites
        }
        
        return results
    }
}
 
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
