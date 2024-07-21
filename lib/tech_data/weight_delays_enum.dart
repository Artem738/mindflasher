enum WeightDelaysEnum {
  noDelay(0, 'noDelay'),
  badSmallDelay(1, 'badSmallDelay'),
  normMedDelay(10, 'normMedDelay'),
  goodLongDelay(100, 'goodLongDelay');

  final int value;
  final String name;

  const WeightDelaysEnum(this.value, this.name);
}
