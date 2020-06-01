class GroupData {
  String groupName;
  String description;
  bool isPublic;
  List<String> members = List<String>();

  GroupData({this.groupName, this.isPublic = false, this.description = ''});
}