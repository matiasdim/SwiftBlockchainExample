import Foundation
import CryptoKit
import SwiftUI

struct ChainView: View {
    @StateObject var blockchain = Blockchain(difficuly: 3)
    @State private var mining = false
    @State private var input = "Independiente -> Medellin: 7"
    
    var body: some View {
        VStack {
            HStack {
                TextField("Text", text: $input)
                    .textFieldStyle(.roundedBorder)
                Button(mining ? "Mining..." : "Minar bloque") {
                    mining = true
                    Task.detached(priority: .background) {
                        await blockchain.addBlock(data: input)
                        await MainActor.run {
                            mining = false
                        }
                    }
                }
            }
            .padding()
            
            List(blockchain.chain.reversed()) { block in
                VStack(alignment: .leading) {
                    Text("Index: \(block.index) — nonce: \(block.nonce)")
                    Text("Data: \(block.data)").font(.subheadline)
                    Text("Hash: \(block.hash.prefix(16))...").font(.footnote)
                    Text("Previous: \(block.previousHash.prefix(8))...").font(.caption)
                }
                .padding(.vertical, 6)
            }
            
            Text(blockchain.isValid() ? "✅ Cadena válida" : "❌ Cadena corrupta")
                .padding()
        }
    }
}

struct Block: Codable, Identifiable {
    let id: UUID
    let index: Int
    let timestamp: TimeInterval
    let data: String
    let previousHash: String
    var nonce: Int
    var hash: String
    
    init(index: Int, data: String, previuosHash: String, difficulty: Int) {
        self.id = UUID()
        self.index = index
        self.timestamp = Date().timeIntervalSince1970
        self.data = data
        self.previousHash = previuosHash
        self.nonce = 0
        self.hash = Block.computeHash(index: index, timestamp: self.timestamp, data: data, previousHash: previuosHash, nonce: nonce)
        mine(difficulty: difficulty)
    }
    
    static func computeHash(index: Int, timestamp: TimeInterval, data: String, previousHash: String, nonce: Int) -> String {
        let payload = "\(index)\(timestamp)\(data)\(previousHash)\(nonce)"
        let digest = SHA256.hash(data: Data(payload.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    mutating func mine(difficulty: Int) {
        let targetPrefix = String(repeating: "0", count: difficulty)
        while !hash.hasPrefix(targetPrefix) {
            nonce += 1
            hash = Block.computeHash(index: index, timestamp: timestamp, data: data, previousHash: previousHash, nonce: nonce)
        }
    }
    
    static func genesis(difficulty: Int = 2) -> Block {
        return Block(index: 0, data: "Genesis", previuosHash: "0", difficulty: difficulty)
    }
}

final class Blockchain: ObservableObject {
    @Published private(set) var chain: [Block] = []
    let difficulty: Int
    
    init(difficuly: Int = 3) {
        self.difficulty = difficuly
        chain.append(.genesis(difficulty: difficuly))
    }
    
    func latest() -> Block {
        #warning("Refactor!")
        return chain.last!
    }
    
    func addBlock(data: String) {
        let previousBlock = latest()
        let new = Block(index: previousBlock.index, data: data, previuosHash: previousBlock.hash, difficulty: difficulty)
        DispatchQueue.main.async { [weak self] in
            self?.chain.append(new)
        }
    }
    
    func isValid() -> Bool {
        guard chain.count > 0 else { return true }
        for i in 1..<chain.count {
            let currentBlock = chain[i]
            let previousBlock = chain[i-1]
            if currentBlock.previousHash != previousBlock.hash {
                return false // Check blocks linked
            }
            let recomputed = Block.computeHash(
                index: currentBlock.index,
                timestamp: currentBlock.timestamp,
                data: currentBlock.data,
                previousHash: currentBlock.previousHash,
                nonce: currentBlock.nonce
            )
            if recomputed != currentBlock.hash {
                return false // Check  block integrity
            }
            if !currentBlock.hash.hasPrefix(String(repeating: "0", count: difficulty)) {
                return false // Check difficulty
            }
        }
        return true
    }
}
