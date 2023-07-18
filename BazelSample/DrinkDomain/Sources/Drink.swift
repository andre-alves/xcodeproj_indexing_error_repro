import Foundation

public struct DrinkPreview {
    public let id: String
    public let name: String
    public let previewImageURL: URL

    public init(id: String, name: String, previewImageURL: URL) {
        self.id = id
        self.name = name
        self.previewImageURL = previewImageURL
    }
}

public struct Drink {
    public let id: String
    public let name: String
    public let previewImageURL: URL
    public let instruction: String
    public let ingredients: [Ingredient]

    public init(id: String, name: String, previewImageURL: URL, instruction: String, ingredients: [Ingredient]) {
        self.id = id
        self.name = name
        self.previewImageURL = previewImageURL
        self.instruction = instruction
        self.ingredients = ingredients
    }
}

public struct Ingredient {
    public let name: String
    public let amount: String

    public init(name: String, amount: String) {
        self.name = name
        self.amount = amount
    }
}
