import 'package:flutter/material.dart';
import 'package:flutter_bloc/event/page_event.dart';
import 'package:flutter_bloc/bloc/bloc_provider.dart';
import 'package:flutter_bloc/res/colors.dart';
import 'package:flutter_bloc/res/styles.dart';
import 'package:flutter_bloc/ui/widgets/progress_view.dart';
import 'package:flutter_bloc/utils/utils.dart';

/// @desp: 基本的StatefulWidget页面
/// @time 2019/5/17 14:35
/// @author lizubing
abstract class BaseWidget extends StatefulWidget {
  @override
  BaseState createState() => getState();

  ///子类实现
  BaseState getState();
}

abstract class BaseState<T extends BaseWidget, B extends BaseBloc>
    extends State<T> {
  PageEnum current = PageEnum.showLoading;
  B bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidgetDefault();
  }

  ///构建默认视图
  Widget _buildWidgetDefault() {
    ///使用appbar，也可直接只有 body 在 body 里自定义状态栏、标题栏
    return WillPopScope(
      child: Scaffold(
        appBar: buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  ///子类实现，构建各自页面UI控件 相当于setContentView()
  Widget buildWidget(BuildContext context);

  ///构建内容区
  Widget _buildBody() {
    bloc = BlocProvider.of<B>(context);
    return  StreamBuilder(
        stream: bloc.pageEventStream,
        builder:
            (BuildContext context, AsyncSnapshot<PageStatusEvent> snapshot) {
          PageStatusEvent status;
          bool isShowContent = false;
          if (snapshot == null || snapshot.data == null) {
            isShowContent = false;
            status =
                PageStatusEvent(errorDesc : "", isRefresh: true, pageStatus: PageEnum.showLoading);
          } else {
            status = snapshot.data;
            if ((!status.isRefresh) ||
                (status.pageStatus == PageEnum.showContent &&
                    status.isRefresh)) {
              isShowContent = true;
            } else {
              isShowContent = false;
            }
          }
          return Container(
            ///内容区背景颜色
            color: Colours.colorPrimaryWindowBg,
            child: Stack(
              children: <Widget>[
                buildWidget(context),
                Offstage(
                  offstage: isShowContent,
                  child: getErrorWidget(status),
                ),
              ],
            ),
          );
        });
  }

  Widget getErrorWidget(PageStatusEvent status) {
    current = status.pageStatus;
    if (status != null && status.isRefresh) {
      if (status.pageStatus == PageEnum.showEmpty) {
        return _buildEmptyWidget();
      } else if (status.pageStatus == PageEnum.showError) {
        return _buildErrorWidget(status.errorDesc);
      } else {
        return _buildLoadingWidget();
      }
    }
    return _buildLoadingWidget();
  }

  Widget _buildErrorWidget(String errorDesc) {
    return  InkWell(
      onTap: () {
        onErrorClick();
      },
      child:  Container(
        alignment: Alignment.center,
        color: Colours.gray_f0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Container(
              child: Image.asset('${Utils.getImgPath('page_icon_network')}'),
              width: 70,
              height: 50,
            ),
            Gaps.vGap12,
            buildErrorDesc(errorDesc),
          ],
        ),
      ),
    );
  }

  Widget buildErrorDesc(String error) {
    if (error == null || error == "") {
      return Text("网络出错了");
    } else {
      return Text(error);
    }
  }

  Widget buildAppBar() {
    return null;
  }

  void showLoadSuccess() {
    if (current != PageEnum.showContent) {
      current = PageEnum.showContent;
      //展示内容
      bloc.pageEventSink
          .add(PageStatusEvent(errorDesc : "", isRefresh: true, pageStatus: PageEnum.showContent));
    }
  }

  void showEmpty() {
    if (current != PageEnum.showEmpty) {
      current = PageEnum.showEmpty;
      //展示空页面
      bloc.pageEventSink
          .add(PageStatusEvent(errorDesc : "", isRefresh: true, pageStatus: PageEnum.showEmpty));
    }
  }

  void showError() {
    if (current != PageEnum.showError) {
      current = PageEnum.showError;
      //展示错误页面
      bloc.pageEventSink
          .add(PageStatusEvent(errorDesc : "", isRefresh: true, pageStatus: PageEnum.showError));
    }
  }

  void showLoading() {
    if (current != PageEnum.showLoading) {
      current = PageEnum.showLoading;
      //展示loading页面
      bloc.pageEventSink
          .add(PageStatusEvent(errorDesc : "", isRefresh: true, pageStatus: PageEnum.showLoading));
    }
  }

  Widget _buildEmptyWidget() {
    return new InkWell(
      onTap: () {
        onErrorClick();
      },
      child: new Container(
        alignment: Alignment.center,
        color: Colours.gray_f0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              child: Image.asset('images/page_icon_empty.png'),
              width: 100,
              height: 100,
            ),
            Gaps.vGap12,
            Text(setEmptyMsg()),
          ],
        ),
      ),
    );
  }

  String setEmptyMsg() {
    return "数据加载为空";
  }

  Widget _buildLoadingWidget() {
    return new Container(
      alignment: Alignment.center,
      color: Colours.gray_f0,
      child: new ProgressView(),
    );
  }

  void onErrorClick() {
    showLoading();
  }
}
