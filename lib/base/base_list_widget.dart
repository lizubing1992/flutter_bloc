import 'package:flutter/material.dart';
import 'package:flutter_bloc/bloc/bloc_provider.dart';
import 'package:flutter_bloc/event/page_event.dart';
import 'package:flutter_bloc/ui/widgets/refresh_scaffold.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'base_widget.dart';

/// @desp: 基本的List页面
/// @time 2019/6/14 14:35
/// @author lizubing
abstract class BaseListWidget extends BaseWidget {
  @override
  BaseListState createState() => getState();

  ///子类实现
  BaseListState getState();
}

/// B：对应 BLoc 数据加载的Bloc
/// E： 列表数据Entity
abstract class BaseListState<T extends BaseListWidget, B extends BaseBloc,
    E extends Object> extends BaseState<T, B> {
  RefreshController controller = new RefreshController();

  @override
  Widget buildWidget(BuildContext context) {
    bloc.pageEventStream.listen((PageStatusEvent event) {
      if (event.isRefresh) {
        controller.refreshCompleted();
        controller.loadComplete();
      } else {
        if (event.pageStatus == PageEnum.showEmpty) {
          controller.loadNoData();
        } else if (event.pageStatus == PageEnum.showError) {
          controller.loadFailed();
        } else {
          controller.loadComplete();
        }
      }
    });
    return new StreamBuilder(
        stream: blocStream,
        builder: (BuildContext context, AsyncSnapshot<List<E>> snapshot) {
          return RefreshScaffold(
            controller: controller,
            enablePullDown: isLoadMore(),
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            child: new ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                E model = snapshot.data[index];
                return buildItem(model);
              },
            ),
            bottomBar: buildBottomBar(),
            headerWidget: buildHeaderWidget(),
          );
        });
  }

  ///默认存在分页
  bool isLoadMore() {
    return true;
  }

  ///加载数据
  get blocStream;

  ///刷新回调
  void onRefresh();

  ///加载回调
  void onLoadMore();

  ///构建Item
  Widget buildItem(E entity);

  @override
  void onErrorClick() {
    super.onErrorClick();
    controller.requestRefresh();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildBottomBar() {
    return null;
  }

  PreferredSize buildHeaderWidget() {
    return null;
  }
}
