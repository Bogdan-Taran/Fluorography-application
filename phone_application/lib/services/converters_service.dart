class ConverterServices{

  Future<String?> convertUserRoleFormListToNormalName(UserData) async{
    final List<int> userRoles = UserData.roles;
    final String userRole;
    if(userRoles.contains(1)){
      userRole = 'medic';
    }
    else if(userRoles.contains(2)){
      userRole = 'student';
    }
    else if (userRoles.contains(4)){
      userRole = 'admin';
    }
    else if(userRoles.contains(5)){
      userRole = 'curator';
    }
    else{
      userRole = 'undefined';
    }
    return userRole;
  }


}