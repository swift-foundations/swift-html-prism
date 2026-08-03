//
//  Prism.Theme.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

import HTML

extension Prism {
    public enum Theme: String, Sendable, CaseIterable {
        case `default` = "prism"
        case dark = "prism-dark"
        case funky = "prism-funky"
        case okaidia = "prism-okaidia"
        case twilight = "prism-twilight"
        case coy = "prism-coy"
        case solarizedlight = "prism-solarizedlight"
        case tomorrow = "prism-tomorrow"
    }
}

extension Prism.Theme {
    public var cssFileName: String {
        "\(rawValue).min.css"
    }

    public func cssURL(cdnVersion: String) -> String {
        if self == .default {
            return
                "https://cdnjs.cloudflare.com/ajax/libs/prism/\(cdnVersion)/themes/prism.min.css"
        } else {
            return
                "https://cdnjs.cloudflare.com/ajax/libs/prism/\(cdnVersion)/themes/\(rawValue).min.css"
        }
    }
}

extension Prism {
    // Custom theme support
    public struct CustomTheme: Sendable {
        public let name: String
        public let styles: String

        public init(name: String, styles: String) {
            self.name = name
            self.styles = styles
        }
    }

    // Token styling
    public struct TokenStyle: Sendable {
        public let color: DarkModeColor?
        public let backgroundColor: BackgroundColor?
        public let fontWeight: FontWeight?
        public let fontStyle: FontStyle?
        public let textDecoration: TextDecoration?

        public init(
            color: DarkModeColor? = nil,
            backgroundColor: BackgroundColor? = nil,
            fontWeight: FontWeight? = nil,
            fontStyle: FontStyle? = nil,
            textDecoration: TextDecoration? = nil
        ) {
            self.color = color
            self.backgroundColor = backgroundColor
            self.fontWeight = fontWeight
            self.fontStyle = fontStyle
            self.textDecoration = textDecoration
        }
    }
}

extension Prism.TokenStyle {
    public var cssString: String {
        var styles: [String] = []

        if let color {
            styles.append("color: \(color.light.description)")
        }
        if let backgroundColor {
            styles.append("background-color: \(backgroundColor.description)")
        }
        if let fontWeight {
            styles.append("font-weight: \(fontWeight)")
        }
        if let fontStyle {
            styles.append("font-style: \(fontStyle)")
        }
        if let textDecoration {
            styles.append("text-decoration: \(textDecoration)")
        }

        return styles.joined(separator: "; ")
    }

    /// The dark-mode-only declarations for this style, or `nil` when this style specifies no
    /// dark-mode-relevant properties. `color` is the only property backed by `DarkModeColor`
    /// (a light/dark pair); the other properties are mode-independent and already covered by
    /// ``cssString``.
    public var darkCSSString: String? {
        guard let color else { return nil }
        return "color: \(color.dark.description)"
    }
}

extension Prism {
    // Token types for custom themes
    public enum TokenType: String, Sendable, CaseIterable {
        case comment
        case prolog
        case doctype
        case cdata
        case punctuation
        case namespace
        case property
        case tag
        case boolean
        case number
        case constant
        case symbol
        case deleted
        case selector
        case attrName = "attr-name"
        case string
        case char
        case builtin
        case inserted
        case `operator`
        case entity
        case url
        case variable
        case atrule
        case attrValue = "attr-value"
        case function
        case functionVariable = "function-variable"
        case keyword
        case regex
        case important
        case bold
        case italic
        case className = "class-name"
    }

    // Custom theme builder
    public struct ThemeBuilder: Sendable {
        private var tokenStyles: [TokenType: TokenStyle] = [:]
        private var baseStyles: String = ""
        private var darkModeStyles: String = ""

        public init() {}
    }
}

extension Prism.TokenType {
    public var selector: String {
        ".token.\(rawValue)"
    }
}

extension Prism.ThemeBuilder {
    public mutating func setTokenStyle(_ tokenType: Prism.TokenType, style: Prism.TokenStyle) {
        tokenStyles[tokenType] = style
    }

    public mutating func setBaseStyles(_ styles: String) {
        baseStyles = styles
    }

    public mutating func setDarkModeStyles(_ styles: String) {
        darkModeStyles = styles
    }

    public func build(name: String) -> Prism.CustomTheme {
        var css = baseStyles + "\n"

        // Sort token types by raw value for deterministic output
        let sortedTokenStyles = tokenStyles.sorted { $0.key.rawValue < $1.key.rawValue }
        for (tokenType, style) in sortedTokenStyles {
            css += "\(tokenType.selector) { \(style.cssString) }\n"
        }

        // Dark half of any dual-mode (DarkModeColor) token style, plus any free-form dark-mode
        // styles, share the same `prefers-color-scheme: dark` block.
        let darkTokenRules = sortedTokenStyles.compactMap { tokenType, style in
            style.darkCSSString.map { "\(tokenType.selector) { \($0) }" }
        }

        if !darkTokenRules.isEmpty || !darkModeStyles.isEmpty {
            css += "@media (prefers-color-scheme: dark) {\n"
            css += darkTokenRules.joined(separator: "\n")
            if !darkTokenRules.isEmpty, !darkModeStyles.isEmpty {
                css += "\n"
            }
            css += darkModeStyles
            css += "\n}\n"
        }

        return Prism.CustomTheme(name: name, styles: css)
    }
}

// Pre-built custom themes
extension Prism.CustomTheme {
    public static let swift: Self = {
        var builder = Prism.ThemeBuilder()

        // Swift/Xcode-like theme
        builder.setTokenStyle(
            .keyword,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#AD3DA4"), dark: .hex("#FF79B2"))
            )
        )

        builder.setTokenStyle(
            .className,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#4B21B0"), dark: .hex("#DABAFF"))
            )
        )

        builder.setTokenStyle(
            .function,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#4B21B0"), dark: .hex("#DABAFF"))
            )
        )

        builder.setTokenStyle(
            .comment,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#707F8C"), dark: .hex("#7E8C98"))
            )
        )

        builder.setTokenStyle(
            .string,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#D22E1B"), dark: .hex("#FF8170"))
            )
        )

        builder.setTokenStyle(
            .number,
            style: Prism.TokenStyle(
                color: DarkModeColor(light: .hex("#D22E1B"), dark: .hex("#FF8170"))
            )
        )

        return builder.build(name: "swift")
    }()
}
