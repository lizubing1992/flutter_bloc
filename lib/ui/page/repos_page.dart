import 'package:flutter/material.dart';
import 'package:flutter_bloc/bloc/bloc_provider.dart';
import 'package:flutter_bloc/base/base_list_widget.dart';
import 'package:flutter_bloc/bloc/main_bloc.dart';
import 'package:flutter_bloc/data/protocol/models.dart';
import 'package:flutter_bloc/ui/widgets/repos_item.dart';

/// @desp:
/// @time 2019/5/7 9:35
/// @author lizubing
class ReposPage extends BaseListWidget {
  final String labelId;

  ReposPage({this.labelId});

  @override
  BaseListState<BaseListWidget, BaseBloc, Object> getState() {
    return _ReposPageState();
  }
}

class _ReposPageState extends BaseListState<ReposPage,MainBloc,ReposModel> {

  @override
  get blocStream =>  bloc.reposStream;

  @override
  Widget buildItem(ReposModel entity) {
    return ReposItem(entity);
  }

  @override
  void onLoadMore() {
    bloc.onLoadMore(labelId: widget.labelId);
  }

  @override
  void onRefresh() {
    bloc.onRefresh(labelId: widget.labelId);
  }

}
