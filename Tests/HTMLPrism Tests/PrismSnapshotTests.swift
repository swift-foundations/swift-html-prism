//
//  PrismSnapshotTests.swift
//  swift-html-prism
//
//  Created by Coen ten Thije Boonkkamp on 01/09/2025.
//
//  Migrated from PointFreeHTMLTestSupport inline snapshots to
//  institute-native rendered-string assertions (try String(_:) + #expect).
//

import HTML
import HTMLPrism
import Testing

@Suite
struct Snapshots {

    @Test
    func `inline code swift snapshot`() throws {
        let swiftInline = Prism.InlineCode.swift {
            "let result = calculate(x: 10, y: 20)"
        }

        let rendered = try String(swiftInline)
        #expect(rendered.contains(#"<code class="language-swift">"#))
        #expect(rendered.contains("let result = calculate(x: 10, y: 20)"))
        #expect(rendered.contains("</code>"))
    }

    @Test
    func `inline code java script snapshot`() throws {
        let jsInline = Prism.InlineCode.javascript {
            "const result = calculate(10, 20);"
        }

        let rendered = try String(jsInline)
        #expect(rendered.contains(#"<code class="language-javascript">"#))
        #expect(rendered.contains("const result = calculate(10, 20);"))
    }

    @Test
    func `code block swift snapshot`() throws {
        let codeBlock = Prism.CodeBlock.swift {
            """
            struct User {
                let name: String
                let age: Int
            }
            """
        }

        let rendered = try String(codeBlock)
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains(#"<code class="language-swift">"#))
        #expect(rendered.contains("struct User {"))
        #expect(rendered.contains("let age: Int"))
    }

    @Test
    func `code block with line numbers snapshot`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true
        ) {
            """
            func greet(_ name: String) {
                print("Hello, \\(name)!")
            }
            """
        }

        let rendered = try String(codeBlock)
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains(#"<code class="language-swift">"#))
        #expect(rendered.contains("func greet(_ name: String) {"))
    }

    @Test
    func `code block with title snapshot`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            title: "Greeting.swift"
        ) {
            "print(\"Hello, World!\")"
        }

        let rendered = try String(codeBlock)
        #expect(rendered.contains(#"class="code-block-wrapper""#))
        #expect(rendered.contains(#"class="code-block-title""#))
        #expect(rendered.contains("Greeting.swift"))
        #expect(rendered.contains(#"<code class="language-swift">"#))
    }

    @Test
    func `code block with highlighted lines snapshot`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .javascript,
            lineNumbers: true,
            highlightLines: [2, 3]
        ) {
            """
            function fibonacci(n) {
                if (n <= 1) return n;
                return fibonacci(n - 1) + fibonacci(n - 2);
            }
            """
        }

        let rendered = try String(codeBlock)
        #expect(rendered.contains(#"data-line="2,3""#))
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains(#"<code class="language-javascript">"#))
        #expect(rendered.contains("function fibonacci(n) {"))
    }

    @Test
    func `command line block snapshot`() throws {
        let bashBlock = Prism.CodeBlock.bash(
            user: "admin",
            host: "server",
            outputLines: [2, 3]
        ) {
            """
            $ npm install
            > Installing packages...
            Done!
            """
        }

        let rendered = try String(bashBlock)
        #expect(rendered.contains(#"data-user="admin""#))
        #expect(rendered.contains(#"data-host="server""#))
        #expect(rendered.contains(#"data-output="2,3""#))
        #expect(rendered.contains(#"<code class="language-bash">"#))
        #expect(rendered.contains("$ npm install"))
        #expect(rendered.contains("Done!"))
    }

    @Test
    func `json block snapshot`() throws {
        let jsonBlock = Prism.CodeBlock.json(lineNumbers: true) {
            """
            {
                "name": "swift-html-prism",
                "version": "0.1.0",
                "languages": ["swift", "javascript", "python"]
            }
            """
        }

        let rendered = try String(jsonBlock)
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains(#"<code class="language-json">"#))
        #expect(rendered.contains("swift-html-prism"))
    }

    @Test
    func `diff block snapshot`() throws {
        let diffBlock = Prism.CodeBlock.diff {
            """
            - let oldValue = 42
            + let newValue = 100
              let unchanged = "same"
            """
        }

        let rendered = try String(diffBlock)
        #expect(rendered.contains(#"<code class="language-diff">"#))
        #expect(rendered.contains("- let oldValue = 42"))
        #expect(rendered.contains("+ let newValue = 100"))
    }

    @Test
    func `prism head minimal snapshot`() throws {
        let rendered = try String(Prism.Head.minimal)
        #expect(rendered.contains("prism/1.29.0/themes/prism.min.css"))
        #expect(rendered.contains("plugins/line-numbers/prism-line-numbers.min.css"))
        #expect(rendered.contains("plugins/line-highlight/prism-line-highlight.min.css"))
        #expect(rendered.contains("prism/1.29.0/prism.min.js"))
        #expect(rendered.contains("components/prism-javascript.min.js"))
        #expect(rendered.contains("components/prism-css.min.js"))
        #expect(rendered.contains("Prism.highlightAll()"))
    }

    @Test
    func `prism head swift snapshot`() throws {
        let rendered = try String(Prism.Head.swift)
        // Custom Swift theme styles, not a CDN theme.
        #expect(rendered.contains(".token.keyword { color: #AD3DA4 }"))
        #expect(rendered.contains(".token.string { color: #D22E1B }"))
        #expect(!rendered.contains("themes/prism.min.css"))
        #expect(rendered.contains("components/prism-swift.min.js"))
        #expect(rendered.contains("plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js"))
        // Swift-specific highlighting enhancements.
        #expect(rendered.contains("Prism.languages.swift"))
        #expect(rendered.contains("placeholder"))
    }

    @Test
    func `prism head custom snapshot`() throws {
        let config = Prism.Configuration(
            languages: [.swift, .javascript],
            plugins: [.lineNumbers, .copyToClipboard],
            theme: .builtin(.okaidia)
        )
        let rendered = try String(Prism.Head(configuration: config))
        #expect(rendered.contains("themes/prism-okaidia.min.css"))
        #expect(rendered.contains("plugins/line-numbers/prism-line-numbers.min.css"))
        #expect(rendered.contains("plugins/copy-to-clipboard/prism-copy-to-clipboard.min.js"))
        #expect(rendered.contains("components/prism-swift.min.js"))
        #expect(rendered.contains("components/prism-javascript.min.js"))
        #expect(!rendered.contains("prism-line-highlight"))
    }

    @Test
    func `complex code block snapshot`() throws {
        let codeBlock = Prism.CodeBlock(
            language: .swift,
            lineNumbers: true,
            highlightLines: [1, 3, 5],
            startingLineNumber: 10,
            title: "ComplexExample.swift"
        ) {
            """
            import Foundation

            struct ComplexExample {
                let value: Int

                func compute() -> Int {
                    return value * 2
                }
            }
            """
        }

        let rendered = try String(codeBlock)
        #expect(rendered.contains(#"class="code-block-wrapper""#))
        #expect(rendered.contains("ComplexExample.swift"))
        #expect(rendered.contains(#"data-line="1,3,5""#))
        #expect(rendered.contains(#"data-start="10""#))
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains("struct ComplexExample {"))
    }

    @Test
    func `html code block snapshot`() throws {
        let htmlBlock = Prism.CodeBlock.html(
            lineNumbers: true
        ) {
            """
            <!DOCTYPE html>
            <html>
                <head>
                    <title>Example</title>
                </head>
                <body>
                    <h1>Hello, World!</h1>
                </body>
            </html>
            """
        }

        let rendered = try String(htmlBlock)
        #expect(rendered.contains(#"<code class="language-html">"#))
        // Embedded markup must be escaped, not emitted as live tags.
        #expect(rendered.contains("&lt;!DOCTYPE html&gt;") || rendered.contains("&lt;!DOCTYPE html>"))
        #expect(!rendered.contains("<h1>Hello, World!</h1>"))
    }

    @Test
    func `css code block snapshot`() throws {
        let cssBlock = Prism.CodeBlock.css(
            lineNumbers: true
        ) {
            """
            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 1rem;
            }
            """
        }

        let rendered = try String(cssBlock)
        #expect(rendered.contains(#"class="line-numbers""#))
        #expect(rendered.contains(#"<code class="language-css">"#))
        #expect(rendered.contains(".container {"))
        #expect(rendered.contains("justify-content: center;"))
    }
}
