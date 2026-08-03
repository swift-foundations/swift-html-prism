//
//  ReadmeVerificationTests.swift
//  swift-html-prism
//
//  Created to verify all README code examples compile and work correctly
//

import Dependencies
import HTML
import HTMLPrism
import Testing

@Suite
struct `README Verification` {

    @Test
    func `quick start basic usage`() throws {
        // Add PrismJS resources to your HTML head
        let head = Prism.Head.swift

        // Create a syntax-highlighted code block
        let codeBlock = Prism.CodeBlock.swift(
            lineNumbers: true
        ) {
            """
            struct Greeting {
                let message = "Hello, World!"
            }
            """
        }

        let headHtml = try String(head)
        #expect(headHtml.contains("prism"))

        let codeHtml = try String(codeBlock)
        #expect(codeHtml.contains("language-swift"))
        #expect(codeHtml.contains("struct Greeting"))
    }

    @Test
    func `pre configured setups`() throws {
        // Minimal setup with basic web languages
        let minimal = Prism.Head.minimal

        // Standard setup with common languages and plugins
        let standard = Prism.Head.standard

        // Full setup with many languages and plugins
        let full = Prism.Head.full

        // Swift-optimized setup
        let swift = Prism.Head.swift

        #expect(try String(minimal).contains("prism"))
        #expect(try String(standard).contains("prism"))
        #expect(try String(full).contains("prism"))
        #expect(try String(swift).contains("prism"))
    }

    @Test
    func `custom configuration`() throws {
        let config = Prism.Configuration(
            languages: [.swift, .javascript, .python, .rust],
            plugins: [.lineNumbers, .lineHighlight, .copyToClipboard, .toolbar],
            theme: .builtin(.okaidia),
            cdnVersion: "1.29.0"
        )

        let head = Prism.Head(configuration: config)

        let html = try String(head)
        #expect(html.contains("prism-okaidia"))
        #expect(html.contains("prism-swift.min.js"))
        #expect(html.contains("prism-javascript.min.js"))
    }

    @Test
    func `basic code block with line numbers`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .javascript,
            lineNumbers: true
        ) {
            "console.log('Hello, World!');"
        }

        let html = try String(codeBlock)
        #expect(html.contains("language-javascript"))
        #expect(html.contains("line-numbers"))
        #expect(html.contains("console.log"))
    }

    @Test
    func `code block with line highlighting`() throws {
        let swiftCode = "let x = 1\nlet y = 2\nlet z = 3"

        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true,
            highlightLines: [3, 5, 7],
            startingLineNumber: 10
        ) {
            swiftCode
        }

        let html = try String(codeBlock)
        #expect(html.contains("language-swift"))
        #expect(html.contains("line-numbers"))
    }

    @Test
    func `code block with title`() throws {
        let pythonCode = "print('Hello')"

        let codeBlock = Prism.CodeBlock(
            language: .python,
            title: "example.py"
        ) {
            pythonCode
        }

        let html = try String(codeBlock)
        #expect(html.contains("example.py"))
        #expect(html.contains("code-block-title"))
    }

    @Test
    func `command line with output markers`() throws {
        let codeBlock = Prism.CodeBlock.bash(
            user: "john",
            host: "macbook",
            outputLines: [2, 3]
        ) {
            """
            $ npm install
            > Installing packages...
            Done!
            """
        }

        let html = try String(codeBlock)
        #expect(html.contains("language-bash"))
        #expect(html.contains("npm install"))
    }

    @Test
    func `inline code`() throws {
        let inlineCode = Prism.InlineCode.swift { "print()" }

        // Simulate usage in p tag
        let html = try String(inlineCode)
        #expect(html.contains("language-swift"))
        #expect(html.contains("print()"))
    }

    @Test
    func `language specific conveniences`() throws {
        let swiftCode = "let x = 1"
        let jsCode = "const x = 1"
        let htmlCode = "<div></div>"
        let cssCode = "body { margin: 0; }"
        let shellScript = "#!/bin/bash"
        let diffOutput = "+ added line"
        let jsonData = "{\"key\": \"value\"}"

        let swiftBlock = Prism.CodeBlock.swift { swiftCode }
        let jsBlock = Prism.CodeBlock.javascript { jsCode }
        let htmlBlock = Prism.CodeBlock.html { htmlCode }
        let cssBlock = Prism.CodeBlock.css { cssCode }
        let bashBlock = Prism.CodeBlock.bash(user: "admin", host: "server") { shellScript }
        let diffBlock = Prism.CodeBlock.diff { diffOutput }
        let jsonBlock = Prism.CodeBlock.json { jsonData }

        #expect(try String(swiftBlock).contains("language-swift"))
        #expect(try String(jsBlock).contains("language-javascript"))
        #expect(try String(htmlBlock).contains("language-html"))
        #expect(try String(cssBlock).contains("language-css"))
        #expect(try String(bashBlock).contains("language-bash"))
        #expect(try String(diffBlock).contains("language-diff"))
        #expect(try String(jsonBlock).contains("language-json"))
    }

    @Test
    func `inline code conveniences`() throws {
        let swiftInline = Prism.InlineCode.swift { "let x = 42" }
        let jsInline = Prism.InlineCode.javascript { "const x = 42;" }

        #expect(try String(swiftInline).contains("language-swift"))
        #expect(try String(jsInline).contains("language-javascript"))
    }

    @Test
    func `language access`() {
        // Web languages
        _ = Prism.Language.html
        _ = Prism.Language.css
        _ = Prism.Language.javascript
        _ = Prism.Language.typescript

        // System languages
        _ = Prism.Language.rust
        _ = Prism.Language.go
        _ = Prism.Language.zig
        _ = Prism.Language.c

        // Mobile languages
        _ = Prism.Language.swift
        _ = Prism.Language.kotlin
        _ = Prism.Language.objectivec

        #expect(Prism.Language.swift.className == "language-swift")
    }

    @Test
    func `language groups`() {
        let webLanguages = Prism.Language.webLanguages
        let systemLanguages = Prism.Language.systemLanguages
        let mobileLanguages = Prism.Language.mobileLanguages
        let scriptingLanguages = Prism.Language.scriptingLanguages
        let dataLanguages = Prism.Language.dataLanguages

        #expect(webLanguages.contains(.html))
        #expect(systemLanguages.contains(.rust))
        #expect(mobileLanguages.contains(.swift))
        #expect(scriptingLanguages.contains(.python))
        #expect(dataLanguages.contains(.json))
    }

    @Test
    func `plugin configuration`() {
        _ = Prism.Plugin.lineNumbers
        _ = Prism.Plugin.lineHighlight
        _ = Prism.Plugin.copyToClipboard
        _ = Prism.Plugin.showInvisibles
        _ = Prism.Plugin.toolbar
        _ = Prism.Plugin.matchBraces
        _ = Prism.Plugin.diffHighlight
        _ = Prism.Plugin.commandLine

        let config = Prism.Configuration(
            plugins: [.lineNumbers, .copyToClipboard, .toolbar]
        )

        #expect(config.plugins.count == 3)
    }

    @Test
    func `builtin themes`() {
        _ = Prism.Theme.default
        _ = Prism.Theme.dark
        _ = Prism.Theme.funky
        _ = Prism.Theme.okaidia
        _ = Prism.Theme.twilight
        _ = Prism.Theme.coy
        _ = Prism.Theme.solarizedlight
        _ = Prism.Theme.tomorrow

        #expect(Prism.Theme.okaidia.rawValue == "prism-okaidia")
    }

    @Test
    func `custom theme builder`() {
        var builder = Prism.ThemeBuilder()

        builder.setTokenStyle(
            .keyword,
            style: Prism.TokenStyle(
                color: HTMLColor(light: .hex("#AD3DA4"), dark: .hex("#FF79B2"))
            )
        )

        builder.setTokenStyle(
            .string,
            style: Prism.TokenStyle(
                color: HTMLColor(light: .hex("#D22E1B"), dark: .hex("#FF8170"))
            )
        )

        let customTheme = builder.build(name: "my-theme")

        let config = Prism.Configuration(
            theme: .custom(customTheme)
        )

        #expect(customTheme.name == "my-theme")

        switch config.theme {
        case .custom(let theme):
            #expect(theme.name == "my-theme")

        default:
            Issue.record("Expected custom theme")
        }
    }

    @Test
    func `dependency injection`() throws {
        withDependencies {
            $0.prismConfiguration = .swift
        } operation: {
            // Prism.Head() will use the Swift configuration
            let head = Prism.Head()

            let html = try? String(head)
            #expect(html != nil)
            #expect(html?.contains("prism") == true)
        }
    }

    @Test
    func `custom scripts`() throws {
        let config = Prism.Configuration(
            customScripts: """
                Prism.hooks.add('complete', function(env) {
                    console.log('Highlighted:', env.element);
                });
                """
        )

        let head = Prism.Head(configuration: config)
        let html = try String(head)

        #expect(html.contains("Prism.hooks.add"))
        #expect(html.contains("complete"))
    }

    @Test
    func `custom styles`() throws {
        let config = Prism.Configuration(
            customStyles: """
                pre[class*="language-"] {
                    border-radius: 8px;
                    margin: 1rem 0;
                }
                """
        )

        let head = Prism.Head(configuration: config)
        let html = try String(head)

        #expect(html.contains("border-radius: 8px"))
    }
}
