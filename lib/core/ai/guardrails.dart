import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

class GuardrailResult {
  const GuardrailResult({required this.onTopic, required this.reason});

  final bool onTopic;
  final String reason;
}

abstract interface class Guardrails {
  Future<GuardrailResult> classify(String userMessage);
}

class GeminiGuardrails implements Guardrails {
  GeminiGuardrails(this._model);

  final GenerativeModel _model;

  @override
  Future<GuardrailResult> classify(String userMessage) async {
    try {
      final response = await _model.generateContent([
        Content.text('User message: $userMessage'),
      ]);
      final text = response.text?.trim() ?? '';
      final json = jsonDecode(text) as Map<String, Object?>;
      final onTopic = json['onTopic'] as bool? ?? true;
      final reason = json['reason'] as String? ?? '';
      return GuardrailResult(onTopic: onTopic, reason: reason);
    } catch (e, st) {
      debugPrint('Guardrails classify error: $e\n$st');
      return const GuardrailResult(onTopic: true, reason: 'fallback');
    }
  }
}

const Set<String> _injuryKeywords = {
  'pain',
  'injury',
  'hurt',
  'sore',
  'sakat',
  'ağrı',
  'incindi',
  'sıkışma',
  'zorlandı',
};

const Set<String> _medicalClaimKeywords = {
  'diagnose',
  'diagnosis',
  'prescribe',
  'prescription',
  'treat ',
  'cure',
  'treatment',
  'medication',
  'medicate',
  'therapy',
  'medical advice',
  'tıbbi tavsiye',
  'tedavi',
  'tanı',
  'reçete',
  'ilaç öner',
  'doktor reçete',
};

bool messageMentionsInjury(String message) {
  final lower = message.toLowerCase();
  return _injuryKeywords.any(lower.contains);
}

bool responseMakesMedicalClaim(String response) {
  final lower = response.toLowerCase();
  return _medicalClaimKeywords.any(lower.contains);
}
