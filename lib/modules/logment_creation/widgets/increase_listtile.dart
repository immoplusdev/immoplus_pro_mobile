import 'package:flutter/material.dart';
import 'package:immoplus_pro/views/place/widgets/circle_button.dart';

class IncreaseListTile extends StatefulWidget {
  IncreaseListTile({
    super.key,
    required this.title,
    required this.onUpdate,
  });
  String title;
  final void Function(String, int)? onUpdate;
  @override
  State<IncreaseListTile> createState() => _IncreaseListTileState();
}

class _IncreaseListTileState extends State<IncreaseListTile> {
  int itemCount = 0;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        itemCount.toString(),
        style: Theme.of(context).textTheme!.titleLarge,
      ),
      title: Text(
          "${widget.title}${(itemCount > 1 && widget.title[widget.title.length - 1] != 's') ? 's' : ''}"),
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
                  if (itemCount > 0) {
                    itemCount--;
                  }
                });
                widget.onUpdate!(widget.title, itemCount);
              },
            ),
            CircleButton(
                icon: Icons.add,
                onTap: () {
                  setState(() {
                    itemCount++;
                  });
                  widget.onUpdate!(widget.title, itemCount);
                }),
          ],
        ),
      ),
    );
  }
}
