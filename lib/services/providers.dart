/// Provider-independent AI integration layer (client side).
///
/// IMPORTANT: Real provider API keys must NEVER live in this app. Provider
/// calls belong on a server (queue + workers + credit ledger). This file only
/// defines the shapes the UI needs, so the UI can honestly say which
/// capabilities exist. No provider is registered yet, so nothing is faked.

enum TaskType {
  textToVideo,
  imageToVideo,
  textToImage,
  speechGeneration,
  speechTranscription,
  languageAssist,
}

enum ProviderStatus { notConfigured, ready }

/// Job lifecycle from the spec. Used once the backend job queue exists.
enum JobState {
  draft,
  queued,
  processing,
  succeeded,
  failed,
  cancelled,
  expired,
}

/// Describes one AI provider (for example a hosted API or a self-hosted model).
abstract class AiProvider {
  String get id;
  String get displayName;

  /// Who runs the model, shown to users so third-party models are never
  /// presented as NIG_VID's own. Example: "Third-party" or "Self-hosted".
  String get operatedBy;

  Set<TaskType> get supportedTasks;
  ProviderStatus get status;
}

class ProviderRegistry {
  // Empty on purpose. Providers are added here once a server-side
  // integration is configured and verified.
  final List<AiProvider> _providers = <AiProvider>[];

  List<AiProvider> get all => List<AiProvider>.unmodifiable(_providers);

  List<AiProvider> readyFor(TaskType task) {
    return _providers
        .where((AiProvider p) =>
            p.status == ProviderStatus.ready &&
            p.supportedTasks.contains(task))
        .toList();
  }

  bool isAvailable(TaskType task) => readyFor(task).isNotEmpty;

  int get readyCount => _providers
      .where((AiProvider p) => p.status == ProviderStatus.ready)
      .length;
}
