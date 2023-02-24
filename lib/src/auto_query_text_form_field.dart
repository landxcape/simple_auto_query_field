import 'dart:async';

import 'package:flutter/material.dart';

class AutoQueryTextFormField<T> extends StatefulWidget {
  const AutoQueryTextFormField({
    super.key,

    /// initially [false], set [true] to get suggestion immediately on focus
    this.getImmediateSuggestions = false,

    /// gives query typed
    /// put logic to call the search function with this query [String] callback
    required this.queryCallback,

    /// seperator builder
    /// by default, it gives a [Divider] of [height] [0.0]
    this.seperatorBuilder,

    /// item builder, input how the
    required this.itemBuilder,

    /// returns the selected object
    /// NOTE: to show selected data on text field, pass [textEditingController]
    /// and set selected value to display on [textEditingController.text]
    required this.onSuggestionSelected,

    /// decoration for TextFormField
    this.textInputDecoration,

    /// text input autofocus
    this.autoFocus = false,

    /// text editing controller for input field
    this.textEditingController,

    /// scroll physics for listview
    /// by default, it takes [BouncingScrollPhysics] with parent as [AlwaysScrollableScrollPhysics]
    this.scrollPhysics,

    /// height of suggenstions list overlay, default of 5 (takes text form field's height and multiplies)
    this.overlayHeight = 5,
  });

  final bool getImmediateSuggestions;
  final Widget Function(BuildContext context, int index)? seperatorBuilder;
  final Widget Function(BuildContext context, T data) itemBuilder;
  final Future<List<T>?> Function(String? query) queryCallback;
  final Function(T item) onSuggestionSelected;
  final TextEditingController? textEditingController;
  final InputDecoration? textInputDecoration;
  final bool autoFocus;
  final ScrollPhysics? scrollPhysics;
  final int overlayHeight;

  @override
  State<AutoQueryTextFormField<T>> createState() =>
      _AutoQueryTextFormFieldState<T>();
}

class _AutoQueryTextFormFieldState<T> extends State<AutoQueryTextFormField<T>> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? entry;
  String? _query;

  final TextEditingController _internalTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());

    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          if (widget.getImmediateSuggestions) {
            (widget.textEditingController ?? _internalTextEditingController)
                .text = '';
            _showOverlay();
          } else {
            _hideOverlay();
          }
        } else {
          _hideOverlay();
        }
      },
    );
  }

  @override
  void dispose() {
    _internalTextEditingController.dispose();
    super.dispose();
  }

  _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          height: size.height * widget.overlayHeight,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height),
            child: _buildOverlay(),
          ),
        );
      },
    );

    overlay?.insert(entry!);
  }

  void _hideOverlay() {
    entry?.remove();
    entry = null;
  }

  _buildOverlay() {
    return Material(
      elevation: 4.0,
      child: FutureBuilder<List<T>?>(
        future: widget.queryCallback.call(_query ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListTile(
              title: Text(snapshot.error.toString()),
            );
          }

          final dataList = snapshot.data;

          if (dataList == null) {
            return const ListTile(
              title: Text('No Data'),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: dataList.length,
            separatorBuilder:
                widget.seperatorBuilder ?? _defaultSeperatorBuilder,
            itemBuilder: (context, index) {
              final data = dataList.elementAt(index);

              return InkWell(
                onTap: () {
                  widget.onSuggestionSelected.call(data);
                  (widget.textEditingController ??
                          _internalTextEditingController)
                      .text = data.toString();
                  _query = data.toString();
                  _focusNode.unfocus();
                },
                child: widget.itemBuilder(context, data),
              );
            },
          );
        },
      ),
    );
  }

  Widget _defaultSeperatorBuilder(BuildContext context, int index) =>
      const Divider(height: 0.0);

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        autofocus: widget.autoFocus,
        focusNode: _focusNode,
        controller:
            widget.textEditingController ?? _internalTextEditingController,
        decoration: widget.textInputDecoration,
        onChanged: (value) {
          widget.queryCallback.call(value);
          setState(() {
            _query = value;
            _hideOverlay();
            _showOverlay();
          });
        },
      ),
    );
  }
}
