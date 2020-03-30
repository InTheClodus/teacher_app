class TimeConversion{

  static String timeConversion(time){
    if(time==null||time==''){
      return '-- : --';
    }else{
      num nn=time/60;
      num hh=nn/60;
      String str='0.'+hh.toString().split('.')[1];
      String nnn= (double.parse(str)*60).toString();
      if(num.parse(nnn)<10){
        nnn="0"+nnn;
      }
      time=hh.toString().split('.')[0]+":"+nnn;
      print(time.toString().split('.')[0]);
      return time.toString().split('.')[0];
    }
  }
  static int timeUnConversion(String time){
    num hh=int.parse(time.split(":")[0].split(' ')[1]);
    num nn=int.parse(time.split(":")[1]);
    num total=hh*60*60+nn*60;
    print(total);
    return total;
  }
}