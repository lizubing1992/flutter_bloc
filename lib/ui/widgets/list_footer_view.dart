/// @desp:
/// @time 2019/6/14 18:54
/// @author lizubing
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListFooterView extends LoadIndicator {
  final String idleText, loadingText, noDataText, failedText;

  final Decoration decoration;

  final Widget idleIcon, loadingIcon, noMoreIcon, failedIcon;

  final double height;

  final double spacing;

  final IconPosition iconPos;

  final TextStyle textStyle;

  const ListFooterView({
    Key key,
    Function onClick,
    this.textStyle: const TextStyle(color: const Color(0xff555555)),
    this.loadingText: '加载中',
    this.noDataText: '没有数据',
    this.height: 40.0,
    this.decoration: const BoxDecoration(),
    this.noMoreIcon,
    this.idleText: '加载中',
    this.failedText: '加载失败，点击重试！',
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.loadingIcon: const SizedBox(
      width: 15.0,
      height: 15.0,
      child: const CircularProgressIndicator(
        strokeWidth: 1.0,
      ),
    ),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
  }) : super(
          key: key,
          onClick: onClick,
        );

  const ListFooterView.asSliver({
    Key key,
    @required OnLoading onLoading,
    Function onClick,
    this.textStyle: const TextStyle(color: const Color(0xff555555)),
    this.decoration: const BoxDecoration(),
    this.loadingText: 'Loading...',
    this.noDataText: 'No more data',
    this.height: 40.0,
    this.noMoreIcon,
    this.idleText: 'Load More..',
    this.iconPos: IconPosition.left,
    this.failedText: 'Load Failed,Click Retry!',
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.spacing: 15.0,
    this.loadingIcon: const SizedBox(
      width: 15.0,
      height: 15.0,
      child: const CircularProgressIndicator(
        strokeWidth: 1.0,
      ),
    ),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
  }) : super(
          key: key,
          onLoading: onLoading,
          onClick: onClick,
        );

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _ListFooterViewState();
  }
}

class _ListFooterViewState extends LoadIndicatorState<ListFooterView> {
  Widget _buildText(LoadStatus mode) {
    return Text(
        mode == LoadStatus.loading
            ? widget.loadingText
            : LoadStatus.noMore == mode
                ? widget.noDataText
                : LoadStatus.failed == mode
                    ? widget.failedText
                    : widget.idleText,
        style: widget.textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {
    Widget icon = mode == LoadStatus.loading
        ? widget.loadingIcon
        : mode == LoadStatus.noMore
            ? widget.noMoreIcon
            : mode == LoadStatus.failed ? widget.failedIcon : widget.idleIcon;
    return icon ?? Container();
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    // TODO: implement buildChild
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
              widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return Container(
      height: widget.height,
      decoration: widget.decoration,
      child: Center(
        child: container,
      ),
    );
  }
}
