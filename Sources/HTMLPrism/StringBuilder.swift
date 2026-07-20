//
//  StringBuilder.swift
//  swift-html-prism
//
//  Minimal string result builder, replacing the retired coenttb/swift-builders
//  StringBuilder (same vendoring as swift-email). Lines join with newlines.
//

@resultBuilder
public enum StringBuilder {
    public static func buildBlock(_ components: String...) -> String {
        components.joined(separator: "\n")
    }
    public static func buildExpression(_ expression: String) -> String {
        expression
    }
    public static func buildOptional(_ component: String?) -> String {
        component ?? ""
    }
    public static func buildEither(first component: String) -> String {
        component
    }
    public static func buildEither(second component: String) -> String {
        component
    }
    public static func buildArray(_ components: [String]) -> String {
        components.joined(separator: "\n")
    }
}
