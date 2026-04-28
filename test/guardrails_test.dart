import 'package:flutter_test/flutter_test.dart';
import 'package:ptassistant/core/ai/guardrails.dart';

void main() {
  group('messageMentionsInjury', () {
    test('detects English injury keywords', () {
      expect(messageMentionsInjury('My shoulder is in pain'), true);
      expect(messageMentionsInjury('I hurt my knee'), true);
      expect(messageMentionsInjury('legs are sore'), true);
    });

    test('detects Turkish injury keywords', () {
      expect(messageMentionsInjury('omzum sakat'), true);
      expect(messageMentionsInjury('Dizimde ağrı var'), true);
      expect(messageMentionsInjury('bel sıkışma yapıyor'), true);
    });

    test('returns false for unrelated text', () {
      expect(messageMentionsInjury('Build me a push pull legs split'), false);
      expect(messageMentionsInjury('cut için beslenme'), false);
    });
  });

  group('GuardrailResult', () {
    test('GuardrailResult fields are stored as-given', () {
      const r = GuardrailResult(onTopic: true, reason: 'fitness');
      expect(r.onTopic, true);
      expect(r.reason, 'fitness');
    });
  });
}
