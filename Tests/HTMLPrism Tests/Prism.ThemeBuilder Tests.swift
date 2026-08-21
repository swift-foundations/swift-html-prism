import HTML
import HTMLPrism
import Testing

extension Prism.ThemeBuilder {
    @Suite
    struct Tests {
        @Suite
        struct Unit {
            @Test
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
            @Test
            func colorlessTokenStyleContributesNoDarkRule() {
                var builder = Prism.ThemeBuilder()
                builder.setTokenStyle(.comment, style: Prism.TokenStyle(fontStyle: .italic))

                let theme = builder.build(name: "regression-colorless")

                #expect(!theme.styles.contains("@media (prefers-color-scheme: dark)"))
            }

            @Test
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
