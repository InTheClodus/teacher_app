class Day{
  static String day(day){
    if(day<10){
      return "0"+day.toString();
    }
    return day.toString();
  }
  static String week(week){
    if(week=='Sun'){
      return "日";
    }else if(week=='Mon'){
      return "一";
    }else if(week=='Tue'){
      return "二";
    }else if(week=='Wed'){
      return "三";
    }else if(week=='Thu'){
      return "四";
    }else if(week=='Fri'){
      return "五";
    }else{
      return "六";
    }
  }
}