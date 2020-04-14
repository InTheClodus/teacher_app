class StuAttendState{

  static String statusToLabel(String str){
    if(str=="PS"){
      return "出席";
    }else if(str=="TL"){
      return "請假";
    }else if(str=="LA"){
      return "遲到";
    }else if(str=="AB"){
      return "缺席";
    }else if(str=="EX"){
      return "早退";
    }else if(str=='init'){
      return "未點名";
    }else{
      return str;
    }
  }
  static String LabelToStatus(String str){
    if(str=="出席"){
      return "PS";
    }else if(str=="請假"){
      return "TL";
    }else if(str=="遲到"){
      return "LA";
    }else if(str=="缺席"){
      return "AB";
    }else if(str=="早退"){
      return "EX";
    }else{
      return "init";
    }
  }
}