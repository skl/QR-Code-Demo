//
//  Token.swift
//  QR Code Demo
//
//  Created by Stephen Lang on 17/04/2020.
//  Copyright © 2020 Kaizen Digital. All rights reserved.
//

import SwiftUI
import OneTimePassword

extension Token {
    init(name: String = "", issuer: String = "", factor: Generator.Factor) {
        // swiftlint:disable:next force_unwrapping
        let generator = Generator(factor: factor, secret: Data(), algorithm: .sha1, digits: 6)!
        self.init(name: name, issuer: issuer, generator: generator)
    }
}

class TokenDecorator: Equatable, Identifiable {
    let id: String
    var identifier: Data?
    var token: Token
    
    init(token: Token, identifier: Data?) {
        do {
            try self.id = token.toURL().absoluteString
        } catch {
            self.id = UUID().uuidString
        }
        self.token = token
        self.identifier = identifier
    }
    
    convenience init(persistentToken: PersistentToken) {
        self.init(token: persistentToken.token, identifier: persistentToken.identifier)
    }
    
    static func == (lhs: TokenDecorator, rhs: TokenDecorator) -> Bool {
        return lhs.id == rhs.id && lhs.identifier == rhs.identifier
    }
}

class Tokens: ObservableObject {
    @Published var tokens: [TokenDecorator]
    private let keychain: Keychain
    
    init(keychain: Keychain) {
        self.tokens = []
        self.keychain = keychain
        
        do {
            let persistentTokens = try keychain.allPersistentTokens()
            print("Found \(persistentTokens.count) tokens in keychain")
            
            for pt in persistentTokens {
                self.append(token: TokenDecorator(persistentToken: pt), persist: false)
            }
        } catch {
            print("Keychain error on init: \(error)")
        }
    }
    
    func append(token: TokenDecorator, persist: Bool = false) {
        self.tokens.append(token)
        self.tokens.sort {
            $0.id < $1.id
        }
        
        if persist {
            self.persist();
        }
    }
    
    func remove(atOffsets: IndexSet) {
        for idx in atOffsets {
            let t = self.tokens[idx]
            if t.identifier == nil {
                print("Could not delete token, identifier is nil:  \(t.token.issuer):\(t.token.name)")
            } else {
                do {
                    if let pt = try self.keychain.persistentToken(withIdentifier: t.identifier!) {
                        try self.keychain.delete(pt)
                        print("Token deleted: \(t.token.issuer):\(t.token.name)")
                        self.tokens.remove(at: idx)
                    }
                } catch {
                    print("Keychain error on delete: \(error)")
                }
            }
        }
    }
    
    func persist() {
        for t in self.tokens {
            if t.identifier == nil {
                do {
                    let pt = try self.keychain.add(t.token)
                    t.identifier = pt.identifier
                    print("Token saved: \(t.token.issuer):\(t.token.name)")
                } catch {
                    print("Keychain error on add: \(error)")
                }
            } else {
                do {
                    if let pt = try self.keychain.persistentToken(withIdentifier: t.identifier!) {
                        let before = TokenDecorator(token: t.token, identifier: t.identifier)
                        let after = TokenDecorator(persistentToken: pt)
                        
                        if before != after {
                            let upt = try self.keychain.update(pt, with: t.token)
                            t.identifier = upt.identifier
                            print("Token updated: \(t.token.issuer):\(t.token.name)")
                        }
                    }
                } catch {
                    print("Keychain error on update: \(error)")
                }
            }
        }
    }
    
    func emitChangeEvent() {
        do {
            objectWillChange.send()
        }
    }
}
