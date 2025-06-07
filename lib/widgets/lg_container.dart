import 'package:flutter/material.dart';

class ContainerProperties {
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final Color? color;
  final BoxConstraints? constraints;
  final BoxDecoration? decoration;
  final Decoration? foregroundDecoration;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final double? width;

  const ContainerProperties({
    this.alignment,
    this.clipBehavior = Clip.none,
    this.color,
    this.constraints,
    this.decoration,
    this.foregroundDecoration,
    this.height,
    this.margin,
    this.padding,
    this.transform,
    this.transformAlignment,
    this.width,
  });
}

class ColumnRowProperties {
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;

  const ColumnRowProperties({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection,
    this.textBaseline,
  });
}

class LGContainer extends StatelessWidget {
  final ContainerProperties? containerProperties;
  final ColumnRowProperties? columnProperties;
  final ColumnRowProperties? rowProperties;

  final dynamic contain;
  final int columns;
  final double columnSpacing;
  final double rowSpacing;

  const LGContainer({
    super.key,
    this.containerProperties,
    this.contain,
    this.columns = 1,
    this.columnProperties,
    this.rowProperties,
    this.columnSpacing = 0,
    this.rowSpacing = 0,
  }) : assert(
         contain == null || contain is Widget || contain is List<Widget>,
         'LGContainer can only contain a widget, list of widget or null',
       ),
       assert(
         columns >= 1,
         'Column counts must be positive integers from 1 or more',
       );

  @override
  Widget build(BuildContext context) {
    Widget? content = contain is Widget ? contain as Widget : null;

    if (contain is List<Widget>) {
      final items = contain as List<Widget>;

      if (columns == 1) {
        // Single column with vertical spacing
        content = Column(
          mainAxisAlignment:
              columnProperties?.mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: columnProperties?.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment:
              columnProperties?.crossAxisAlignment ?? CrossAxisAlignment.center,
          textDirection: columnProperties?.textDirection,
          textBaseline: columnProperties?.textBaseline,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1) SizedBox(height: columnSpacing),
            ],
          ],
        );
      } else {
        // Grid layout with both horizontal and vertical spacing
        final rowCount = (items.length / columns).ceil();
        content = Column(
          mainAxisAlignment:
              columnProperties?.mainAxisAlignment ?? MainAxisAlignment.start,
          mainAxisSize: columnProperties?.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment:
              columnProperties?.crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            for (int row = 0; row < rowCount; row++) ...[
              Row(
                mainAxisAlignment:
                    rowProperties?.mainAxisAlignment ?? MainAxisAlignment.start,
                mainAxisSize: rowProperties?.mainAxisSize ?? MainAxisSize.max,
                crossAxisAlignment:
                    rowProperties?.crossAxisAlignment ??
                    CrossAxisAlignment.center,
                children: [
                  for (int col = 0; col < columns; col++) ...[
                    (row * columns + col) < items.length
                        ? items[row * columns + col]
                        : const SizedBox.shrink(),
                    if (col < columns - 1) SizedBox(width: rowSpacing),
                  ],
                ],
              ),
              if (row < rowCount - 1) SizedBox(height: columnSpacing),
            ],
          ],
        );
      }
    }

    return Container(
      alignment: containerProperties?.alignment,
      clipBehavior: containerProperties?.clipBehavior ?? Clip.none,
      color: containerProperties?.color,
      constraints: containerProperties?.constraints,
      decoration: containerProperties?.decoration,
      foregroundDecoration: containerProperties?.foregroundDecoration,
      height: containerProperties?.height,
      margin: containerProperties?.margin,
      padding: containerProperties?.padding,
      transform: containerProperties?.transform,
      transformAlignment: containerProperties?.transformAlignment,
      width: containerProperties?.width,
      child: content ?? const SizedBox(),
    );
  }
}
