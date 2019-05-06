import 'package:flutter_bloc/common/component_index.dart';
import 'package:flutter_bloc/data/repository/wan_repository.dart';
import 'dart:collection';
/// @desp:主页mainPage相关的Bloc
/// @time 2019/5/6 14:58
/// @author lizubing

class MainBloc implements BlocBase {
  WanRepository repository = new WanRepository();

  HttpUtils httpUtils = new HttpUtils();


  ///********************Home ****************/

  //banner相关的api获取
  BehaviorSubject<List<BannerModel>> _banner =
  BehaviorSubject<List<BannerModel>>();

  Sink<List<BannerModel>> get _bannerSink => _banner.sink;

  Stream<List<BannerModel>> get bannerStream => _banner.stream;

  BehaviorSubject<List<ReposModel>> _recRepos =
  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recReposSink => _recRepos.sink;

  Stream<List<ReposModel>> get recReposStream => _recRepos.stream;

  BehaviorSubject<List<ReposModel>> _recWxArticle =
  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recWxArticleSink => _recWxArticle.sink;

  Stream<List<ReposModel>> get recWxArticleStream => _recWxArticle.stream;
  //获取banner数据
  Future getBanner(String labelId) {
    return repository.getBanner().then((list){
      _bannerSink.add(UnmodifiableListView<BannerModel>(list));
    });
  }

  //获取6条项目的数据
  Future getRecRepos(String labelId) async {
    ComReq comReq = new ComReq(402);
    repository.getProjectList(data: comReq.toJson()).then((list){
      if(list.length > 6){
        list = list.sublist(0,6);
      }
      _recReposSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }


  //获取6条项目的数据
  Future getRecWxArticle(String labelId) async {
    int _id = 408;
    repository.getWxArticleList(id: _id).then((list){
      if(list.length > 6){
        list = list.sublist(0,6);
      }
      _recWxArticleSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getHomeData(String labelId){
    getRecRepos(labelId);
    getRecWxArticle(labelId);
    return getBanner(labelId);
  }

  ComModel hotRecModel;

  Future getHotRecItem() async {
    httpUtils.getRecItem().then((model) {
      hotRecModel = model;
      _recItemSink.add(hotRecModel);
    });
  }

  int _reposPage = 0;

  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();


  BehaviorSubject<ComModel> _recItem = BehaviorSubject<ComModel>();

  Sink<ComModel> get _recItemSink => _recItem.sink;

  Stream<ComModel> get recItemStream => _recItem.stream.asBroadcastStream();


  ///********************Home ****************/
  @override
  void dispose() {
    _banner.close();
    _recRepos.close();
    _recWxArticle.close();
  }

  @override
  Future getData({String labelId, int page}) {
    switch(labelId){
      case Ids.titleHome:
        return getHomeData(labelId);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }

  }

  @override
  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch(labelId){
      case Ids.titleHome:
        break;
      default:
        break;
    }
    return getData(labelId: labelId,page: _page);
  }

  @override
  Future onRefresh({String labelId}) {
    switch (labelId) {
      case Ids.titleHome:
        getHotRecItem();
        break;
      case Ids.titleRepos:
        _reposPage = 0;
        break;
      case Ids.titleEvents:
//        _eventsPage = 0;
        break;
      case Ids.titleSystem:
        break;
      default:
        break;
    }
    LogUtil.e("onRefresh labelId: $labelId" + "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: 0);
  }
}
