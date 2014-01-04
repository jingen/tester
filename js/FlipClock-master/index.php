<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Timer</title>
  <link rel="stylesheet" href="css/flipclock.css">
</head>
<body>
  <h1>Timer</h1>
  <div id="myclock"></div>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script src="js/flipclock/libs/prefixfree.min.js"></script>
<script src="js/flipclock/flipclock.min.js"></script>
<script>
  //var clock = $('#myclock').FlipClock({autoStart:false});
  //clock.setTime(3600);
  //clock.setCountdown(true);
  //clock.start(function(){});
var clock = $('#myclock').FlipClock(4500, {
  countdown: true,
  autoStart:false,
  stop: function(){location.replace("https://www.google.com");}
});
clock.start();
</script>
</body>
</html>
