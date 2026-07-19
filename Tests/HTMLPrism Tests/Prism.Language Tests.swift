//
//  Prism.Language Tests.swift
//  swift-html-prism
//
//  Regression coverage for F-002 (fable-448): alias language cases used to generate
//  nonexistent CDN component URLs because `cdnComponentPath` blindly interpolated
//  `rawValue`, even for cases that are Prism-recognized aliases with no CDN file of
//  their own (e.g. `.js`, `.html`).
//

import HTMLPrism
import Testing

extension Prism.Language {
    @Suite
    struct Tests {
        @Suite
        struct Unit {
            @Test("known alias language cases resolve their CDN component path to their canonical component file")
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

            @Test("canonical language cases keep resolving their own CDN component path")
            func canonicalLanguagesKeepOwnComponentPath() {
                #expect(Prism.Language.markup.cdnComponentPath == "prism-markup.min.js")
                #expect(Prism.Language.javascript.cdnComponentPath == "prism-javascript.min.js")
                #expect(Prism.Language.swift.cdnComponentPath == "prism-swift.min.js")
                #expect(Prism.Language.bash.cdnComponentPath == "prism-bash.min.js")
            }

            @Test("className keeps using the case's own identifier, not the canonical component id")
            func classNameStaysCaseSpecific() {
                // Prism resolves alias class names (e.g. "language-js") to the canonical
                // grammar at runtime; only the CDN component *file* needs remapping.
                #expect(Prism.Language.js.className == "language-js")
                #expect(Prism.Language.html.className == "language-html")
            }
        }

        @Suite
        struct `Edge Case` {
            @Test("the markup family of aliases all resolve to the markup component")
            func markupFamilyAliasesResolveToMarkupComponent() {
                let markupAliases: [Prism.Language] = [.html, .xml, .svg, .mathml, .ssml, .atom, .rss]
                for alias in markupAliases {
                    #expect(alias.cdnComponentPath == Prism.Language.markup.cdnComponentPath)
                }
            }

            @Test("every CaseIterable language case produces a non-empty component path")
            func everyLanguageCaseProducesNonEmptyComponentPath() {
                for language in Prism.Language.allCases {
                    #expect(!language.cdnComponentPath.isEmpty)
                }
            }
        }
    }
}
