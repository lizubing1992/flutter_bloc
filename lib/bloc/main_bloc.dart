import 'dart:collection';

import 'package:common_utils/common_utils.dart';
import 'package:flutter_bloc/bloc/bloc_provider.dart';
import 'package:flutter_bloc/data/protocol/models.dart';
import 'package:rxdart/rxdart.dart';

/// @desp:主页mainPage相关的Bloc
/// @time 2019/5/6 14:58
/// @author lizubing

class MainBloc extends BaseBloc {
  int _reposPage = 1;
  BehaviorSubject<List<ReposModel>> _repos =
      BehaviorSubject<List<ReposModel>>();

  get _reposSink => _repos.sink;

  get reposStream => _repos.stream;

  List<ReposModel> _reposList = new List();

  Future getArticleListProject(String labelId, int page) {
    bool isRefresh;
    if (page == 1) {
      isRefresh = true;
    } else {
      isRefresh = false;
    }
    return repository.getArticleListProject(page).then((list) {
      if(page ==1){
        _reposList.clear();
      }
      _reposList.addAll(list);
      _reposSink.add(UnmodifiableListView<ReposModel>(_reposList));
      postPageEmpty2PageContent(isRefresh, list);
    }).catchError((error) {
      postPageError(isRefresh, error.toString());
    });
  }


  @override
  void dispose() {
    super.dispose();
    _repos.close();
  }

  Future getData({String labelId, int page}) {
    return getArticleListProject(labelId, page);
  }

  Future onLoadMore({String labelId}) {
    _reposPage += 1;
    return getData(labelId: labelId, page: _reposPage);
  }

  Future onRefresh({String labelId}) {
    _reposPage = 1;
    LogUtil.e("onRefresh labelId: $labelId" + "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: 1);
  }
}
