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