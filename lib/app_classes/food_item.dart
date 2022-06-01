class FoodItem {

  String iname, uname, aprice, dprice, sdate, edate, useremail;
  String? receiver;
  bool? taken;
  String? id;
  //String? imagename;
  List<String>? imagename;

  FoodItem({required this.iname, required this.uname, required this.aprice, required this.dprice, required this.sdate, required this.edate, required this.useremail, this.id, this.imagename});
}