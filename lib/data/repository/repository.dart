import 'dart:async';

import 'package:flutter_bloc/common/common.dart';
import 'package:flutter_bloc/data/api/apis.dart';
import 'package:flutter_bloc/data/net/dio_util.dart';
import 'package:flutter_bloc/data/protocol/models.dart';

class Repository {
  Future<List<ReposModel>> getArticleListProject(int page) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.ARTICLE_LISTPROJECT, page: page));
    List<ReposModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }
}
