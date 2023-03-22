
class TimeDuration{
  Stopwatch stopwatch = Stopwatch();

  String startTimeDuration({String message = "",bool? reset = false}){
    String time = "00.00";
    if(!stopwatch.isRunning){
      if(reset!){
        stopwatch.reset();
      }
      int millis = stopwatch.elapsedMilliseconds;
      var seconds = ((millis % 60000) / 1000);
      //ES6 interpolated literals/template literals
      time = message +" "+ seconds.toString();
      stopwatch.start();
    }
    return time;
  }

  String endTime({String message = "",bool reset = false}){
    String time = "00.00";
    if(stopwatch.isRunning){
     int millis = stopwatch.elapsedMilliseconds;
      var seconds = ((millis % 60000) / 1000);
      //ES6 interpolated literals/template literals
      time = message +" "+ seconds.toString();
      stopwatch.stop();
      if(reset){
        stopwatch.reset();
      }
    }
    return time;
  }
}

TimeDuration timeDuration = TimeDuration();