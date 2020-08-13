import 'package:common_utils/common_utils.dart';
import 'package:fluintl/fluintl.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/res/strings.dart';
import 'package:flutter_bloc/ui/page/repos_page.dart';
import 'package:flutter_bloc/utils/utils.dart';

/// @desp: 主页main
/// @time 2019/5/6 16:30
/// @author lizubing
class _Page {
  final String labelId;

  _Page(this.labelId);
}

final List<_Page> _allPage = <_Page>[ _Page(Ids.titleRepos)];

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LogUtil.e("MainPage Build");
    return new DefaultTabController(
      length: _allPage.length,
      child:  Scaffold(
        appBar:  MyAppBar(
          leading:  Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                  Utils.getImgPath('ali_connors'),
                ))),
          ),
          centerTitle: true,
          title:  TabLayout(),
        ),
        body:  TabBarViewLayout(),
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
        return  Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("TabBarViewLayout build");
    return  TabBarView(
        children: _allPage.map((page) {
      return buildTabView(context, page);
    }).toList());
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  TabBar(
      tabs: _allPage
          .map((_Page page) => Tab(
                text: IntlUtil.getString(context, page.labelId),
              ))
          .toList(),
      isScrollable: true,
      labelPadding: EdgeInsets.all(12.0),
      indicatorSize: TabBarIndicatorSize.label,
    );
  }
}
