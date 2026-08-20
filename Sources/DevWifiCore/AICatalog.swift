import Foundation

/// Known AI apps and API hosts. Classification is by process name or destination, never payload.
public enum AICatalog {
    private static let processMap: [(needle: String, display: String)] = [
        ("cursorsandbox", "Cursor"),
        ("cursor", "Cursor"),
        ("claude", "Claude"),
        ("chatgpt", "ChatGPT"),
        ("copilot", "Copilot"),
        ("windsurf", "Windsurf"),
        ("antigravity", "Antigravity"),
        ("ollama", "Ollama"),
        ("lm studio", "LM Studio"),
        ("lmstudio", "LM Studio"),
        ("grok", "Grok"),
        ("gemini", "Gemini"),
        ("perplexity", "Perplexity"),
        ("codeium", "Codeium"),
        ("supermaven", "Supermaven"),
        ("tabnine", "Tabnine"),
        ("aider", "Aider"),
    ]

    private static let hostMap: [(suffix: String, display: String)] = [
        ("api2.cursor.sh", "Cursor"),
        ("cursor.sh", "Cursor"),
        ("cursor.com", "Cursor"),
        ("api.anthropic.com", "Anthropic"),
        ("anthropic.com", "Anthropic"),
        ("claude.ai", "Claude"),
        ("api.openai.com", "OpenAI"),
        ("openai.com", "OpenAI"),
        ("generativelanguage.googleapis.com", "Gemini"),
        ("ai.google.dev", "Gemini"),
        ("gemini.google.com", "Gemini"),
        ("api.githubcopilot.com", "Copilot"),
        ("copilot-proxy.githubusercontent.com", "Copilot"),
        ("api.groq.com", "Groq"),
        ("api.x.ai", "Grok"),
        ("x.ai", "Grok"),
        ("openrouter.ai", "OpenRouter"),
        ("api.mistral.ai", "Mistral"),
        ("api.deepseek.com", "DeepSeek"),
        ("deepseek.com", "DeepSeek"),
        ("perplexity.ai", "Perplexity"),
        ("ollama.com", "Ollama"),
        ("together.xyz", "Together"),
    ]

    public static func matchProcess(_ name: String) -> String? {
        let lowered = name.lowercased()
        return processMap.first(where: { lowered.contains($0.needle) })?.display
    }

    public static func matchHost(_ host: String) -> String? {
        let lowered = host.lowercased()
        return hostMap.first(where: { lowered == $0.suffix || lowered.hasSuffix("." + $0.suffix) })?.display
    }

    /// Canonical app label if the process or host belongs to an AI product.
    public static func classify(process: String, host: String) -> String? {
        matchProcess(process) ?? matchHost(host)
    }

    public static func isIPAddress(_ host: String) -> Bool {
        if host.hasPrefix("[") { return true }
        if host.contains(":") { return true }
        let parts = host.split(separator: ".")
        return parts.count == 4 && parts.allSatisfy { UInt8($0) != nil }
    }
}
