//
//  Prism.ThemeBuilder Tests.swift
//  swift-html-prism
//
//  Regression coverage for F-001 (fable-448): TokenStyle.cssString discarded the dark half
//  of a dual-mode HTMLColor, so `Prism.ThemeBuilder.build(name:)` never emitted the dark
//  variant of a custom theme's token colors.
//

import HTML
import HTMLPrism
import Testing

extension Prism.ThemeBuilder {
    @Suite
    struct Tests {
        @Suite
        struct Unit {
            @Test("build(name:) emits the dark half of a dual-mode token color inside a prefers-color-scheme: dark block")
            func buildEmitsDarkTokenColor() {
                let color = HTMLColor(light: .hex("#111111"), dark: .hex("#EEEEEE"))
                var builder = Prism.ThemeBuilder()
                builder.setTokenStyle(.keyword, style: Prism.TokenStyle(color: color))

                let theme = builder.build(name: "regression")

                #expect(theme.styles.contains("@media (prefers-color-scheme: dark)"))
                #expect(theme.styles.contains(color.dark.description))
            }
        }

        @Suite
        struct `Edge Case` {
            @Test("a token style with no color contributes nothing to the dark-mode block")
            func colorlessTokenStyleContributesNoDarkRule() {
                var builder = Prism.ThemeBuilder()
                builder.setTokenStyle(.comment, style: Prism.TokenStyle(fontStyle: .italic))

                let theme = builder.build(name: "regression-colorless")

                #expect(!theme.styles.contains("@media (prefers-color-scheme: dark)"))
            }

            @Test("free-form dark-mode styles still render even without any dual-mode token color")
            func freeFormDarkStylesStillRenderAlone() {
                var builder = Prism.ThemeBuilder()
                builder.setDarkModeStyles(".token.extra { color: #ABCDEF; }")

                let theme = builder.build(name: "regression-freeform-only")

                #expect(theme.styles.contains("@media (prefers-color-scheme: dark)"))
                #expect(theme.styles.contains(".token.extra { color: #ABCDEF; }"))
            }
        }
    }
}
