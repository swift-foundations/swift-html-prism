import HTMLPrism
import Testing

extension Prism.Language {
    @Suite
    struct Tests {
        @Suite
        struct Unit {
            @Test
            func aliasLanguagesResolveCanonicalComponentPath() {
                #expect(Prism.Language.html.cdnComponentPath == "prism-markup.min.js")
                #expect(Prism.Language.xml.cdnComponentPath == "prism-markup.min.js")
                #expect(Prism.Language.js.cdnComponentPath == "prism-javascript.min.js")
                #expect(Prism.Language.ts.cdnComponentPath == "prism-typescript.min.js")
                #expect(Prism.Language.py.cdnComponentPath == "prism-python.min.js")
                #expect(Prism.Language.sh.cdnComponentPath == "prism-bash.min.js")
                #expect(Prism.Language.shell.cdnComponentPath == "prism-bash.min.js")
                #expect(Prism.Language.yml.cdnComponentPath == "prism-yaml.min.js")
            }

            @Test
            func canonicalLanguagesKeepOwnComponentPath() {
                #expect(Prism.Language.markup.cdnComponentPath == "prism-markup.min.js")
                #expect(Prism.Language.javascript.cdnComponentPath == "prism-javascript.min.js")
                #expect(Prism.Language.swift.cdnComponentPath == "prism-swift.min.js")
                #expect(Prism.Language.bash.cdnComponentPath == "prism-bash.min.js")
            }

            @Test
            func classNameStaysCaseSpecific() {

                #expect(Prism.Language.js.className == "language-js")
                #expect(Prism.Language.html.className == "language-html")
            }
        }

        @Suite
        struct `Edge Case` {
            @Test
            func markupFamilyAliasesResolveToMarkupComponent() {
                let markupAliases: [Prism.Language] = [
                    .html, .xml, .svg, .mathml, .ssml, .atom, .rss,
                ]
                for alias in markupAliases {
                    #expect(alias.cdnComponentPath == Prism.Language.markup.cdnComponentPath)
                }
            }

            @Test
            func everyLanguageCaseProducesNonEmptyComponentPath() {
                for language in Prism.Language.allCases {
                    #expect(!language.cdnComponentPath.isEmpty)
                }
            }
        }
    }
}
