//
//  PrismTests.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//

import HTML
import HTMLPrism
import Testing

@Suite
struct `Prism Tests` {

    @Test
    func `language CDN paths`() {
        #expect(Prism.Language.swift.cdnComponentPath == "prism-swift.min.js")
        #expect(Prism.Language.javascript.cdnComponentPath == "prism-javascript.min.js")
        #expect(Prism.Language.python.cdnComponentPath == "prism-python.min.js")
    }

    @Test
    func `language class names`() {
        #expect(Prism.Language.swift.className == "language-swift")
        #expect(Prism.Language.html.className == "language-html")
        #expect(Prism.Language.css.className == "language-css")
    }

    @Test
    func `theme URLs`() {
        let version = "1.29.0"
        #expect(
            Prism.Theme.default.cssURL(cdnVersion: version)
                == "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css"
        )
        #expect(
            Prism.Theme.okaidia.cssURL(cdnVersion: version)
                == "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-okaidia.min.css"
        )
    }

    @Test
    func `plugin URLs`() {
        let version = "1.29.0"
        let lineNumbers = Prism.Plugin.lineNumbers
        #expect(
            lineNumbers.scriptURL(cdnVersion: version)
                == "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.js"
        )
        #expect(
            lineNumbers.cssURL(cdnVersion: version)
                == "https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/line-numbers/prism-line-numbers.min.css"
        )
    }

    @Test
    func `code block HTML`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true,
            highlightLines: [1]
        ) {
            "let greeting = \"Hello, World!\""
        }

        let html = try String(codeBlock)
        #expect(html.contains("language-swift"))
        #expect(html.contains("line-numbers"))
        #expect(html.contains("let greeting = \"Hello, World!\""))
    }

    @Test
    func `code block with title`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            title: "Example.swift"
        ) {
            "print(\"Hello\")"
        }

        let html = try String(codeBlock)
        #expect(html.contains("code-block-wrapper"))
        #expect(html.contains("code-block-title"))
        #expect(html.contains("Example.swift"))
    }

    @Test
    func `command line block`() throws {
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
        let inline = Prism.InlineCode.swift {
            "let x = 42"
        }
        let html = try String(inline)

        #expect(html.contains("<code"))
        #expect(html.contains("language-swift"))
        #expect(html.contains("let x = 42"))
    }

    @Test
    func `configuration presets`() {
        let minimal = Prism.Configuration.minimal
        #expect(minimal.languages.count == 3)
        //        #expect(minimal.plugins.isEmpty)

        let swift = Prism.Configuration.swift
        #expect(swift.languages.contains(.swift))
        #expect(swift.plugins.contains(where: { $0.name == "Line Numbers" }))
    }

    @Test
    func `prism head resources`() throws {
        let config = Prism.Configuration(
            languages: [.swift, .javascript],
            plugins: [.lineNumbers, .copyToClipboard],
            theme: .builtin(.okaidia)
        )

        let head = Prism.Head(configuration: config)
        let html = try String(head)

        // Check for theme CSS
        #expect(html.contains("prism-okaidia.min.css"))

        // Check for core script
        #expect(html.contains("prism.min.js"))

        // Check for language scripts
        #expect(html.contains("prism-swift.min.js"))
        #expect(html.contains("prism-javascript.min.js"))

        // Check for plugin scripts
        #expect(html.contains("prism-line-numbers.min.js"))
        #expect(html.contains("prism-copy-to-clipboard.min.js"))
    }

    @Test
    func `swift enhancements`() throws {
        let config = Prism.Configuration(languages: [.swift])
        let head = Prism.Head(configuration: config)
        let html = try String(head)

        // Check for Swift-specific enhancements
        #expect(html.contains("Prism.languages.swift"))
        #expect(html.contains("TODO:"))
        #expect(html.contains("placeholder"))
        #expect(html.contains("code-fold"))
    }

    @Test
    func `custom theme`() {
        var builder = Prism.ThemeBuilder()
        builder.setTokenStyle(
            .keyword,
            style: Prism.TokenStyle(
                color: HTMLColor(light: .hex("#FF0000"), dark: .hex("#00FF00"))
            )
        )

        let theme = builder.build(name: "test-theme")
        #expect(theme.name == "test-theme")
        #expect(theme.styles.contains(".token.keyword"))
    }

    @Test
    func `language groups`() {
        #expect(Prism.Language.webLanguages.contains(.html))
        #expect(Prism.Language.webLanguages.contains(.css))
        #expect(Prism.Language.webLanguages.contains(.javascript))

        #expect(Prism.Language.mobileLanguages.contains(.swift))
        #expect(Prism.Language.mobileLanguages.contains(.kotlin))

        #expect(Prism.Language.systemLanguages.contains(.rust))
        #expect(Prism.Language.systemLanguages.contains(.go))
    }

    @Test
    func `namespace convenience`() throws {
        // Test that the type aliases work
        let config: Prism.Configuration = .minimal
        let head = Prism.Head(configuration: config)
        let block = Prism.CodeBlock.swift {
            "let x = 1"
        }
        let inline = Prism.InlineCode.javascript {
            "console.log()"
        }

        #expect(config.languages.count == 3)
        #expect(try String(head).contains("prism"))
        #expect(try String(block).contains("language-swift"))
        #expect(try String(inline).contains("language-javascript"))
    }

    @Test
    func `string builder multiline`() throws {
        let codeBlock = Prism.CodeBlock.swift {
            """
            struct User {
                let name: String
                let age: Int
            }
            """
        }

        let html = try String(codeBlock)
        #expect(html.contains("struct User"))
        #expect(html.contains("let name: String"))
        #expect(html.contains("let age: Int"))
    }

    @Test
    func `string builder interpolation`() throws {
        let version = 10
        let codeBlock = Prism.CodeBlock.javascript {
            "console.log('Version: \(version)');"
        }

        let html = try String(codeBlock)
        #expect(html.contains("Version: 10"))
    }

    @Test
    func `convenience methods`() throws {
        // Test swift convenience
        let swiftBlock = Prism.CodeBlock.swift(
            lineNumbers: true,
            highlightLines: [2]
        ) {
            """
            func greet(_ name: String) {
                print("Hello, \\(name)!")
            }
            """
        }

        let swiftHtml = try String(swiftBlock)
        #expect(swiftHtml.contains("language-swift"))
        #expect(swiftHtml.contains("line-numbers"))
        #expect(swiftHtml.contains("func greet"))

        // Test bash convenience
        let bashBlock = Prism.CodeBlock.bash(
            user: "admin",
            host: "server"
        ) {
            """
            $ cd /var/www
            $ ls -la
            total 24
            drwxr-xr-x  3 root root 4096 Jan  1 00:00 .
            drwxr-xr-x 14 root root 4096 Jan  1 00:00 ..
            """
        }

        let bashHtml = try String(bashBlock)
        #expect(bashHtml.contains("language-bash"))
        #expect(bashHtml.contains("cd /var/www"))

        // Test json convenience
        let jsonBlock = Prism.CodeBlock.json(lineNumbers: true) {
            """
            {
                "name": "swift-html-prism",
                "version": "0.1.0",
                "dependencies": []
            }
            """
        }

        let jsonHtml = try String(jsonBlock)
        #expect(jsonHtml.contains("language-json"))
        #expect(jsonHtml.contains("line-numbers"))
        #expect(jsonHtml.contains("swift-html-prism"))
    }

    @Test
    func `inline code string builder`() throws {
        let swiftInline = Prism.InlineCode.swift {
            "let result = calculate(x: 10, y: 20)"
        }

        let jsInline = Prism.InlineCode.javascript {
            "const result = calculate(10, 20);"
        }

        let swiftHtml = try String(swiftInline)
        let jsHtml = try String(jsInline)

        #expect(swiftHtml.contains("language-swift"))
        #expect(swiftHtml.contains("let result = calculate"))

        #expect(jsHtml.contains("language-javascript"))
        #expect(jsHtml.contains("const result = calculate"))
    }
}

@Test
func `snap shot`() throws {
    let swiftInline = Prism.InlineCode.swift {
        "let result = calculate(x: 10, y: 20)"
    }

    let rendered = try String(swiftInline)
    #expect(
        rendered.contains(
            #"<code class="language-swift">let result = calculate(x: 10, y: 20)</code>"#
        )
    )
}
