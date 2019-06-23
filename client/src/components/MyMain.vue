<template>
  <div>
    <div>
      <div class="container">
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
            <h5 class="title is-5">{{slideFile.name}}</h5>
            <audio id="my-audio" controls class="audio">
              <source :src="slideFile.fullUrl" type="audio/mpeg">
              Your browser does not support the audio element.
            </audio>
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
        </div>
      </div>
    </div>
    <div class="container welcome-block" v-if="welcomeBlock">
      <block :blockObj="welcomeBlock" :editable="true" :inTable="false" @blockChanged="welcomeBlockChanged"></block>
    </div>
    <div class="container schedule-blocks">
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
      return this.windowWidth > 600 ? 600 : 300
    },
    angleTop () {
      return this.windowWidth > 600 ? 280 : 130
    },
    slideFile () {
      if(this.slideIndex >= 0 && this.slideIndex < this.homeFiles.length){
        var file = this.homeFiles[this.slideIndex]
        var fullUrl = file.url.startsWith('/') ? (xHTTPx + '/cccl_files' + file.url) : file.url
        var iframeSource = "https://docs.google.com/gview?url=" + fullUrl + "&embedded=true"
        return {
          name: file.name,
          fileType: file.fileType,
          fullUrl: fullUrl,
          iframeSource: iframeSource
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

.slides-container {
  margin-top: 3px;
  width: 100%;
  position: relative;

  .slide-left {
    z-index: 10;
    position: absolute;
    top: 260px;
    cursor: pointer;
    background-color: rgba(0, 0, 0, 0);
  }

  .slide-right {
    z-index: 10;
    position: absolute;
    top: 260px;
    right: 0px;
    cursor: pointer;
    background-color: rgba(0, 0, 0, 0);
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
    }
  }

  .doc {
    width: 100%;
    height: 100%;
  }

  .audio-container {
    left: 50%;
    position: absolute;
    top: 50%;
    transform: translate(-50%, -50%);
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
    }
  }

  .youtube-container {
    height: 100%;
    position: relative;
    padding-top: 56.25%;

    .youtube {
      position: absolute;
      top: 0px;
      left: 0px;
      width:100%;
      height:100%;
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

.welcome-block {
  margin-top: 20px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.schedule-blocks {
  margin-top: 100px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
