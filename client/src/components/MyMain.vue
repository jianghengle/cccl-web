<template>
  <div>
    <div class="my-back" id="slide-back" @touchstart="touchstart" @touchend="touchend" :style="{'background-image': backUrl}">
      <div class="container" :style="{'padding': slidePadding + 'px'}">
        <div id="slides-container" class="slides-container" :style="{'height': slideHeight+'px'}">
          <a class="button is-large is-text slide-left" :style="{'top': angleTop+'px'}" @click="slideIndex = (slideIndex-1) < 0 ?  (slideFiles.length - 1) : slideIndex-1">
            <v-icon class="icon has-text-grey-light" name="angle-left"/>
          </a>
          <a class="button is-large is-text slide-right" :style="{'top': angleTop+'px'}" @click="slideIndex = (slideIndex+1) % slideFiles.length">
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
              <block :blockObj="welcomeBlock" :editable="true" :inTable="false" @blockChanged="welcomeBlockChanged"></block>
            </div>
          </div>
        </div>
      </div>
    </div>

    <section class="hero" v-for="f in otherFiles">
      <img v-if="f.fileType == 'Picture'" :src="f.fullUrl" class="full-width" />
      <iframe v-if="f.fileType == 'Document'" :src="f.iframeSource" :style="{'width': '100%', 'height': windowWidth*0.75 + 'px'}"></iframe>
      <audio v-if="f.fileType == 'Audio'" controls class="full-width">
        <source :src="f.fullUrl" type="audio/mpeg">
        Your browser does not support the audio element.
      </audio>
      <video v-if="f.fileType == 'Video'" controls class="full-width">
        <source :src="f.fullUrl" type="video/mp4">
        Your browser does not support the video element.
      </video>
      <iframe v-if="f.fileType == 'YouTube'" :src="f.fullUrl" frameBorder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen :style="{'width': '100%', 'height': windowWidth*0.75 + 'px'}"></iframe>
    </section>

    <div class="container">
      <div class="blog-blocks">
        <h5 class="title is-5">最新动态：</h5>
        <div v-for="(blog, i) in blogs" class="blog-block" :key="blog.id" @click="openBlog(blog)">
          <h5 class="title is-5 blog-title">
            <span>{{blog.name}}</span>
          </h5>
          <div class="blog-content" v-html="blog.content"></div>
          <hr />
        </div>
      </div>
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
      blogs: [],
      slideIndex: 0,
      mediaRatio: null,
      startX: null,
      startY: null,
      startTime: null,
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
      return 285
    },
    slidePadding () {
      return this.windowWidth > 600 ? 20 : 10
    },
    slideFiles () {
      var files = this.homeFiles.filter(function(f){
        return parseInt(f.info) > 0
      })
      files.sort(function(a, b){
        return a.info - b.info
      })
      files.unshift(null)
      return files
    },
    slideFile () {
      if(this.slideIndex >= 0 && this.slideIndex < this.slideFiles.length){
        var file = this.slideFiles[this.slideIndex]
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
    },
    backUrl () {
      for(var i=0;i<this.homeFiles.length;i++){
        var f = this.homeFiles[i]
        if(f && parseInt(f.info) === 0 && f.fileType == 'Picture'){
          var fullUrl = f.url.startsWith('/') ? (xHTTPx + '/cccl_files' + f.url) : f.url
          return 'url("' + fullUrl + '")'
        }
      }
      return 'url("/static/Starry Sky 3.jpg")'
    },
    otherFiles () {
      var files = this.homeFiles.filter(function(f){
        return parseInt(f.info) < 0
      })
      files.sort(function(a, b){
        return b.info - a.info
      })
      return files.map(function(f){
        var fullUrl = f.url.startsWith('/') ? (xHTTPx + '/cccl_files' + f.url) : f.url
        var iframeSource = "https://docs.google.com/gview?url=" + fullUrl + "&embedded=true"
        return {
          name: f.name,
          fileType: f.fileType,
          fullUrl: fullUrl,
          iframeSource: iframeSource
        }
      })
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
      this.welcomeBlock.color = obj.color
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
        this.homeFiles = response.body
      })
    },
    requestBlogs () {
      this.$http.get(xHTTPx + '/get_blog_blocks').then(response => {
        var blogs = response.body
        blogs.sort(function(a, b){
          return b.time - a.time
        })
        this.blogs = blogs
      })
    },
    mediaLoaded () {
      if(this.slideFile && this.slideFile.fileType == 'Video'){
        var vid = document.getElementById("my-video")
        this.mediaRatio = vid.videoHeight / vid.videoWidth
      }else if(this.slideFile && this.slideFile.fileType == 'Picture'){
        var img = document.getElementById('my-image')
        this.mediaRatio = img.clientHeight / img.clientWidth
        var newImg = new Image()
        var vm = this
        newImg.onload = function() {
          vm.mediaRatio = newImg.height / newImg.width
        }
        newImg.src = this.slideFile.fullUrl
      }
    },
    touchstart (e) {
      var touchobj = e.changedTouches[0]
      this.startX = touchobj.pageX
      this.startY = touchobj.pageY
      this.startTime = new Date().getTime()
    },
    touchend (e) {
      var touchobj = e.changedTouches[0]
      var distX = touchobj.pageX - this.startX
      var distY = touchobj.pageY - this.startY
      var elapsedTime = new Date().getTime() - this.startTime
      if (elapsedTime <= 300){
        if (Math.abs(distX) >= 100 && Math.abs(distY) <= 100){
          if(distX < 0){
            this.slideIndex = (this.slideIndex+1) % this.slideFiles.length
          }else{
            this.slideIndex = (this.slideIndex-1) < 0 ?  (this.slideFiles.length - 1) : (this.slideIndex-1)
          }
        }
      }
    },
    openBlog (blog) {
      this.$router.push('/blog/' + blog.id)
    }
  },
  mounted () {
    this.slideWidth = document.getElementById('slides-container').offsetWidth
    this.requestHomeFiles()
    this.requestWelcomeBlock()
    this.requestRecentSchedule()
    this.requestBlogs()
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.my-back {
  background-color: black;
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
      max-height: 100%;
      overflow: hidden;
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

.full-width {
  width: 100%;
}

.blog-blocks {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

.blog-block {
  cursor: pointer;
  margin-top: 20px;
}

.blog-title {
  margin-bottom: 10px;
}

.blog-content {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.schedule-blocks {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
