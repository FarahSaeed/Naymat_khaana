String? validate_email(String value) {
    value = value == null? '':value;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (emailValid == false ) { return 'Invalid email address';}
    else {  return null;}
}

String? validate_password(String value) {
    value = value == null? '':value;
    if (value == '') {   return 'Value Can\'t Be Empty'; }
    else {return null;}
}

String? validate_dob(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_lname(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[a-zA-Z*]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (valid == false ) { return 'Invalid value';}
    else {  return null;}
}

String? validate_fname(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[a-zA-Z*]+").hasMatch(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (valid == false ) { return 'Invalid value';}
    else {  return null;}
}

String? validate_iname(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_aprice(String value) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    var int_num = int.tryParse(value);
    var double_num = double.tryParse(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (int_num==null && double_num== null) {
        return 'Invalid value';
    }
    else {  return null;}
}
String? validate_dprice(String value, String aprice, String dprice) {
    value = value == null? '':value;
    bool valid = RegExp(r"^[0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    var int_num = int.tryParse(value);
    var double_num = double.tryParse(value);
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (int_num==null && double_num== null) {
        return 'Invalid value';
    }
    if (aprice == null || aprice == ""){
        return null; // it is handeled in aprice validator so returning null here
    }

    else if ( double.tryParse(aprice)! <= double.tryParse(dprice)!  ){
        return "Discounted price should be less than actual price";
    }
    else {  return null;}
}
String? validate_sdate(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}
String? validate_edate(String value, String sdate, String edate) {
    value = value == null || value == ''? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    if (sdate == '' || sdate == null) {return ''; }

    DateTime sd = DateTime.parse(sdate);
    DateTime ed = DateTime.parse(edate);
    final bool edBeforesd = ed.isBefore(sd);
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else if (edBeforesd) {return 'Expiry date is before submission date';}
    else {  return null;}
}


String? validate_address1(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_address2(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_city(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_zipcode(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}

String? validate_phone(String value) {
    value = value == null? '':value;
    if (value == '') {return 'Value Can\'t Be Empty'; }
    else {  return null;}
}


