//
//  CodeVerifierViewModel.swift
//  PhotoWorld
//
//  Created by Stepan Ostapenko on 18.04.2023.
//

import Foundation

enum CodeLabelState: Identifiable {
    var id: UUID {
        UUID()
    }
    
    case error(text: String)
    case filled(text: String)
    case empty
    case prompting
    
    var textLabel: String {
        switch self {
        case .filled(text: let text), .error(text: let text):
            return text
        default:
            return ""
        }
    }
    
    var showingError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
    
    var prompting: Bool {
        switch self {
        case .prompting:
            return true
        default:
            return false
        }
    }
}

class SecureCodeVerifierViewModel: ObservableObject {
    @Published var fields: [CodeLabelState] = []
    @Published var codeCorrect: Bool = false

    let fieldNumber: Int
    
    init(fieldNumber: Int) {
        self.fieldNumber = fieldNumber
        fields = [.prompting] + Array(repeating: .empty, count: fieldNumber - 1)
    }
    
    func buildFields(for code: String) {
        guard !code.isEmpty else {
            let empty: [CodeLabelState] = Array(repeating: .empty, count: fieldNumber - 1)
            fields = [.prompting] + empty
            return
        }
        let remainingLabel = fieldNumber - code.count
        let filledField = code.map { CodeLabelState.filled(text: "\($0)") }
        
        guard remainingLabel > 0 else {
            codeCorrect = fieldNumber == code.count
            fields = codeCorrect ? filledField : code.map { CodeLabelState.error(text: "\($0)") }
            return
        }
        fields = filledField + [.prompting] + Array(repeating: .empty, count: remainingLabel - 1)
    }
    
}
