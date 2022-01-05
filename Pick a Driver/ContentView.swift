//
//  ContentView.swift
//  Pick a Driver
//
//  Created by Tom Bredemeier on 1/5/22.
//

import SwiftUI

struct ContentView: View {
    @State private var names = [String]()
    @State private var showEditList = false
    @State private var selectedName = ""
    var body: some View {
        VStack {
            Text("Pick a Driver")
                .font(.title)
                .bold()
            Button("Edit Names") {
                showEditList.toggle()
            }
            if selectedName == "" {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(125), spacing: 5), count: 3), spacing: 5, content: {
                    ForEach(names, id: \.self) { name in
                        NameView(name: name)
                    }
                })
                Spacer()
                Button("Start") {
                    selectedName = names.randomElement() ?? ""
                }
                .font(.title)
                .foregroundColor(.green)
            }
            else {
                Text(selectedName)
                    .font(.system(size: 60))
                    .fontWeight(.heavy)
                    .frame(width: 500, height: 80, alignment: .center)
                    .padding()
                Spacer()
                Button("Reset") {
                    selectedName = ""
                }
                .font(.title)
                .foregroundColor(.yellow)
            }
        }
        .background(Color.gray.opacity(0.3))
        .sheet(isPresented: $showEditList) {
            EditNamesView(names: $names)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NameView: View {
    var name: String
    var body: some View {
        ZStack {
            Color.red.opacity(0.6)
            Text(name)
                .font(.title)
        }
        .frame(width: 125, height: 40, alignment: .center)
        .cornerRadius(20)
    }
}

struct EditNamesView: View {
    @Binding var names: [String]
    @State private var name = String()
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $name, prompt: Text("Add new name"))
                    .padding()
                Button("Add") {
                    name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if name.count > 0 && !names.contains(name) {
                        names.append(name)
                        name = ""
                    }
                }
                .padding()
            }
            List {
                ForEach(names, id: \.self) { name in
                    Text(name)
                }
                .onDelete { offsets in
                    names.remove(atOffsets: offsets)
                }
            }
        }
    }
}
