import 'package:flutter/material.dart';
import 'package:flutter_bloc/common/component_index.dart';

bool isHomeInit = true;

/// @desp:
/// @time 2019/5/6 16:52
/// @author lizubing
class HomePage extends StatelessWidget {
  final String labelId;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("HomePage  build");
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });
    if (isHomeInit) {
      LogUtil.e("HomePage isInit");
      isHomeInit = false;
      Observable.just(1).delay(new Duration(milliseconds: 500)).listen((_) {
        bloc.onRefresh(labelId: labelId);
        bloc.getHotRecItem();
//        bloc.getVer
      });
    }

    return new StreamBuilder(
        stream: bloc.bannerStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            isLoading: snapshot.data == null,
            controller: _controller,
            enablePullUp: false,
            onRefresh: () {
              return bloc.onRefresh(labelId: labelId);
            },
            child: new ListView(
              children: <Widget>[
                new StreamBuilder(
                  builder:
                      (BuildContext context, AsyncSnapshot<ComModel> snapshot) {
                    ComModel model = bloc.hotRecModel;
                    if (model == null) {
                      return new Container(
                        height: 0.0,
                      );
                    }
                    int status = Utils.getUpdateStatus(model.version);
                    return new HeaderItem(
                      titleColor: Colors.redAccent,
                      title: status == 0 ? model.content : model.title,
                      extra: status == 0 ? 'Go' : "",
                      onTap: () {},
                    );
                  },
                  stream: bloc.recItemStream,
                ),
                buildBanner(context, snapshot.data),
                new StreamBuilder(
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ReposModel>> snapshot) {
                    return buildRepos(context, snapshot.data);
                  },
                  stream: bloc.recReposStream,
                ),
                new StreamBuilder(
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ReposModel>> snapshot) {
                    return buildWxArticle(context, snapshot.data);
                  },
                  stream: bloc.recWxArticleStream,
                ),
              ],
            ),
          );
        });
  }

  const HomePage({Key key, this.labelId}) : super(key: key);

  //构建Banner
  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(
        height: 0.0,
      );
    }
    //AspectRatio设置宽高比控件
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      //轮播图控件
      child: Swiper(
          indicatorAlignment: AlignmentDirectional.topEnd,
          circular: true,
          interval: const Duration(seconds: 5),
          indicator: NumberSwiperIndicator(),
          children: list.map((model) {
            return new InkWell(
              onTap: () {},
              child: new CachedNetworkImage(
                imageUrl: model.imagePath,
                fit: BoxFit.fill,
                placeholder: (context, url) => new ProgressView(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            );
          }).toList()),
    );
  }
}

//创建header以及项目相关的六个item
Widget buildRepos(BuildContext context, List<ReposModel> list) {
  if (ObjectUtil.isEmpty(list)) {
    return new Container(
      height: 0.0,
    );
  }
  List<Widget> _children = list.map((model) {
    return new ReposItem(
      model,
      isHome: true,
    );
  }).toList();
  List<Widget> children = new List();
  children.add(new HeaderItem(
    leftIcon: Icons.book,
    titleId: Ids.recRepos,
    onTap: () {},
  ));
  children.addAll(_children);
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: children,
  );
}

Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
  if (ObjectUtil.isEmpty(list)) {
    return new Container(
      height: 0.0,
    );
  }
  List<Widget> _children = list.map((model) {
    return new ArticleItem(
      model,
      isHome: true,
    );
  }).toList();

  List<Widget> children = new List();
  children.add(new HeaderItem(
    leftIcon: Icons.library_books,
    titleId: Ids.recWxArticle,
    titleColor: Colors.green,
    onTap: () {},
  ));
  children.addAll(_children);
  return new Column(
    mainAxisSize: MainAxisSize.min,
    children: children,
  );
}

class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return new Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.only(top: 10, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text(
        "${++index}/$itemCount",
        style: TextStyle(color: Colors.white70, fontSize: 11.0),
      ),
    );
  }
}
