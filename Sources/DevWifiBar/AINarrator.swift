import DevWifiCore
import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

enum AINarrator {
    static func polish(context: AIBriefContext, fallback: String) async -> String {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, *) {
            return await polishWithFoundationModel(context: context, fallback: fallback)
        }
        #endif
        return fallback
    }

    #if canImport(FoundationModels)
    @available(macOS 26.0, *)
    private static func polishWithFoundationModel(context: AIBriefContext, fallback: String) async -> String {
        let model = SystemLanguageModel.default
        guard model.isAvailable else { return fallback }

        let prompt = """
        Rewrite these network facts as 1 short sentence for a macOS menu bar. No greeting. No SSID. No markdown.
        Facts: \(context.facts)
        Fallback if unsure: \(fallback)
        """

        do {
            let session = LanguageModelSession()
            let response = try await session.respond(to: prompt)
            let text = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            if text.isEmpty || text.count > 160 { return fallback }
            return text
        } catch {
            return fallback
        }
    }
    #endif
}
