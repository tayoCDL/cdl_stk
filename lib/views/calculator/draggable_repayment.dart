import 'package:flutter/material.dart';

class MyDraggableBottomSheet extends StatefulWidget {
  // const MyDraggableBottomSheet({ super.key});

  @override
  State<MyDraggableBottomSheet> createState() => _MyDraggableBottomSheetState();
}

class _MyDraggableBottomSheetState extends State<MyDraggableBottomSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      key: _sheet,
      initialChildSize: 0.5,
      maxChildSize: 1,
      minChildSize: 0,
      expand: true,
      snap: true,
      snapSizes: const [0.5],
      controller: _controller,
      builder: (BuildContext context, ScrollController scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: Text('Title'),
              ),
              Text('fffjfj')
            ],
          ),
        );
      },
    );
  }
}
