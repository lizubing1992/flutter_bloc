class PageStatusEvent {
  String errorDesc;
  bool isRefresh;
  PageEnum pageStatus;
  PageStatusEvent({this.errorDesc,this.isRefresh, this.pageStatus});
}

/// @desp:页面状态
/// @time 2019/5/31 18:27
/// @author lizubing
enum PageEnum {
  showLoading,
  showError,
  showEmpty,
  showContent,
}
