import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game/placement.dart';
import 'yurt_art.dart';

const _red = Color(0xffd9473a);
const _ink = Color(0xff382d36);
const _paper = Color(0xfffff9ed);

class YurtHome extends StatefulWidget {
  const YurtHome({super.key});

  @override
  State<YurtHome> createState() => _YurtHomeState();
}

class _YurtHomeState extends State<YurtHome> {
  int best = 0, games = 0, totalFloors = 0, bestCombo = 0, skin = 0;
  bool sound = true, music = true, haptics = true;
  String language = 'ru';
  bool loaded = false;

  static const _translations = <String, Map<String, String>>{
    'ru': {
      'title': 'ЮРТА-СТЕК', 'subtitle': 'Собери башню до облаков', 'play': 'Играть',
      'skins': 'Украшения', 'stats': 'Статистика', 'settings': 'Настройки',
      'best': 'Рекорд', 'floors': 'Этажи', 'combo': 'Лучшее комбо',
      'games': 'Игры', 'back': 'Назад', 'again': 'Ещё раз', 'menu': 'В меню',
      'paused': 'Пауза', 'resume': 'Продолжить', 'newBest': 'НОВЫЙ РЕКОРД!',
      'sound': 'Звуки', 'music': 'Музыка', 'haptics': 'Виброотклик',
      'language': 'Язык', 'locked': 'Откроется на', 'gameOver': 'Башня рухнула',
      'tap': 'Нажми, чтобы бросить юрту', 'world0': 'СТЕПЬ', 'world1': 'ГОРЫ',
      'world2': 'ЗАКАТ', 'world3': 'КОСМОС', 'floor': 'ЭТАЖ',
    },
    'en': {
      'title': 'YURT STACK', 'subtitle': 'Stack your way to the clouds', 'play': 'Play',
      'skins': 'Skins', 'stats': 'Statistics', 'settings': 'Settings',
      'best': 'Best', 'floors': 'Floors', 'combo': 'Best combo',
      'games': 'Games', 'back': 'Back', 'again': 'Play again', 'menu': 'Menu',
      'paused': 'Paused', 'resume': 'Resume', 'newBest': 'NEW RECORD!',
      'sound': 'Sound', 'music': 'Music', 'haptics': 'Haptics',
      'language': 'Language', 'locked': 'Unlock at', 'gameOver': 'Tower fell',
      'tap': 'Tap to drop your yurt', 'world0': 'STEPPE', 'world1': 'MOUNTAINS',
      'world2': 'SUNSET', 'world3': 'SPACE', 'floor': 'FLOOR',
    },
    'ky': {
      'title': 'БОЗ ҮЙ STACK', 'subtitle': 'Булуттарга чейин мунара кур', 'play': 'Ойноо',
      'skins': 'Кооздуктар', 'stats': 'Статистика', 'settings': 'Жөндөөлөр',
      'best': 'Рекорд', 'floors': 'Кабаттар', 'combo': 'Мыкты комбо',
      'games': 'Оюндар', 'back': 'Артка', 'again': 'Кайра ойноо', 'menu': 'Меню',
      'paused': 'Тыныгуу', 'resume': 'Улантуу', 'newBest': 'ЖАҢЫ РЕКОРД!',
      'sound': 'Үн', 'music': 'Музыка', 'haptics': 'Дирилдөө',
      'language': 'Тил', 'locked': 'Ачылат', 'gameOver': 'Мунара кулады',
      'tap': 'Боз үйдү түшүрүү үчүн бас', 'world0': 'ТАЛАА', 'world1': 'ТООЛОР',
      'world2': 'КҮН БАТЫШЫ', 'world3': 'КЕЛЕЧЕК', 'floor': 'КАБАТ',
    },
  };

  String t(String key) => _translations[language]![key] ?? key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      best = p.getInt('best') ?? 0;
      games = p.getInt('games') ?? 0;
      totalFloors = p.getInt('totalFloors') ?? 0;
      bestCombo = p.getInt('bestCombo') ?? 0;
      skin = p.getInt('skin') ?? 0;
      sound = p.getBool('sound') ?? true;
      music = p.getBool('music') ?? true;
      haptics = p.getBool('haptics') ?? true;
      language = p.getString('language') ?? 'ru';
      loaded = true;
    });
  }

  Future<void> _save(String key, Object value) async {
    await (await SharedPreferences.getInstance()).setString(key, value.toString());
  }

  Future<void> _saveInt(String key, int value) async {
    await (await SharedPreferences.getInstance()).setInt(key, value);
  }

  Future<void> _saveBool(String key, bool value) async {
    await (await SharedPreferences.getInstance()).setBool(key, value);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xffbfe6f5), _paper, Color(0xfff9f1d8)],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: SteppePatternPainter())),
              SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: loaded
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const YurtEmblem(size: 128),
                            const SizedBox(height: 12),
                            SizedBox(height: 30, child: CustomPaint(painter: SteppePatternPainter())), 
                            const SizedBox(height: 8),
                            Text(t('title'), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: _ink, letterSpacing: 3)),
                            const SizedBox(height: 8),
                            Text(t('subtitle'), style: const TextStyle(color: _ink, fontSize: 16)),
                            const SizedBox(height: 24),
                            _statChip('${t('best')}: $best 🏆'),
                            const SizedBox(height: 20),
                            _button(t('play'), _red, Colors.white, () => _openGame()),
                            const SizedBox(height: 12),
                            Row(children: [
                              Expanded(child: _button(t('skins'), const Color(0xfff3c04c), _ink, _showSkins)),
                              const SizedBox(width: 12),
                              Expanded(child: _button(t('stats'), Colors.white, _ink, _showStats)),
                            ]),
                            const SizedBox(height: 12),
                            _button('⚙  ${t('settings')}', Colors.white.withValues(alpha: .75), _ink, _showSettings),
                          ],
                        )
                      : const CircularProgressIndicator(color: _red),
                ),
              ),
            ),
          ),
            ],
          ),
        ),
      );

  Widget _statChip(String label) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .78), borderRadius: BorderRadius.circular(24)),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: _ink)),
      );

  Widget _button(String label, Color color, Color foreground, VoidCallback onPressed) =>
      SizedBox(width: double.infinity, height: 54, child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: foreground, shape: const StadiumBorder(), textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        onPressed: onPressed,
        child: Text(label),
      ));

  void _openGame() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => _GameScreen(
        t: t, initialSkin: skin, sound: sound, haptics: haptics,
        onFinished: (score, combo) async {
          final isNew = score > best;
          setState(() {
            if (isNew) best = score;
            games++;
            totalFloors += score;
            bestCombo = math.max(bestCombo, combo);
          });
          await _saveInt('best', best);
          await _saveInt('games', games);
          await _saveInt('totalFloors', totalFloors);
          await _saveInt('bestCombo', bestCombo);
        },
      ),
    ));
  }

  void _showStats() => showDialog<void>(context: context, builder: (c) => AlertDialog(
        title: Text(t('stats')),
        content: Text('${t('best')}: $best\n${t('games')}: $games\n${t('floors')}: $totalFloors\n${t('combo')}: $bestCombo'),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(t('back'))],
      ));

  void _showSettings() => showDialog<void>(context: context, builder: (c) => StatefulBuilder(builder: (c, refresh) => AlertDialog(
        title: Text(t('settings')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          SwitchListTile(title: Text(t('sound')), value: sound, onChanged: (v) { setState(() => sound = v); refresh(() {}); _saveBool('sound', v); }),
          SwitchListTile(title: Text(t('music')), value: music, onChanged: (v) { setState(() => music = v); refresh(() {}); _saveBool('music', v); }),
          SwitchListTile(title: Text(t('haptics')), value: haptics, onChanged: (v) { setState(() => haptics = v); refresh(() {}); _saveBool('haptics', v); }),
          DropdownButton<String>(value: language, isExpanded: true, items: const [DropdownMenuItem(value: 'ru', child: Text('Русский')), DropdownMenuItem(value: 'en', child: Text('English')), DropdownMenuItem(value: 'ky', child: Text('Кыргызча'))], onChanged: (v) { if (v != null) { setState(() => language = v); refresh(() {}); _save('language', v); } }),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(t('back'))],
      )));

  void _showSkins() => showDialog<void>(context: context, builder: (c) => StatefulBuilder(builder: (c, refresh) => AlertDialog(
        title: Text(t('skins')),
        content: Column(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) {
          const names = ['🏕️ Юрта', '🌺 Наурыз', '🧶 Кошма', '✨ Шанырак', '🎄 Зима'];
          final unlocked = i == 0 || best >= [0, 25, 50, 100, 200][i];
          return ListTile(leading: Text(names[i].split(' ').first, style: const TextStyle(fontSize: 24)), title: Text(unlocked ? names[i] : '${t('locked')} ${[0, 25, 50, 100, 200][i]}'), trailing: skin == i ? const Icon(Icons.check, color: _red) : null, enabled: unlocked, onTap: unlocked ? () { setState(() => skin = i); _saveInt('skin', i); refresh(() {}); } : null);
        })),
        actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text(t('back'))],
      )));
}

class _GameScreen extends StatefulWidget {
  const _GameScreen({required this.t, required this.initialSkin, required this.sound, required this.haptics, required this.onFinished});
  final String Function(String) t;
  final int initialSkin;
  final bool sound, haptics;
  final Future<void> Function(int score, int combo) onFinished;

  @override
  State<_GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<_GameScreen> {
  late _StackGame game;
  bool ended = false, paused = false, newRecord = false;
  int finalScore = 0;
  @override
  void initState() {
    super.initState();
    game = _StackGame(skin: widget.initialSkin, sound: widget.sound, haptics: widget.haptics, t: widget.t, onGameOver: _finish);
  }

  Future<void> _finish(int score, int combo) async {
    if (!mounted || ended) return;
    final previous = (await SharedPreferences.getInstance()).getInt('best') ?? 0;
    if (!mounted) return;
    setState(() { ended = true; finalScore = score; newRecord = score > previous; });
    await widget.onFinished(score, combo);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          GameWidget<_StackGame>(game: game),
          SafeArea(child: Column(children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton.filledTonal(onPressed: () { setState(() => paused = !paused); game.paused = paused; }, icon: Icon(paused ? Icons.play_arrow : Icons.pause)),
              ValueListenableBuilder<int>(valueListenable: game.score, builder: (_, score, __) => Column(children: [Text('$score', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: _ink, shadows: [Shadow(color: Colors.white, blurRadius: 10)])), Text('${widget.t('floor')}  ${score + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: _ink))])),
              ValueListenableBuilder<int>(valueListenable: game.combo, builder: (_, value, __) => Text(value >= 2 ? '✨ x$value' : '')),
            ])),
            const Spacer(),
            if (!ended && !paused) Padding(padding: const EdgeInsets.only(bottom: 32), child: Text(widget.t('tap'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink))),
          ])),
          if (paused && !ended) _overlay(widget.t('paused'), [ _action(widget.t('resume'), () => setState(() { paused = false; game.paused = false; })), _action(widget.t('menu'), () => Navigator.pop(context)) ]),
          if (ended) _overlay(widget.t('gameOver'), [Text('$finalScore', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: _red)), if (newRecord) Text(widget.t('newBest'), style: const TextStyle(color: _red, fontWeight: FontWeight.w900)), _action(widget.t('again'), () { Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => _GameScreen(t: widget.t, initialSkin: widget.initialSkin, sound: widget.sound, haptics: widget.haptics, onFinished: widget.onFinished))); }), _action(widget.t('menu'), () => Navigator.pop(context))]),
        ]),
      );

  Widget _action(String label, VoidCallback action) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: SizedBox(width: 220, child: FilledButton(onPressed: action, child: Text(label))));
  Widget _overlay(String title, List<Widget> children) => Container(color: Colors.black.withValues(alpha: .35), child: Center(child: Card(color: _paper, child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: _ink)), const SizedBox(height: 12), ...children])))));
}

class _StackGame extends FlameGame with TapCallbacks {
  _StackGame({required this.skin, required this.sound, required this.haptics, required this.t, required this.onGameOver});
  final int skin;
  final bool sound, haptics;
  final String Function(String) t;
  final Future<void> Function(int, int) onGameOver;
  final score = ValueNotifier<int>(0);
  final combo = ValueNotifier<int>(0);
  final List<_Yurt> blocks = [];
  double blockWidth = 150, movingX = 0, speed = 170;
  int direction = 1;
  bool started = false, ended = false, paused = false;
  int peakCombo = 0;
  static const _worlds = [Color(0xffbfe6f5), Color(0xff9ad0ec), Color(0xff2b2e6b), Color(0xff0a0c1f)];
  static const _skins = [Color(0xffffffff), Color(0xffe86958), Color(0xffcf9a5a), Color(0xfff3c04c), Color(0xff5ce1e6)];

  @override
  Color backgroundColor() {
    final world = (score.value ~/ 25).clamp(0, 3);
    return _worlds[world.toInt()];
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (size.x <= 0 || size.y <= 0) return;
    final baseY = size.y - 62;
    if (blocks.isEmpty) blocks.add(_Yurt(left: (size.x - blockWidth) / 2, y: baseY, width: blockWidth, skin: skin, colors: _skins));
    if (!started) movingX = direction == 1 ? 0 : size.x - blockWidth;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!started || ended || paused || size.x <= 0) return;
    movingX += direction * speed * dt;
    if (movingX <= 0) { movingX = 0; direction = 1; }
    if (movingX + blockWidth >= size.x) { movingX = size.x - blockWidth; direction = -1; }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (size.x <= 0 || size.y <= 0) return;
    final world = (score.value ~/ 25).clamp(0, 3).toInt();
    final ground = Paint()..color = world == 3 ? const Color(0xff161431) : const Color(0xff8dbe63);
    canvas.drawRect(Rect.fromLTWH(0, size.y - 18, size.x, 18), ground);
    final horizon = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: world == 0
            ? const [Color(0xffbfe6f5), Color(0xfff9f1d8)]
            : world == 1
                ? const [Color(0xff9ad0ec), Color(0xffe3f2f9)]
                : world == 2
                    ? const [Color(0xff2b2e6b), Color(0xffe98a5d)]
                    : const [Color(0xff0a0c1f), Color(0xff2a1b54)],
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), horizon);
    canvas.drawRect(Rect.fromLTWH(0, size.y - 18, size.x, 18), ground);
    if (world >= 2) {
      final star = Paint()..color = Colors.white.withValues(alpha: .75);
      for (var i = 0; i < 32; i++) { final x = ((i * 83.7) % size.x); final y = ((i * 47.3) % (size.y * .65)); canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 2 : 1, star); }
    }
    final bottomY = size.y - 62;
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final cameraOffset = math.max(0, blocks.length - 8) * 39.0;
      final y = bottomY - (blocks.length - 1 - i) * 39.0 + cameraOffset;
      _drawYurt(canvas, block.left, y, block.width, block.color);
    }
    if (!ended) {
      final cameraOffset = math.max(0, blocks.length - 8) * 39.0;
      _drawYurt(canvas, movingX, bottomY - blocks.length * 39.0 + cameraOffset, blockWidth, _skins[skin % _skins.length]);
    }
    final worldLabel = ['world0', 'world1', 'world2', 'world3'][world];
    final label = TextPainter(text: TextSpan(text: t(worldLabel), style: TextStyle(color: world >= 2 ? Colors.white70 : _ink.withValues(alpha: .55), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)), textDirection: TextDirection.ltr)..layout();
    label.paint(canvas, Offset(size.x - label.width - 18, 24));
  }

  void _drawYurt(Canvas canvas, double x, double y, double width, Color color) {
    if (y < -45 || y > size.y + 50) return;
    final body = Paint()..color = color;
    final outline = Paint()..color = const Color(0xffd9473a)..style = PaintingStyle.stroke..strokeWidth = 3;
    final rect = Rect.fromLTWH(x + 2, y + 10, math.max(0, width - 4), 27);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(9)), body);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(9)), outline);
    final roof = Path()..moveTo(x + width * .39, y + 10)..quadraticBezierTo(x + width * .5, y - 2, x + width * .61, y + 10);
    canvas.drawPath(roof, outline);
    final trim = Paint()..color = const Color(0xffd9473a)..strokeWidth = 2;
    for (var i = 1; i < 5; i++) {
      final dx = x + width * i / 5;
      final diamond = Path()..moveTo(dx, y + 16)..lineTo(dx + 5, y + 23)..lineTo(dx, y + 30)..lineTo(dx - 5, y + 23)..close();
      canvas.drawPath(diamond, Paint()..color = i.isEven ? const Color(0xfff3c04c) : const Color(0xffd9473a));
    }
    canvas.drawLine(Offset(x + 7, y + 33), Offset(x + width - 7, y + 33), trim);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (ended || paused || size.x <= 0) return;
    started = true;
    if (haptics) HapticFeedback.selectionClick();
    final previous = blocks.last;
    final result = placeBlock(previousLeft: previous.left, previousWidth: previous.width, currentLeft: movingX, currentWidth: blockWidth);
    if (result.missed) {
      ended = true;
      if (sound) SystemSound.play(SystemSoundType.alert);
      onGameOver(score.value, peakCombo);
      return;
    }
    if (result.perfect) {
      combo.value++;
      peakCombo = math.max(peakCombo, combo.value);
      if (haptics) HapticFeedback.lightImpact();
      if (sound) SystemSound.play(SystemSoundType.click);
    } else {
      combo.value = 0;
      if (sound) SystemSound.play(SystemSoundType.click);
    }
    blockWidth = result.perfect && combo.value >= 5 ? math.min(150, result.width + 6) : result.width;
    blocks.add(_Yurt(left: result.left, y: 0, width: blockWidth, skin: skin, colors: _skins));
    score.value++;
    direction = -direction;
    movingX = direction == 1 ? 0 : size.x - blockWidth;
    speed = speedForFloor(score.value);
  }
}

class _Yurt {
  _Yurt({required this.left, required this.y, required this.width, required int skin, required List<Color> colors}) : color = colors[skin % colors.length];
  final double left, y, width;
  final Color color;
}
