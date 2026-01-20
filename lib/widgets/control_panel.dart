import 'package:flutter/material.dart';
import '../models/pattern_type.dart';
import '../models/color_mode.dart';

/// 控制面板组件
class ControlPanel extends StatelessWidget {
  final bool isPlaying;
  final double speed;
  final PatternType patternType;
  final ColorMode colorMode;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<PatternType> onPatternChanged;
  final ValueChanged<ColorMode> onColorModeChanged;

  const ControlPanel({
    super.key,
    required this.isPlaying,
    required this.speed,
    required this.patternType,
    required this.colorMode,
    required this.onPlayPause,
    required this.onReset,
    required this.onSpeedChanged,
    required this.onPatternChanged,
    required this.onColorModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 播放控制行
          _buildPlaybackControls(),
          const SizedBox(height: 16),

          // 速度控制
          _buildSpeedControl(),
          const SizedBox(height: 16),

          // 图案类型选择
          _buildPatternSelector(),
          const SizedBox(height: 16),

          // 配色模式选择
          _buildColorModeSelector(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(
          icon: isPlaying ? Icons.pause : Icons.play_arrow,
          onTap: onPlayPause,
        ),
        const SizedBox(width: 24),
        _buildIconButton(
          icon: Icons.refresh,
          onTap: onReset,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '速度: ${speed.toStringAsFixed(1)}x',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Slider(
            value: speed,
            min: 0.1,
            max: 3.0,
            divisions: 29,
            activeColor: Colors.white,
            inactiveColor: Colors.white24,
            thumbColor: Colors.white,
            onChanged: onSpeedChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildPatternSelector() {
    return _buildSelector(
      title: '图案类型',
      values: PatternType.values,
      selectedValue: patternType,
      onChanged: onPatternChanged,
    );
  }

  Widget _buildColorModeSelector() {
    return _buildSelector(
      title: '颜色模式',
      values: ColorMode.values,
      selectedValue: colorMode,
      onChanged: onColorModeChanged,
    );
  }

  Widget _buildSelector<T>({
    required String title,
    required List<T> values,
    required T selectedValue,
    required ValueChanged<T> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: values.map((value) {
              final isSelected = value == selectedValue;
              final label = _getLabel(value);
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildSelectButton(
                    label: label,
                    isSelected: isSelected,
                    onTap: () => onChanged(value),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: isSelected ? Colors.white : Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _getLabel(dynamic value) {
    if (value is PatternType) return value.label;
    if (value is ColorMode) return value.label;
    return '';
  }
}
