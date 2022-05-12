import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'event_data.g.dart';

@HiveType(typeId: 0)
class Event extends HiveObject {
  Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.backgroundColor,
    required this.isAllDay,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime from;

  @HiveField(3)
  DateTime to;

  @HiveField(4)
  int backgroundColor;

  @HiveField(5)
  bool isAllDay;
}
