import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';

/// One clip on the timeline. Trimming is non-destructive: the original file is
/// never changed, only the start and end points are stored.
class EditorClip {
  final String id;
  final String path;
  final String name;
  final bool isVideo;

  /// Full length of a video, or the maximum on-screen time for a photo.
  final Duration sourceDuration;
  Duration trimStart;
  Duration trimEnd;

  EditorClip({
    required this.id,
    required this.path,
    required this.name,
    required this.isVideo,
    required Duration duration,
    Duration? initialLength,
  })  : sourceDuration = duration,
        trimStart = Duration.zero,
        trimEnd = initialLength ?? duration;

  Duration get length => trimEnd - trimStart;
}

/// Basic editor: import videos and photos from the phone, preview them,
/// reorder and trim. The timeline lives only while this screen is open and
/// the screen says so. Export is not available yet and the screen says so.
class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final List<EditorClip> _clips = <EditorClip>[];
  String? _selectedId;
  bool _playing = false;
  bool _importing = false;
  VideoPlayerController? _video;
  Timer? _imageTimer;

  /// Bumped whenever playback is restarted or cancelled, so that slow
  /// asynchronous work from an older request can tell it is out of date.
  int _runToken = 0;
  int _idCounter = 0;

  static const Duration _defaultPhotoLength = Duration(seconds: 3);
  static const Duration _maxPhotoLength = Duration(seconds: 10);

  int get _selectedIndex {
    if (_selectedId == null) return -1;
    return _clips.indexWhere((EditorClip c) => c.id == _selectedId);
  }

  @override
  void dispose() {
    _runToken++;
    _imageTimer?.cancel();
    _disposeVideo();
    super.dispose();
  }

  // ------------------------------------------------------------- helpers

  String _fmt(Duration d) {
    final int tenths = d.inMilliseconds ~/ 100;
    final int m = tenths ~/ 600;
    final int sec = (tenths ~/ 10) % 60;
    final int t = tenths % 10;
    return '$m:${sec.toString().padLeft(2, '0')}.$t';
  }

  /// Dispose a controller only after the frame that stops showing it, so the
  /// VideoPlayer widget never draws a controller that is already disposed.
  void _disposeVideo() {
    final VideoPlayerController? v = _video;
    if (v == null) return;
    _video = null;
    v.removeListener(_onVideoTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      v.dispose();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _disposeLater(VideoPlayerController v) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      v.dispose();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  // -------------------------------------------------------------- import

  Future<void> _import(AppState s, {required bool video}) async {
    if (_importing) return;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    setState(() => _importing = true);
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: video ? FileType.video : FileType.image,
        allowMultiple: true,
      );
      if (result == null) return;

      for (final PlatformFile f in result.files) {
        final String? path = f.path;
        if (path == null) continue;

        Duration duration = _maxPhotoLength;
        if (video) {
          final VideoPlayerController probe =
              VideoPlayerController.file(File(path));
          try {
            await probe.initialize();
            duration = probe.value.duration;
          } catch (_) {
            duration = Duration.zero;
          }
          await probe.dispose();
          if (duration <= Duration.zero) {
            messenger.showSnackBar(
              SnackBar(content: Text('${s.t('ed.unreadable')} ${f.name}')),
            );
            continue;
          }
        }

        if (!mounted) return;
        _idCounter++;
        final EditorClip clip = EditorClip(
          id: 'clip$_idCounter',
          path: path,
          name: f.name,
          isVideo: video,
          duration: duration,
          initialLength: video ? null : _defaultPhotoLength,
        );
        final bool first = _clips.isEmpty;
        setState(() => _clips.add(clip));
        if (first) {
          _showClip(0, autoplay: false);
        }
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(s.t('ed.unreadable'))));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  // ------------------------------------------------------------ playback

  Future<void> _showClip(int index, {required bool autoplay}) async {
    final int token = ++_runToken;
    _imageTimer?.cancel();
    _disposeVideo();

    if (index < 0 || index >= _clips.length) {
      if (mounted) setState(() => _playing = false);
      return;
    }

    final EditorClip clip = _clips[index];
    setState(() {
      _selectedId = clip.id;
      _playing = autoplay;
    });

    if (!clip.isVideo) {
      if (autoplay) {
        _imageTimer = Timer(clip.length, () {
          if (token == _runToken && mounted) _advance(index);
        });
      }
      return;
    }

    final VideoPlayerController ctrl =
        VideoPlayerController.file(File(clip.path));
    try {
      await ctrl.initialize();
      if (token != _runToken || !mounted) {
        _disposeLater(ctrl);
        return;
      }
      await ctrl.seekTo(clip.trimStart);
      if (token != _runToken || !mounted) {
        _disposeLater(ctrl);
        return;
      }
      ctrl.addListener(_onVideoTick);
      setState(() => _video = ctrl);
      if (autoplay) await ctrl.play();
    } catch (_) {
      ctrl.removeListener(_onVideoTick);
      if (identical(_video, ctrl)) _video = null;
      _disposeLater(ctrl);
      if (token == _runToken && mounted) {
        setState(() => _playing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppScope.of(context).t('ed.unreadable'))),
        );
      }
    }
  }

  void _onVideoTick() {
    final VideoPlayerController? v = _video;
    if (v == null || !mounted) return;
    final int idx = _selectedIndex;
    if (idx < 0) return;
    final EditorClip c = _clips[idx];
    final bool reachedEnd = v.value.position >=
        c.trimEnd - const Duration(milliseconds: 50);
    if (_playing && reachedEnd) {
      _advance(idx);
      return;
    }
    setState(() {});
  }

  void _advance(int index) {
    if (index + 1 < _clips.length) {
      _showClip(index + 1, autoplay: true);
    } else {
      // Finished the last clip: go back to the first, paused.
      _showClip(0, autoplay: false);
    }
  }

  Future<void> _togglePlay() async {
    if (_clips.isEmpty) return;
    if (_playing) {
      _runToken++;
      _imageTimer?.cancel();
      await _video?.pause();
      if (mounted) setState(() => _playing = false);
      return;
    }
    final int idx = _selectedIndex < 0 ? 0 : _selectedIndex;
    await _showClip(idx, autoplay: true);
  }

  /// Stop playback and drop the player, used before structural edits.
  void _pauseForEdit() {
    _runToken++;
    _imageTimer?.cancel();
    _disposeVideo();
    _playing = false;
  }

  // --------------------------------------------------------------- edits

  void _reorder(int oldIndex, int newIndex) {
    _pauseForEdit();
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final EditorClip item = _clips.removeAt(oldIndex);
      _clips.insert(newIndex, item);
    });
  }

  void _deleteSelected() {
    final int i = _selectedIndex;
    if (i < 0) return;
    _pauseForEdit();
    setState(() {
      _clips.removeAt(i);
      if (_clips.isEmpty) {
        _selectedId = null;
      } else {
        _selectedId = _clips[i < _clips.length ? i : _clips.length - 1].id;
      }
    });
  }

  void _trimVideo(EditorClip c, RangeValues v) {
    if (v.end - v.start < 500) return;
    _runToken++;
    _imageTimer?.cancel();
    _video?.pause();
    setState(() {
      _playing = false;
      c.trimStart = Duration(milliseconds: v.start.round());
      c.trimEnd = Duration(milliseconds: v.end.round());
    });
  }

  void _setPhotoLength(EditorClip c, double seconds) {
    _runToken++;
    _imageTimer?.cancel();
    setState(() {
      _playing = false;
      c.trimEnd = Duration(milliseconds: (seconds * 1000).round());
    });
  }

  // ------------------------------------------------------------------ UI

  Widget _buildPreview(AppState s, EditorClip? clip) {
    final VideoPlayerController? v = _video;
    Widget content;
    if (v != null && v.value.isInitialized) {
      content = Center(
        child: AspectRatio(
          aspectRatio: v.value.aspectRatio,
          child: VideoPlayer(v),
        ),
      );
    } else if (clip != null && !clip.isVideo) {
      content = Image.file(
        File(clip.path),
        fit: BoxFit.contain,
        cacheWidth: 1280,
        errorBuilder: (BuildContext c, Object e, StackTrace? st) =>
            const Center(
          child: Icon(Icons.broken_image_outlined, color: NvColors.textMuted),
        ),
      );
    } else {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.movie_creation_outlined,
                  size: 40, color: NvColors.textMuted),
              const SizedBox(height: 8),
              Text(
                clip == null ? s.t('ed.preview.empty') : clip.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: NvColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NvColors.border),
        ),
        child: content,
      ),
    );
  }

  Widget _buildProperties(AppState s, EditorClip clip) {
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            clip.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (clip.isVideo) ...<Widget>[
            Text(
              '${s.t('ed.trim')}: ${_fmt(clip.trimStart)} - ${_fmt(clip.trimEnd)}',
              style: const TextStyle(color: NvColors.textMuted),
            ),
            RangeSlider(
              values: RangeValues(
                clip.trimStart.inMilliseconds.toDouble(),
                clip.trimEnd.inMilliseconds.toDouble(),
              ),
              min: 0,
              max: clip.sourceDuration.inMilliseconds.toDouble(),
              onChanged: (RangeValues v) => _trimVideo(clip, v),
            ),
          ] else ...<Widget>[
            Text(
              '${s.t('ed.duration')}: ${_fmt(clip.length)}',
              style: const TextStyle(color: NvColors.textMuted),
            ),
            Slider(
              value: (clip.trimEnd.inMilliseconds / 1000.0).clamp(1.0, 10.0),
              min: 1,
              max: 10,
              divisions: 18,
              onChanged: (double v) => _setPhotoLength(clip, v),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _deleteSelected,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(s.t('ed.delete')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppState s = AppScope.of(context);
    final int sel = _selectedIndex;
    final EditorClip? clip = sel >= 0 ? _clips[sel] : null;
    Duration total = Duration.zero;
    for (final EditorClip c in _clips) {
      total += c.length;
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.t('tool.editor'))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            _buildPreview(s, clip),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _clips.isEmpty ? null : _togglePlay,
              icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
              label: Text(s.t(_playing ? 'ed.pause' : 'ed.play')),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        _importing ? null : () => _import(s, video: true),
                    icon: const Icon(Icons.video_library_outlined),
                    label: Text(s.t('ed.import.video')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        _importing ? null : () => _import(s, video: false),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(s.t('ed.import.image')),
                  ),
                ),
              ],
            ),
            if (_importing) ...<Widget>[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 6),
            Text(
              s.t('ed.local.note'),
              style: const TextStyle(
                color: NvColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            SectionTitle(s.t('ed.timeline')),
            if (_clips.isEmpty)
              Panel(
                child: Text(
                  s.t('ed.timeline.empty'),
                  style: const TextStyle(
                    color: NvColors.textMuted,
                    height: 1.4,
                  ),
                ),
              )
            else ...<Widget>[
              Text(
                s
                    .t('ed.total')
                    .replaceAll('{t}', _fmt(total))
                    .replaceAll('{n}', _clips.length.toString()),
                style: const TextStyle(color: NvColors.textMuted),
              ),
              const SizedBox(height: 10),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: _clips.length,
                onReorder: _reorder,
                itemBuilder: (BuildContext context, int i) {
                  final EditorClip c = _clips[i];
                  return Padding(
                    key: ValueKey<String>(c.id),
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _showClip(i, autoplay: false),
                      child: Panel(
                        borderColor: i == sel ? NvColors.violet : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              c.isVideo
                                  ? Icons.movie_outlined
                                  : Icons.image_outlined,
                              color: NvColors.cyan,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    c.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _fmt(c.length),
                                    style: const TextStyle(
                                      color: NvColors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ReorderableDragStartListener(
                              index: i,
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.drag_handle,
                                  color: NvColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            if (clip != null) ...<Widget>[
              const SizedBox(height: 12),
              _buildProperties(s, clip),
            ],
            const SizedBox(height: 16),
            Panel(
              borderColor: NvColors.warning.withAlpha(120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.info_outline,
                          color: NvColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        s.t('ed.export'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.t('ed.export.note'),
                    style: const TextStyle(
                      color: NvColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.t('ed.session.note'),
                    style: const TextStyle(
                      color: NvColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
