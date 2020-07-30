import 'package:flutter/material.dart';
import 'package:flutter_bloc/common/component_index.dart';

/// @desp: 主页main
/// @time 2019/5/6 16:30
/// @author lizubing
class _Page {
  final String labelId;

  _Page(this.labelId);
}

final List<_Page> _allPage = <_Page>[new _Page(Ids.titleRepos)];

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LogUtil.e("MainPage Build");
    return new DefaultTabController(
      length: _allPage.length,
      child: new Scaffold(
        appBar: new MyAppBar(
          leading: new Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                  Utils.getImgPath('ali_connors'),
                ))),
          ),
          centerTitle: true,
          title: new TabLayout(),
        ),
        body: new TabBarViewLayout(),
      ),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  Widget buildTabView(BuildContext context, _Page page) {
    String labelId = page.labelId;
    switch (labelId) {
      case Ids.titleRepos:
        return ReposPage(labelId: labelId);
        break;
      default:
        return new Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("TabBarViewLayout build");
    return new TabBarView(
        children: _allPage.map((page) {
      return buildTabView(context, page);
    }).toList());
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      tabs: _allPage
          .map((_Page page) => new Tab(
                text: IntlUtil.getString(context, page.labelId),
              ))
          .toList(),
      isScrollable: true,
      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
    );
  }
}
