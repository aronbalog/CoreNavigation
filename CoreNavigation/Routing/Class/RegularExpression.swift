import Foundation

let NamedGroupComponentPattern = ":[a-zA-Z0-9-_][^/]+"
let ParameterPattern = ":[a-zA-Z0-9-_]+"
let URLParameterPattern = "([^/]+)"

class RegularExpression: NSRegularExpression {
    let groupNames: [String]

    override init(pattern: String, options: NSRegularExpression.Options = []) throws {
        let cleanedPattern = RegularExpression.stringByRemovingNamedGroups(from: pattern)

        self.groupNames = RegularExpression.namedGroups(for: pattern)

        try super.init(pattern: cleanedPattern, options: options)
    }

    func matchResult(for string: String, parameters: inout [String: Any]?) -> Bool {
        var _parameters: [String: Any] = [:]

        let string = stripURLQueryItems(from: string, parameters: &_parameters)

        let _matches = matches(in: string, options: [], range: NSRange(location: 0, length: string.count))

        if _matches.isEmpty {
            return false
        }

        for result in _matches {
            for i in (1..<result.numberOfRanges) {
                if i > groupNames.count {
                    break
                }

                let parameterName = groupNames[i - 1]
                let parameterValue = (string as NSString).substring(with: result.range(at: i))
                _parameters[parameterName] = parameterValue
            }
        }

        if !_parameters.isEmpty {
            parameters = _parameters
        }

        return true
    }

    private func stripURLQueryItems(from string: String, parameters: inout [String: Any]) -> String {
        let components = URLComponents(string: string)
        components?.queryItems?.forEach({ (item) in
            parameters[item.name] = item.value
        })

        if let substring = string.split(separator: "?").first {
            return String(substring)
        }

        return string
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func stringByRemovingNamedGroups(from string: String) -> String {
        var modifiedString = string

        let namedGroupExpressions = namedGroupTokens(for: string)
        let parameterRegex = try! NSRegularExpression(pattern: ParameterPattern, options: [])

        for namedExpression in namedGroupExpressions {
            var replacementExpression = namedExpression

            if let foundGroupName = parameterRegex.matches(in: namedExpression, options: [], range: NSRange(location: 0, length: namedExpression.count)).first {
                let stringToReplace = (namedExpression as NSString).substring(with: foundGroupName.range)
                replacementExpression = replacementExpression.replacingOccurrences(of: stringToReplace, with: "")
            }

            if replacementExpression.count == 0 {
                replacementExpression = URLParameterPattern
            }

            modifiedString = modifiedString.replacingOccurrences(of: namedExpression, with: replacementExpression)
        }

        if
            !modifiedString.isEmpty,
            modifiedString.first != "/"
        {
            modifiedString = "^" + modifiedString
        }
        modifiedString = modifiedString + "$"

        return modifiedString
    }

    static func namedGroups(for string: String) -> [String] {
        let namedGroupExpressions = namedGroupTokens(for: string)

        let parameterRegex = try! NSRegularExpression(pattern: ParameterPattern, options: [])

        return namedGroupExpressions.flatMap({ (namedExpression) -> String? in

            let componentMatches = parameterRegex.matches(in: namedExpression, options: [], range: NSRange(location: 0, length: namedExpression.count))

            guard let foundGroupName = componentMatches.first else { return nil }

            let stringToReplace = (namedExpression as NSString).substring(with: foundGroupName.range)
            let variableName = stringToReplace.replacingOccurrences(of: ":", with: "")

            return variableName
        })
    }

    static func namedGroupTokens(for string: String) -> [String] {
        let componentRegex = try! NSRegularExpression(pattern: NamedGroupComponentPattern, options: [])
        let matches = componentRegex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))

        let tokens = matches.map({ (result) -> String in
            let namedGroupToken = (string as NSString).substring(with: result.range)

            return namedGroupToken
        })

        return tokens
    }
}
