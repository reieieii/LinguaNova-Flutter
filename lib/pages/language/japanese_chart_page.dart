import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';
import '../../presentation/widgets/glass_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

/// One cell in the Gojūon grid. [char] is null for placeholder "—" positions.
class _KanaCell {
  const _KanaCell(this.char, this.romaji);
  final String? char; // null = empty placeholder
  final String romaji;
}

/// One row in the Gojūon table (one consonant group).
class _KanaRow {
  const _KanaRow(this.label, this.cells);
  final String label; // "a", "k", "s", …
  final List<_KanaCell> cells; // always exactly 5 cells: a i u e o
}

// ── Hiragana table ────────────────────────────────────────────────────────────

const List<_KanaRow> _hiraganaRows = [
  _KanaRow('a', [
    _KanaCell('あ', 'a'), _KanaCell('い', 'i'), _KanaCell('う', 'u'),
    _KanaCell('え', 'e'), _KanaCell('お', 'o'),
  ]),
  _KanaRow('k', [
    _KanaCell('か', 'ka'), _KanaCell('き', 'ki'), _KanaCell('く', 'ku'),
    _KanaCell('け', 'ke'), _KanaCell('こ', 'ko'),
  ]),
  _KanaRow('s', [
    _KanaCell('さ', 'sa'), _KanaCell('し', 'shi'), _KanaCell('す', 'su'),
    _KanaCell('せ', 'se'), _KanaCell('そ', 'so'),
  ]),
  _KanaRow('t', [
    _KanaCell('た', 'ta'), _KanaCell('ち', 'chi'), _KanaCell('つ', 'tsu'),
    _KanaCell('て', 'te'), _KanaCell('と', 'to'),
  ]),
  _KanaRow('n', [
    _KanaCell('な', 'na'), _KanaCell('に', 'ni'), _KanaCell('ぬ', 'nu'),
    _KanaCell('ね', 'ne'), _KanaCell('の', 'no'),
  ]),
  _KanaRow('h', [
    _KanaCell('は', 'ha'), _KanaCell('ひ', 'hi'), _KanaCell('ふ', 'fu'),
    _KanaCell('へ', 'he'), _KanaCell('ほ', 'ho'),
  ]),
  _KanaRow('m', [
    _KanaCell('ま', 'ma'), _KanaCell('み', 'mi'), _KanaCell('む', 'mu'),
    _KanaCell('め', 'me'), _KanaCell('も', 'mo'),
  ]),
  _KanaRow('y', [
    _KanaCell('や', 'ya'), _KanaCell(null, '—'), _KanaCell('ゆ', 'yu'),
    _KanaCell(null, '—'), _KanaCell('よ', 'yo'),
  ]),
  _KanaRow('r', [
    _KanaCell('ら', 'ra'), _KanaCell('り', 'ri'), _KanaCell('る', 'ru'),
    _KanaCell('れ', 're'), _KanaCell('ろ', 'ro'),
  ]),
  _KanaRow('w', [
    _KanaCell('わ', 'wa'), _KanaCell(null, '—'), _KanaCell(null, '—'),
    _KanaCell(null, '—'), _KanaCell('を', 'o'),
  ]),
  _KanaRow('n', [
    _KanaCell('ん', 'n'), _KanaCell(null, '—'), _KanaCell(null, '—'),
    _KanaCell(null, '—'), _KanaCell(null, '—'),
  ]),
];

// ── Katakana table ────────────────────────────────────────────────────────────

const List<_KanaRow> _katakanaRows = [
  _KanaRow('a', [
    _KanaCell('ア', 'a'), _KanaCell('イ', 'i'), _KanaCell('ウ', 'u'),
    _KanaCell('エ', 'e'), _KanaCell('オ', 'o'),
  ]),
  _KanaRow('k', [
    _KanaCell('カ', 'ka'), _KanaCell('キ', 'ki'), _KanaCell('ク', 'ku'),
    _KanaCell('ケ', 'ke'), _KanaCell('コ', 'ko'),
  ]),
  _KanaRow('s', [
    _KanaCell('サ', 'sa'), _KanaCell('シ', 'shi'), _KanaCell('ス', 'su'),
    _KanaCell('セ', 'se'), _KanaCell('ソ', 'so'),
  ]),
  _KanaRow('t', [
    _KanaCell('タ', 'ta'), _KanaCell('チ', 'chi'), _KanaCell('ツ', 'tsu'),
    _KanaCell('テ', 'te'), _KanaCell('ト', 'to'),
  ]),
  _KanaRow('n', [
    _KanaCell('ナ', 'na'), _KanaCell('ニ', 'ni'), _KanaCell('ヌ', 'nu'),
    _KanaCell('ネ', 'ne'), _KanaCell('ノ', 'no'),
  ]),
  _KanaRow('h', [
    _KanaCell('ハ', 'ha'), _KanaCell('ヒ', 'hi'), _KanaCell('フ', 'fu'),
    _KanaCell('ヘ', 'he'), _KanaCell('ホ', 'ho'),
  ]),
  _KanaRow('m', [
    _KanaCell('マ', 'ma'), _KanaCell('ミ', 'mi'), _KanaCell('ム', 'mu'),
    _KanaCell('メ', 'me'), _KanaCell('モ', 'mo'),
  ]),
  _KanaRow('y', [
    _KanaCell('ヤ', 'ya'), _KanaCell(null, '—'), _KanaCell('ユ', 'yu'),
    _KanaCell(null, '—'), _KanaCell('ヨ', 'yo'),
  ]),
  _KanaRow('r', [
    _KanaCell('ラ', 'ra'), _KanaCell('リ', 'ri'), _KanaCell('ル', 'ru'),
    _KanaCell('レ', 're'), _KanaCell('ロ', 'ro'),
  ]),
  _KanaRow('w', [
    _KanaCell('ワ', 'wa'), _KanaCell(null, '—'), _KanaCell(null, '—'),
    _KanaCell(null, '—'), _KanaCell('ヲ', 'o'),
  ]),
  _KanaRow('n', [
    _KanaCell('ン', 'n'), _KanaCell(null, '—'), _KanaCell(null, '—'),
    _KanaCell(null, '—'), _KanaCell(null, '—'),
  ]),
];

// ─────────────────────────────────────────────────────────────────────────────
// Vocabulary examples
// ─────────────────────────────────────────────────────────────────────────────

class _VocabItem {
  const _VocabItem({
    required this.kana,
    required this.romaji,
    required this.meaning,
  });
  final String kana;
  final String romaji;
  final String meaning;
}

const List<_VocabItem> _hiraganaVocab = [
  _VocabItem(kana: 'すし', romaji: 'sushi', meaning: 'Sushi'),
  _VocabItem(kana: 'ねこ', romaji: 'neko', meaning: 'Cat'),
  _VocabItem(kana: 'いぬ', romaji: 'inu', meaning: 'Dog'),
  _VocabItem(kana: 'みず', romaji: 'mizu', meaning: 'Water'),
  _VocabItem(kana: 'はな', romaji: 'hana', meaning: 'Flower'),
  _VocabItem(kana: 'やま', romaji: 'yama', meaning: 'Mountain'),
  _VocabItem(kana: 'かわ', romaji: 'kawa', meaning: 'River'),
  _VocabItem(kana: 'そら', romaji: 'sora', meaning: 'Sky'),
];

const List<_VocabItem> _katakanaVocab = [
  _VocabItem(kana: 'タクシー', romaji: 'takushī', meaning: 'Taxi'),
  _VocabItem(kana: 'コーヒー', romaji: 'kōhī', meaning: 'Coffee'),
  _VocabItem(kana: 'テレビ', romaji: 'terebi', meaning: 'Television'),
  _VocabItem(kana: 'パン', romaji: 'pan', meaning: 'Bread'),
  _VocabItem(kana: 'アイス', romaji: 'aisu', meaning: 'Ice cream'),
  _VocabItem(kana: 'ノート', romaji: 'nōto', meaning: 'Notebook'),
  _VocabItem(kana: 'スマホ', romaji: 'sumaho', meaning: 'Smartphone'),
  _VocabItem(kana: 'カメラ', romaji: 'kamera', meaning: 'Camera'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Page widget
// ─────────────────────────────────────────────────────────────────────────────

/// Pass [chartType] = `'hiragana'` or `'katakana'`.
class JapaneseChartPage extends StatefulWidget {
  const JapaneseChartPage({
    super.key,
    required this.languageId,
    required this.chartType,
  });

  final String languageId;
  final String chartType; // 'hiragana' | 'katakana'

  @override
  State<JapaneseChartPage> createState() => _JapaneseChartPageState();
}

class _JapaneseChartPageState extends State<JapaneseChartPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Highlighted cell (row index, col index); null means none selected.
  int? _highlightRow;
  int? _highlightCol;

  bool get _isHiragana => widget.chartType == 'hiragana';
  List<_KanaRow> get _rows => _isHiragana ? _hiraganaRows : _katakanaRows;
  List<_VocabItem> get _vocab =>
      _isHiragana ? _hiraganaVocab : _katakanaVocab;
  Color get _accent =>
      _isHiragana ? AppColors.brand300 : const Color(0xFF60A5FA);
  String get _chartLabel => _isHiragana ? 'HIRAGANA' : 'KATAKANA';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = _isHiragana ? 0 : 1;
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final dest =
        _tabController.index == 0 ? 'hiragana-chart' : 'katakana-chart';
    context.go('/language/${widget.languageId}/study/$dest');
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumb(),
            const SizedBox(height: 20),
            _buildHeader(isMobile),
            const SizedBox(height: 24),
            _buildTabSwitcher(isMobile),
            const SizedBox(height: 20),
            _buildChartCard(isMobile),
            const SizedBox(height: 24),
            _buildVocabSection(isMobile),
            const SizedBox(height: 32),
            _buildQuizCta(isMobile),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── Breadcrumb ──────────────────────────────────────────────────────────────

  Widget _buildBreadcrumb() {
    final lang = widget.languageId;
    final langLabel =
        '${lang.substring(0, 1).toUpperCase()}${lang.substring(1)}';
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 2,
      children: [
        _crumbTap(langLabel, () => context.go('/language/$lang')),
        _crumbSep,
        _crumbTap('Study', () => context.go('/language/$lang/study')),
        _crumbSep,
        Text(
          '$_chartLabel CHART',
          style: TextStyle(
            color: _accent,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _crumbTap(String label, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      );

  static const Widget _crumbSep = Text(
    ' / ',
    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
  );

  // ─── Page header ─────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isMobile) {
    final title =
        _isHiragana ? 'Hiragana Chart (Gojūon)' : 'Katakana Chart (Gojūon)';
    final subtitle = _isHiragana
        ? 'The 46 basic Hiragana characters for native Japanese words and grammar.'
        : 'The 46 basic Katakana characters for loanwords and foreign names.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _accent.withValues(alpha: 0.35)),
              ),
              child: Center(
                child: Text(
                  _isHiragana ? 'あ' : 'ア',
                  style: TextStyle(
                    color: _accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 20 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip(Icons.grid_view_rounded, '46 characters'),
            _chip(Icons.view_week_rounded, '5 vowel columns (a i u e o)'),
            _chip(Icons.sort_rounded, '10 consonant rows'),
            _chip(
              _isHiragana
                  ? Icons.auto_stories_rounded
                  : Icons.flight_rounded,
              _isHiragana ? 'Native words & grammar' : 'Loanwords & katakana',
            ),
          ],
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accent.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: _accent),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: _accent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  // ─── Tab switcher ────────────────────────────────────────────────────────────

  Widget _buildTabSwitcher(bool isMobile) {
    return GlassCard(
      padding: const EdgeInsets.all(6),
      borderRadius: 14,
      child: Row(
        children: [
          _tabBtn('Hiragana  ひらがな', 0, AppColors.brand300, isMobile),
          const SizedBox(width: 6),
          _tabBtn('Katakana  カタカナ', 1, const Color(0xFF60A5FA), isMobile),
        ],
      ),
    );
  }

  Widget _tabBtn(
      String label, int idx, Color color, bool isMobile) {
    final active = _tabController.index == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_tabController.index != idx) {
            setState(() => _tabController.animateTo(idx));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 10 : 12,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: active ? color.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  active ? color.withValues(alpha: 0.5) : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? color : AppColors.textMuted,
              fontSize: isMobile ? 12 : 14,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Gojūon chart card ────────────────────────────────────────────────────────

  Widget _buildChartCard(bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          Row(
            children: [
              Icon(Icons.grid_on_rounded, color: _accent, size: 18),
              const SizedBox(width: 8),
              Text(
                '$_chartLabel CHART (GOJŪON)',
                style: TextStyle(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap any character to highlight it.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
          const SizedBox(height: 16),
          // The table scrolls horizontally on narrow screens
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildTable(isMobile),
          ),
          const SizedBox(height: 14),
          // Legend
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _legendDot(_accent, 'Active character'),
              _legendDot(
                  AppColors.textMuted.withValues(alpha: 0.4), '— No sound here'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      );

  // ─── Table grid ──────────────────────────────────────────────────────────────

  Widget _buildTable(bool isMobile) {
    const colVowels = ['', 'a', 'i', 'u', 'e', 'o'];
    final cellW = isMobile ? 52.0 : 72.0;
    final cellH = isMobile ? 54.0 : 74.0;
    final labelW = isMobile ? 22.0 : 28.0;
    final charSize = isMobile ? 18.0 : 22.0;
    final romajiSize = isMobile ? 9.0 : 11.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column headers row (a i u e o)
        Row(
          children: colVowels.asMap().entries.map((e) {
            final isLabel = e.key == 0;
            return SizedBox(
              width: isLabel ? labelW : cellW,
              child: Center(
                child: Text(
                  e.value,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        // Data rows
        ..._rows.asMap().entries.map((rowEntry) {
          final rIdx = rowEntry.key;
          final row = rowEntry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                // Row label
                SizedBox(
                  width: labelW,
                  child: Center(
                    child: Text(
                      row.label,
                      style: TextStyle(
                        color: _accent.withValues(alpha: 0.7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Cells
                ...row.cells.asMap().entries.map((cellEntry) {
                  final cIdx = cellEntry.key;
                  final cell = cellEntry.value;
                  final isEmpty = cell.char == null;
                  final isHl = _highlightRow == rIdx && _highlightCol == cIdx;

                  return GestureDetector(
                    onTap: isEmpty
                        ? null
                        : () => setState(() {
                              if (isHl) {
                                _highlightRow = null;
                                _highlightCol = null;
                              } else {
                                _highlightRow = rIdx;
                                _highlightCol = cIdx;
                              }
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: cellW,
                      height: cellH,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isEmpty
                            ? Colors.white.withValues(alpha: 0.02)
                            : isHl
                                ? _accent.withValues(alpha: 0.22)
                                : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isEmpty
                              ? Colors.white.withValues(alpha: 0.05)
                              : isHl
                                  ? _accent.withValues(alpha: 0.65)
                                  : Colors.white.withValues(alpha: 0.09),
                        ),
                      ),
                      child: isEmpty
                          ? Center(
                              child: Text(
                                '—',
                                style: TextStyle(
                                  color: AppColors.textMuted
                                      .withValues(alpha: 0.35),
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cell.char!,
                                  style: TextStyle(
                                    color: isHl ? _accent : Colors.white,
                                    fontSize: charSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cell.romaji,
                                  style: TextStyle(
                                    color: isHl
                                        ? _accent
                                        : AppColors.textMuted,
                                    fontSize: romajiSize,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── Vocabulary section ───────────────────────────────────────────────────────

  Widget _buildVocabSection(bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section heading
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: _accent, size: 18),
              const SizedBox(width: 8),
              Text(
                'EXAMPLE VOCABULARY',
                style: TextStyle(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _isHiragana
                ? 'Common words written entirely in Hiragana.'
                : 'Loanwords typically written in Katakana.',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          // Column headers
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    _isHiragana ? 'Hiragana' : 'Katakana',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Romaji',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'Meaning',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Divider
          const Divider(color: Color(0x1AFFFFFF), height: 1),
          const SizedBox(height: 4),
          // Vocab rows
          ..._vocab.asMap().entries.map((e) {
            final isLast = e.key == _vocab.length - 1;
            final item = e.value;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : const Border(
                        bottom: BorderSide(color: Color(0x1AFFFFFF)),
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Kana word
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.kana,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Romaji
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.romaji,
                      style: TextStyle(
                        color: _accent,
                        fontSize: isMobile ? 12 : 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // Meaning
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.meaning,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── Quiz CTA banner ─────────────────────────────────────────────────────────

  Widget _buildQuizCta(bool isMobile) {
    final lang = widget.languageId;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.18),
            AppColors.brand900.withValues(alpha: 0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _accent.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ctaText(isMobile),
                const SizedBox(height: 14),
                GlassButton(
                  onPressed: () =>
                      context.go('/language/$lang/practice/hiragana'),
                  variant: GlassButtonVariant.primary,
                  fullWidth: true,
                  icon: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 18),
                  child: const Text('Ready to test yourself?'),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: _ctaText(isMobile)),
                const SizedBox(width: 20),
                GlassButton(
                  onPressed: () =>
                      context.go('/language/$lang/practice/hiragana'),
                  variant: GlassButtonVariant.primary,
                  icon: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 18),
                  child: const Text('Ready to test yourself?'),
                ),
              ],
            ),
    );
  }

  Widget _ctaText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to test yourself?',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Practice recognising ${_isHiragana ? "Hiragana" : "Katakana"} characters with our interactive quiz.',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
