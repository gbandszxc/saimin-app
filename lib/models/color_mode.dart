/// 配色模式枚举
enum ColorMode {
  bw('黑白'),
  rainbow('彩虹'),
  neon('霓虹'),
  pinkHeart('粉白');

  final String label;

  const ColorMode(this.label);
}
