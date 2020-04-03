class Lunch{
  static String lunchType(String str){
    if(str=="午餐"){
      return "lunch";
    }else if(str=="下午茶"){
      return "afTea";
    }else{
      return "meal";
    }
  }
}