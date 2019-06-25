import 'package:flutter/material.dart';
import 'package:flutter_bloc/common/component_index.dart';
import 'package:flutter/scheduler.dart';
import 'list_footer_view.dart';
typedef void OnLoadMore();
typedef void OnRefresh();

class RefreshScaffold extends StatefulWidget {
  const RefreshScaffold(
      {Key key,
        @required this.controller,
        this.enablePullUp: true,
        this.enablePullDown: true,
        this.onRefresh,
        this.onLoadMore,
        this.child,
        this.bottomBar,
        this.headerWidget,
        this.itemCount,
        this.itemBuilder})
      : super(key: key);

  final RefreshController controller;
  final bool enablePullUp;
  final bool enablePullDown;
  final OnRefresh onRefresh;
  final OnLoadMore onLoadMore;
  final Widget child;
  final Widget bottomBar;
  final PreferredSize headerWidget;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() {
    return new RefreshScaffoldState();
  }
}

///   with AutomaticKeepAliveClientMixin
class RefreshScaffoldState extends State<RefreshScaffold>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.controller.requestRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: widget.headerWidget,
      body: new SmartRefresher(
          controller: widget.controller,
          enablePullDown: widget.enablePullDown,
          enablePullUp: widget.enablePullUp,
          onRefresh: widget.onRefresh,
          onLoading: widget.onLoadMore,
          footer: ListFooterView(),
          header: MaterialClassicHeader(),
          child: widget.child ??
              new ListView.builder(
                itemCount: widget.itemCount,
                itemBuilder: widget.itemBuilder,
              )),
      bottomNavigationBar: widget.bottomBar,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
