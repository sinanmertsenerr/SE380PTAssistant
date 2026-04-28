import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import 'ai_service.dart' show aiModelId;

class SourceLookupResult {
  const SourceLookupResult({required this.summary, required this.sources});

  final String summary;
  final List<SourceCitation> sources;

  Map<String, Object?> toMap() => {
    'summary': summary,
    'sources': sources.map((s) => s.toMap()).toList(),
  };
}

class SourceCitation {
  const SourceCitation({this.uri, this.title, this.domain});

  final String? uri;
  final String? title;
  final String? domain;

  Map<String, Object?> toMap() => {
    if (uri != null) 'uri': uri,
    if (title != null) 'title': title,
    if (domain != null) 'domain': domain,
  };
}

abstract interface class SourceLookupService {
  Future<SourceLookupResult> lookup(String query);
}

class GeminiSourceLookupService implements SourceLookupService {
  GeminiSourceLookupService([GenerativeModel? model])
    : _model = model ?? _build();

  final GenerativeModel _model;

  static GenerativeModel _build() {
    return FirebaseAI.googleAI().generativeModel(
      model: aiModelId,
      systemInstruction: Content.system(
        'You are a fitness research assistant. Answer the query in 2-3 short sentences using web search. Cite sources implicitly via the grounding tool. Stay strictly within fitness, training, recovery, and sports nutrition. Refuse anything else with one short sentence.',
      ),
      tools: [Tool.googleSearch()],
      generationConfig: GenerationConfig(
        temperature: 0.2,
        maxOutputTokens: 512,
      ),
    );
  }

  @override
  Future<SourceLookupResult> lookup(String query) async {
    try {
      final response = await _model.generateContent([Content.text(query)]);
      final text = response.text?.trim() ?? '';
      final chunks =
          response.candidates.firstOrNull?.groundingMetadata?.groundingChunks ??
          const [];
      final sources = <SourceCitation>[];
      for (final c in chunks) {
        final web = c.web;
        if (web == null) continue;
        sources.add(
          SourceCitation(
            uri: web.uri,
            title: web.title,
            domain: web.domain,
          ),
        );
      }
      return SourceLookupResult(summary: text, sources: sources);
    } catch (e, st) {
      debugPrint('Source lookup failed: $e\n$st');
      return const SourceLookupResult(summary: '', sources: []);
    }
  }
}
