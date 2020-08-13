import 'package:flutter/material.dart';
import 'package:flutter_bloc/data/protocol/models.dart';
import 'package:flutter_bloc/res/colors.dart';
import 'package:flutter_bloc/res/strings.dart';
import 'package:flutter_bloc/res/styles.dart';
import 'package:flutter_bloc/utils/navigator_util.dart';
import 'package:flutter_bloc/utils/utils.dart';

class TreeItem extends StatelessWidget {
  const TreeItem(this.model, {Key key}) : super(key: key);

  final TreeModel model;

  @override
  Widget build(BuildContext context) {
    final List<Widget> chips = model.children.map<Widget>((TreeModel _model) {
      return Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        key: ValueKey<String>(_model.name),
        backgroundColor: Utils.getChipBgColor(_model.name),
        label: Text(
          _model.name,
          style:  TextStyle(fontSize: 14.0),
        ),
      );
    }).toList();

    return  InkWell(
      onTap: () {
        //LogUtil.e("ReposModel: " + model.toString());
        NavigatorUtil.pushTabPage(context,
            labelId: Ids.titleSystemTree, title: model.name, treeModel: model);
      },
      child:  _ChipsTile(
        label: model.name,
        children: chips,
      ),
    );
  }
}

class _ChipsTile extends StatelessWidget {
  const _ChipsTile({
    Key key,
    this.label,
    this.children,
  }) : super(key: key);

  final String label;
  final List<Widget> children;

  // Wraps a list of chips into a ListTile for display as a section in the demo.
  @override
  Widget build(BuildContext context) {
    final List<Widget> cardChildren = <Widget>[
       Text(
        label,
        style: TextStyles.listTitle,
      ),
      Gaps.vGap10
    ];
    cardChildren.add(Wrap(
        children: children.map((Widget chip) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: chip,
      );
    }).toList()));

    return  Container(
      padding: EdgeInsets.all(16.0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: cardChildren,
      ),
      decoration:  BoxDecoration(
          color: Colors.white,
          border:  Border(
              bottom:  BorderSide(width: 0.33, color: Colours.divider))),
    );
  }
}
