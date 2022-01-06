//
//  NameDisplayView.swift
//  Pick a Driver
//
//  Created by Tom Bredemeier on 1/5/22.
//

import SwiftUI

struct NameDisplayView: View {
    private var period: String
    private let timer = Timer.publish(every: 2, on: .current, in: .common).autoconnect()
    @ObservedObject var dataStore: DataStore
    @State private var showEditList = false
    @State private var timerStarted = false
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
                    ForEach($dataStore.students) { $student in
                        NameView(student: $student)
                    }
                })
                Spacer()
                if timerStarted {
                    Button("Stop") {
                        timerStarted.toggle()
                    }
                    .font(.title)
                    .foregroundColor(.red)
                }
                else {
                    Button("Start") {
                        for index in dataStore.students.indices {
                            if dataStore.students[index].tapped {
                                dataStore.students[index].eliminated = true
                            }
                        }
                        timerStarted.toggle()
                    }
                    .font(.title)
                    .foregroundColor(.green)
                }
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
                    for index in dataStore.students.indices {
                        if dataStore.students[index].eliminated {
                            dataStore.students[index].eliminated = false
                        }
                    }
                }
                .font(.title)
                .foregroundColor(.yellow)
            }
        }
        .onReceive(timer) { _ in
            if timerStarted {
                var eligibles = [Student]()
                for student in dataStore.students {
                    if !student.tapped && !student.eliminated {
                        eligibles.append(student)
                    }
                }
                if eligibles.count > 1 {
                    let eliminatedStudentID = eligibles.randomElement()!.id
                    for index in dataStore.students.indices {
                        if dataStore.students[index].id == eliminatedStudentID {
                            dataStore.students[index].eliminated = true
                        }
                    }
                }
                else {
                    timerStarted = false
                    if eligibles.count == 1 {
                        selectedName = eligibles.first!.name
                    }
                    else {
                        selectedName = " "
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.3))
        .sheet(isPresented: $showEditList) {
            EditNamesView(students: $dataStore.students)
        }
        .navigationBarTitle("\(period) Period", displayMode: .inline)
    }
    
    init(period: String) {
        self.period = period
        dataStore = DataStore(period: period)
    }
}

struct NameDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        NameDisplayView(period: "1st")
    }
}

struct NameView: View {
    @Binding var student: Student
    var body: some View {
        ZStack {
            Color.red.opacity(0.6)
            Text(student.name)
                .font(.title)
                .onTapGesture {
                    student.tapped.toggle()
                }
                .opacity(student.eliminated ? 0 : student.tapped ? 0.3 : 1.0)
        }
        .frame(width: 125, height: 40, alignment: .center)
        .cornerRadius(20)
    }
}

struct EditNamesView: View {
    @Binding var students: [Student]
    @State private var name = String()
    var body: some View {
        VStack {
            HStack {
                TextField("Name", text: $name, prompt: Text("Add new name"))
                    .padding()
                Button("Add") {
                    name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if name.count > 0 {
                        students.append(Student(name: name))
                        name = ""
                    }
                }
                .padding()
            }
            List {
                ForEach(students) { student in
                    Text(student.name)
                }
                .onMove(perform: { source, destination in
                    students.move(fromOffsets: source, toOffset: destination)
                })
                .onDelete { offsets in
                    students.remove(atOffsets: offsets)
                }
            }
        }
        .environment(\.editMode, .constant(.active))
    }
}

