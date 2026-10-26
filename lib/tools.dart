import 'package:flutter/material.dart';

import 'services/providers.dart';

/// A creation tool shown on the Create screen.
class ToolInfo {
  final String id;
  final IconData icon;
  final String titleKey;
  final String descKey;

  /// The AI task this tool needs. Null means it needs no AI provider.
  final TaskType? task;

  /// True when the tool has no working screen yet.
  final bool planned;

  const ToolInfo({
    required this.id,
    required this.icon,
    required this.titleKey,
    required this.descKey,
    this.task,
    this.planned = false,
  });
}

const List<ToolInfo> kTools = <ToolInfo>[
  ToolInfo(
    id: 't2v',
    icon: Icons.movie_creation_outlined,
    titleKey: 'tool.t2v',
    descKey: 'tool.t2v.desc',
    task: TaskType.textToVideo,
  ),
  ToolInfo(
    id: 't2i',
    icon: Icons.image_outlined,
    titleKey: 'tool.t2i',
    descKey: 'tool.t2i.desc',
    task: TaskType.textToImage,
  ),
  ToolInfo(
    id: 'i2v',
    icon: Icons.animation_outlined,
    titleKey: 'tool.i2v',
    descKey: 'tool.i2v.desc',
    task: TaskType.imageToVideo,
    planned: true,
  ),
  ToolInfo(
    id: 'editor',
    icon: Icons.content_cut,
    titleKey: 'tool.editor',
    descKey: 'tool.editor.desc',
  ),
  ToolInfo(
    id: 'story',
    icon: Icons.auto_stories_outlined,
    titleKey: 'tool.story',
    descKey: 'tool.story.desc',
    task: TaskType.languageAssist,
    planned: true,
  ),
  ToolInfo(
    id: 'voice',
    icon: Icons.record_voice_over_outlined,
    titleKey: 'tool.voice',
    descKey: 'tool.voice.desc',
    task: TaskType.speechGeneration,
    planned: true,
  ),
];

ToolInfo toolById(String id) {
  return kTools.firstWhere((ToolInfo t) => t.id == id);
}
