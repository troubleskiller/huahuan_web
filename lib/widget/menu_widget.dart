import 'package:flutter/material.dart';

class Menu<T> extends StatefulWidget {
  final Widget? child;
  final PopupMenuItemBuilder<T>? itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final PopupMenuCanceled? onCanceled;

  const Menu({
    Key? key,
    this.child,
    this.itemBuilder,
    this.onCanceled,
    this.onSelected,
  }) : super(key: key);

  @override
  _MenuState<T> createState() => _MenuState<T>();
}

class _MenuState<T> extends State<Menu<T>> {
  late Offset position;
  RenderBox? overlay;

  @override
  Widget build(BuildContext context) {
    var result = GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        position = details.globalPosition;
      },
      onLongPress: () {
        overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox?;
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
            position & Size.zero,
            Offset.zero & overlay!.size,
          ),
          items: widget.itemBuilder!(context),
        ).then<void>((T? newValue) {
          if (!mounted) return null;
          if (newValue == null) {
            if (widget.onCanceled != null) widget.onCanceled!();
            return null;
          }
          if (widget.onSelected != null) widget.onSelected!(newValue);
        });
      },
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (event.buttons == 2) {
            position = event.position;
            overlay =
                Overlay.of(context)!.context.findRenderObject() as RenderBox?;
            showMenu(
              context: context,
              position: RelativeRect.fromRect(
                position & Size.zero,
                Offset.zero & overlay!.size,
              ),
              items: widget.itemBuilder!(context),
            ).then<void>((T? newValue) {
              if (!mounted) return null;
              if (newValue == null) {
                if (widget.onCanceled != null) widget.onCanceled!();
                return null;
              }
              if (widget.onSelected != null) widget.onSelected!(newValue);
            });
          }
        },
        child: widget.child,
      ),
    );
    return result;
  }
}
