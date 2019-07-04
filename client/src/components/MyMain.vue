<template>
  <div>
    <div class="my-back">
      <div class="container" :style="{'padding': slidePadding + 'px'}">
        <div id="slides-container" class="slides-container" :style="{'height': slideHeight+'px'}">
          <a class="button is-large is-text slide-left" :style="{'top': angleTop+'px'}" @click="slideIndex = (slideIndex-1) < 0 ?  (homeFiles.length - 1) : slideIndex-1">
            <v-icon class="icon has-text-grey-light" name="angle-left"/>
          </a>
          <a class="button is-large is-text slide-right" :style="{'top': angleTop+'px'}" @click="slideIndex = (slideIndex+1) % homeFiles.length">
            <v-icon class="icon has-text-grey-light" name="angle-right"/>
          </a>

          <div v-if="slideFile && slideFile.fileType == 'Picture'" class="image-container">
            <img id="my-image" class="image" :src="slideFile.fullUrl" :class="{'fullWidth': fullWidth, 'fullHeight': !fullWidth}" @load="mediaLoaded" />
          </div>

          <iframe v-if="slideFile && slideFile.fileType == 'Document'" class="doc" :src="slideFile.iframeSource"></iframe>

          <div v-if="slideFile && slideFile.fileType == 'Audio'" class="audio-container">
            <div class="card">
              <div class="card-content">
                <h5 class="title is-5">{{slideFile.name}}</h5>
                <audio id="my-audio" controls class="audio">
                  <source :src="slideFile.fullUrl" type="audio/mpeg">
                  Your browser does not support the audio element.
                </audio>
              </div>
            </div>
          </div>

          <div v-if="slideFile && slideFile.fileType == 'Video'" class="video-container">
            <video id="my-video" controls class="video" @loadeddata="mediaLoaded" :class="{'fullWidth': fullWidth, 'fullHeight': !fullWidth}">
              <source :src="slideFile.fullUrl" type="video/mp4">
              Your browser does not support the video element.
            </video>
          </div>

          <div v-if="slideFile && slideFile.fileType == 'YouTube'" class="youtube-container">
            <iframe class="youtube" :src="slideFile.fullUrl" frameBorder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen></iframe>
          </div>

          <div v-if="!slideFile" class="welcome-block-container">
            <div class="welcome-block" v-if="welcomeBlock">
              <block :blockObj="welcomeBlock" :editable="true" :inTable="false" :textColor="'white!important'" @blockChanged="welcomeBlockChanged"></block>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div class="schedule-blocks">
        <h5 class="title is-5">最近的服侍安排：</h5>
        <div class="columns is-multiline">
          <div v-for="s in scheduleBlocks" class="column is-half">
            <div class="card">
              <div class="card-content">
                <block :blockObj="s" :editable="false" :inTable="false"></block>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Block from './Block'

export default {
  name: 'my-main',
  components: {
    Block
  },
  data () {
    return {
      slideWidth: 0,
      welcomeBlock: null,
      scheduleBlocks: [],
      homeFiles: [],
      slideIndex: 0,
      mediaRatio: null
    }
  },
  computed: {
    windowWidth () {
      return this.$store.state.ui.windowWidth
    },
    slideHeight () {
      return 640
    },
    angleTop () {
      return 300
    },
    slidePadding () {
      return this.windowWidth > 600 ? 20 : 10
    },
    slideFile () {
      if(this.slideIndex >= 0 && this.slideIndex < this.homeFiles.length){
        var file = this.homeFiles[this.slideIndex]
        if(file){
          var fullUrl = file.url.startsWith('/') ? (xHTTPx + '/cccl_files' + file.url) : file.url
          var iframeSource = "https://docs.google.com/gview?url=" + fullUrl + "&embedded=true"
          return {
            name: file.name,
            fileType: file.fileType,
            fullUrl: fullUrl,
            iframeSource: iframeSource
          }
        }
      }
    },
    fullWidth () {
      if(this.mediaRatio){
        var h = this.slideWidth * this.mediaRatio
        return h < this.slideHeight
      }
    }
  },
  watch: {
    windowWidth: function (val) {
      this.slideWidth = document.getElementById('slides-container').offsetWidth
    },
    slideFile: function (val) {
      var video = document.getElementById('my-video')
      if(video)
        video.load()
      var audio = document.getElementById('my-audio')
      if(audio)
        audio.load()
    }
  },
  methods: {
    requestWelcomeBlock () {
      this.$http.post(xHTTPx + '/get_block_by_name', {name: 'Welcome!'}).then(response => {
        this.welcomeBlock = response.body
      })
    },
    welcomeBlockChanged (obj) {
      this.welcomeBlock.content = obj.content
    },
    requestRecentSchedule () {
      this.$http.get(xHTTPx + '/get_recent_schedule_blocks').then(response => {
        this.scheduleBlocks = response.body.sort(function(a, b){
          return a.time - b.time
        })
      })
    },
    requestHomeFiles () {
      this.$http.get(xHTTPx + '/get_home_files').then(response => {
        this.homeFiles = response.body.sort(function(a, b){
          return a.info - b.info
        })
        this.homeFiles.unshift(null)
      })
    },
    mediaLoaded () {
      if(this.slideFile.fileType == 'Video'){
        var vid = document.getElementById("my-video")
        this.mediaRatio = vid.videoHeight / vid.videoWidth
      }else if(this.slideFile.fileType == 'Picture'){
        var img = document.getElementById('my-image')
        this.mediaRatio = img.clientHeight / img.clientWidth
        var newImg = new Image()
        var vm = this
        newImg.onload = function() {
          var ratio = newImg.height / newImg.width
          if(ratio >= 1){
            if(vm.mediaRatio >= 1){
              vm.mediaRatio = ratio
            }else{
              vm.mediaRatio = 1 / ratio
            }
          }else{
            if(vm.mediaRatio >= 1){
              vm.mediaRatio = 1 / ratio
            }else{
              vm.mediaRatio = ratio
            }
          }
        }
        newImg.src = this.slideFile.fullUrl
      }
    }
  },
  mounted () {
    this.slideWidth = document.getElementById('slides-container').offsetWidth
    this.requestHomeFiles()
    this.requestWelcomeBlock()
    this.requestRecentSchedule()
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.my-back {
  background-image: url("/static/Starry Sky 3.jpg");
  background-color: #cccccc;
  background-position: center; /* Center the image */
  background-repeat: no-repeat; /* Do not repeat the image */
  background-size: cover;
}

.slides-container:hover {
  .slide-left {
    display: block;
  }

  .slide-right {
    display: block;
  }
}

.slides-container {
  width: 100%;
  position: relative;

  .slide-left {
    z-index: 10;
    position: absolute;
    top: 260px;
    cursor: pointer;
    background-color: rgba(0, 0, 0, 0);
    display: none;
  }

  .slide-right {
    z-index: 10;
    position: absolute;
    top: 260px;
    right: 0px;
    cursor: pointer;
    background-color: rgba(0, 0, 0, 0);
    display: none;
  }

  .image-container {
    width: 100%;
    height: 100%;
    position: relative;

    .image {
      left: 50%;
      position: absolute;
      top: 50%;
      transform: translate(-50%, -50%);
      border-radius: 5px;
    }
  }

  .doc {
    width: 100%;
    height: 100%;
    border-radius: 5px;
  }

  .audio-container {
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);

    .card {
      border-radius: 5px;
    }
  }

  .video-container {
    width: 100%;
    height: 100%;
    position: relative;

    .video {
      left: 50%;
      position: absolute;
      top: 50%;
      transform: translate(-50%, -50%);
      border-radius: 5px;
    }
  }

  .youtube-container {
    width: 100%;

    .youtube {
      position: absolute;
      top: 0px;
      left: 0px;
      width:100%;
      height:100%;
      border-radius: 5px;
    }
  }

  .welcome-block-container{
    width: 100%;
    height: 100%;
    position: relative;

    .welcome-block {
      width: 95%;
      max-width: 600px;
      left: 50%;
      position: absolute;
      top: 50%;
      transform: translate(-50%, -50%);
      border-radius: 5px;
      padding: 20px;
      background-color: rgba(255,255,255,0.2);
    }
  }
}

.fullWidth {
  width: 100%;
  height: auto;
}

.fullHeight {
  height: 100%;
  width: auto;
}

.schedule-blocks {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
