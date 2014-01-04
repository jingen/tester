window.onload = function(){

  var myVideo = document.getElementById('myVideo');
  var play = document.getElementById('play');
  var mute = document.getElementById('mute');
  var fullscreen = document.getElementById('fullscreen');
  var inputSeek = document.getElementById('inputSeek');
  var inputVolume = document.getElementById('inputVolume');

  function playPause () {
    if(myVideo.paused){
      myVideo.play();
      play.innerHTML = "Pause";
    }else{
      myVideo.pause();
      play.innerHTML = "Play";
    }
  }

  play.addEventListener('click', playPause);

  myVideo.addEventListener('timeupdate', function(){
    inputSeek.value = myVideo.currentTime / myVideo.duration * 100;
  });

  inputSeek.addEventListener('change', function(){
    var videoTime = inputSeek.value * myVideo.duration / 100;
    myVideo.currentTime = videoTime;
  });

  mute.addEventListener('click', function(){
    if(myVideo.muted){
      myVideo.muted = false;
      mute.innerHTML = "Mute";
    }else{
      myVideo.muted = true;
      mute.innerHTML = "Unmute";
    }
  });

  inputVolume.addEventListener('change', function(){
    myVideo.volume = inputVolume.value;
  });

  fullscreen.addEventListener('click', function(){
    if(myVideo.requestFullScreen){
      myVideo.requestFullScreen();
      console.log("requestFullScreen");
    }else if(myVideo.mozRequestFullScreen){
      myVideo.mozRequestFullScreen();
      console.log("mozRequestFullScreen");
    }else if(myVideo.webkitRequestFullScreen){
      myVideo.webkitRequestFullScreen();
      console.log("webkitRequestFullScreen");
    }
  });
};
