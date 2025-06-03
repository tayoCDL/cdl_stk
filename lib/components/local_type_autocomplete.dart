import 'dart:async';
import 'package:flutter/material.dart';

class CustomAutocompleteField extends StatefulWidget {
  final Future<List<dynamic>> Function(String) getSuggestions;
  final void Function(dynamic) onSuggestionSelected;
  final String hintText;

  const CustomAutocompleteField({
    Key? key,
    required this.getSuggestions,
    required this.onSuggestionSelected,
    this.hintText = 'Search...',
  }) : super(key: key);

  @override
  _CustomAutocompleteFieldState createState() => _CustomAutocompleteFieldState();
}

class _CustomAutocompleteFieldState extends State<CustomAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<dynamic> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        _removeOverlay();
        return;
      }

      try {
        final results = await widget.getSuggestions(value);
        setState(() {
          _suggestions = results;
        });

        _showOverlay();
      } catch (_) {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _suggestions.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  final name = (item is Map<String, dynamic>) ? item['name'] ?? '' : '';

                  return ListTile(
                    title: Text(
                      name.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      _controller.text = name;
                      widget.onSuggestionSelected(item);
                      _removeOverlay();
                      FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
