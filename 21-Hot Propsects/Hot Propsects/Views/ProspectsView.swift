//
//  ProspectsView.swift
//  Hot Propsects
//
//  Created by Aarav Sinha on 09/07/24.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    @Environment(\.editMode) var editMode
    
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()
    
    var body: some View {
        List(prospects, selection: $selectedProspects) { prospect in
            NavigationLink {
                EditView(prospect: prospect)
            } label: {
                HStack {
                    if filter == .none {
                        Image(systemName: prospect.isContacted ? "person.crop.circle.fill.badge.checkmark" : "person.crop.circle.fill.badge.xmark")
                    }
                    
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary	)
                    }
                }
            }
            .onAppear {
                selectedProspects = []
            }
            .swipeActions(edge: .trailing) {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    modelContext.delete(prospect)
                }
                if prospect.isContacted {
                    Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.blue)
                } else {
                    Button("Mark Contacted ", systemImage: "person.crop.circle.fill.badge.checkmark") {
                        prospect.isContacted.toggle()
                    }
                    .tint(.green)
                }
            }
            .swipeActions(edge: .leading) {
                Button("Remind Me", systemImage: "bell") {
                    addNotification(for: prospect)
                }
                .tint(.orange)
            }
            .tag(prospect)
        }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
                
                if selectedProspects.isNotEmpty {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Delete Selected", action: delete)
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
        
    }
    
    init(filter: FilterType, sortOrder: [SortDescriptor<Prospect>], searchBy: String) {
        self.filter = filter
        
        if filter != .none {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate<Prospect> { prospect in
                prospect.isContacted == showContactedOnly && (searchBy.isEmpty || prospect.name.localizedStandardContains(searchBy))
            }, sort: sortOrder)
        } else {
            _prospects = Query(filter: #Predicate<Prospect> { prospect in
                (searchBy.isEmpty || prospect.name.localizedStandardContains(searchBy))
            }, sort: sortOrder)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(person)
            
        case .failure(let error):
            print("Scan failed: \(error)")
        }
    }
    
    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content =  UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error{
                        print(error)
                    }
                }
            }
            
        }
    }
}

extension Collection {
    var isNotEmpty: Bool {
        isEmpty == false
    }
}
#Preview {
    ProspectsView(filter: .none, sortOrder: [SortDescriptor(\Prospect.name)], searchBy: "")
}
