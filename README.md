# 🧱 SwiftBlockchainExample

An experimental project built in **Swift** that implements a **basic blockchain** from scratch.  
Its goal is to provide a hands-on way to understand how blocks, hashing, and immutability work under the hood.

---

## 🎯 Purpose

This project is **not a production-ready blockchain**, but rather an educational base to explore the core concepts behind technologies like **Bitcoin**, **Ethereum**, and other distributed networks.

It serves as the first step in a broader journey to explore the intersection between **iOS development and Blockchain/Web3**.

---

## 🧩 Main Features

- 100% **Swift** implementation  
- **No external dependencies**  
- Uses **SHA256 hashing** to link blocks  
- Simple, readable, and extendable design  
- Great starting point for experiments with **WalletConnect**, **transaction signing**, and **smart contract integration**

---

## 🧠 Concepts Demonstrated

| Concept | Description |
|----------|--------------|
| **Block** | The basic unit of the blockchain. Contains data, its own hash, and the hash of the previous block. |
| **Blockchain** | A linked list of blocks ensuring data integrity and immutability. |
| **Hashing (SHA256)** | Cryptographic function that generates a unique fingerprint for the block’s data. |
| **Immutability** | Any change to a previous block invalidates the entire chain. |

---

## 💻 Core Code

The core logic lives in the `Block` and `Blockchain` structures, which handle block creation, chaining, and validation:

```swift
struct Block {
    let index: Int
    let timestamp: Date
    let data: String
    let previousHash: String
    let hash: String
}
```

```swift
class Blockchain {
    private(set) var chain: [Block] = []
    
    func addBlock(data: String) {
        let previousHash = chain.last?.hash ?? "0"
        let newBlock = Block(
            index: chain.count,
            timestamp: Date(),
            data: data,
            previousHash: previousHash
        )
        chain.append(newBlock)
    }
}
```

Each block references the hash of the previous one, ensuring the **integrity of the entire chain**.

---

## 🧭 Next Steps

This repository will serve as the foundation for future experiments:

- [ ] Add **Proof of Work (PoW)**
- [ ] Visualize the blockchain using **SwiftUI**
- [ ] Implement **digital signatures** for data or transactions
- [ ] Connect to a real **Ethereum smart contract** via **WalletConnect**
- [ ] Integrate with an iOS **crypto wallet**

---

## 🧰 Requirements

- Xcode 16 or later  
- Swift 5.9+  
- macOS Sonoma or later  

---

## 👨‍💻 Author

**Matías Gil**  
Senior iOS Engineer with 12 years of experience building native apps.  
Currently exploring the convergence of **Swift + Blockchain/Web3**.

- 🐙 [GitHub](https://github.com/tuusuario)  
- 💼 [LinkedIn](https://linkedin.com/in/tuusuario) *(optional)*

---

## ⚙️ License

This project is released for **educational and experimental purposes**.  
Feel free to use, modify, or extend it — attribution is appreciated.

---

> “Understanding how something works inside is the first step to reinventing it.”
