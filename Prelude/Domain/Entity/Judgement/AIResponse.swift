struct AIResponse: Decodable {
    let answer: String
    let citations: [Citation]
}
