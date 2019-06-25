import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/data/repository/repository.dart';
import 'package:flutter_bloc/event/page_event.dart';
import 'package:rxdart/rxdart.dart';

/// @desp:
/// @time 2019/5/6 14:19
/// @author lizubing

class BaseBloc {
  dispose() {
    _pageEvent.close();
  }

  ///请求专用的类
  Repository repository = new Repository();

  ///主要是事件通知
  BehaviorSubject<PageStatusEvent> _pageEvent =
      BehaviorSubject<PageStatusEvent>();

  get pageEventSink => _pageEvent.sink;

  get pageEventStream => _pageEvent.stream.asBroadcastStream();

  postPageEmpty2PageContent(bool isRefresh, Object list) {
    pageEventSink.add(new PageStatusEvent(
        errorDesc: "",
        isRefresh: true,
        pageStatus: ObjectUtil.isEmpty(list)
            ? PageEnum.showEmpty
            : PageEnum.showContent));
  }

  postPageError(bool isRefresh, String errorMsg) {
    pageEventSink.add(new PageStatusEvent(
        errorDesc: errorMsg,
        isRefresh: isRefresh,
        pageStatus: PageEnum.showError));
  }
}

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  final T bloc;
  final Widget child;
  final bool userDispose;

  @override
  State<StatefulWidget> createState() {
    return _BlocProviderState<T>();
  }

  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.userDispose: true,
  }) : super(key: key);

  //提供bloc
  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T> extends State<BlocProvider<BaseBloc>> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    if (widget.userDispose) {
      widget.bloc.dispose();
    }
    super.dispose();
  }
}
