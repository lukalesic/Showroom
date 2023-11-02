//
//  ContentView.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI
import RealityKit
import RealityKitContent
import FirebaseFirestore

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var entryText = ""

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    let database = Firestore.firestore()
    @State private var documents: [DocumentSnapshot] = []

    var body: some View {
        VStack {
            Text("Welcome to Showroom!")

            TextField("textfield", text: $entryText)
            
            // Display the list of documents
                    List(documents, id: \.documentID) { document in
                        Text(document.data()?["test"] as? String ?? "No data")
                    }
                    .onAppear {
                        // Fetch the documents when the view appears
                        fetchDocuments()
                    }
            
            Button {
                write(entryText)
                fetchDocuments()
            } label: {
                Text("save")
            }

            Model3D(named: "AirForce") { phase in
                if let model = phase.model {
                    model.resizable()
                } else if let error = phase.error {
                    Text("ERROR: \(error.localizedDescription)")
                } else {
                   VStack {
                    Text("Loading")
                    ProgressView()
                }
                }
            }
            
            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
    
    func write(_ text: String) {
        let ref = database.collection("test").addDocument(data: ["test": text])

    }
    
    func fetchDocuments() {
        let collectionRef = database.collection("test")
        
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = snapshot?.documents {
                    self.documents = documents
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
