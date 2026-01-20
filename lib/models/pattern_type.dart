/// 图案类型枚举
enum PatternType {
  spiral('螺旋'),
  circles('同心圆'),
  vortex('漩涡'),
  heart('爱心');

  final String label;

  const PatternType(this.label);
}
