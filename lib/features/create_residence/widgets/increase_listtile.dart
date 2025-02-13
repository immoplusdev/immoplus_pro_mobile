import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/place/widgets/circle_button.dart';

class IncreaseListTile extends StatefulWidget {
  IncreaseListTile({
    super.key,
    required this.title,
    required this.onUpdate,
    required this.itemCount,
  });
  String title;
  final void Function(String, int)? onUpdate;
  int itemCount = 0;
  @override
  State<IncreaseListTile> createState() => _IncreaseListTileState();
}

class _IncreaseListTileState extends State<IncreaseListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        widget.itemCount.toString(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      title: Text(
          "${widget.title}${(widget.itemCount > 1 && widget.title[widget.title.length - 1] != 's') ? 's' : ''}"),
      titleTextStyle: Theme.of(context).textTheme.titleLarge,
      tileColor: Colors.white,
      trailing: SizedBox(
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleButton(
              icon: Icons.remove,
              onTap: () {
                setState(() {
                  if (widget.itemCount > 0) {
                    widget.itemCount--;
                  }
                });
                widget.onUpdate!(widget.title, widget.itemCount);
              },
            ),
            CircleButton(
                icon: Icons.add,
                onTap: () {
                  setState(() {
                    widget.itemCount++;
                  });
                  widget.onUpdate!(widget.title, widget.itemCount);
                }),
          ],
        ),
      ),
    );
  }
}
