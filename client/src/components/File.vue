<template>
  <div>
    <div class="container file-container" v-if="file">
      <div class="page-title-row">
        <a class="button back-button" @click="$router.go(-1)">
          <v-icon name="chevron-left"></v-icon>
        </a>
        <a class="button is-danger file-button" @click="deleteSelf">Delete</a>
        <h5 class="title is-5 page-title">{{file.name}}</h5>
      </div>

      <div>
        <div class="field">
          <div class="control">
            <a :href="fullUrl">{{fullUrl}}</a>
          </div>
        </div>

        <div class="field has-addons">
          <p class="control">
            <span class="select">
              <select v-model="showOnHome">
                <option>On Home Page</option>
                <option>Not on Home Page</option>
              </select>
            </span>
          </p>
          <p class="control is-expanded" v-if="showOnHome == 'On Home Page'">
            <input class="input" type="number" placeholder="Order" v-model.number="showOrder">
          </p>
          <p class="control" v-if="info != file.info">
            <a class="button is-link" @click="update">
              Update
            </a>
          </p>
        </div>

        <div class="preview">
          <div v-if="file.fileType == 'Picture'">
            <img :src="fullUrl" class="picture" />
          </div>
          <div v-if="file.fileType == 'Document'">
            <iframe class="doc" :src="iframeSource"></iframe>
          </div>
          <div v-if="file.fileType == 'Audio'">
            <audio controls>
              <source :src="fullUrl" type="audio/mpeg">
              Your browser does not support the audio element.
            </audio>
          </div>
          <div v-if="file.fileType == 'Video'">
            <video controls class="video">
              <source :src="fullUrl" type="video/mp4">
              Your browser does not support the video element.
            </video>
          </div>
          <div v-if="file.fileType == 'YouTube'" class="youtube-container">
            <iframe class="youtube" :src="fullUrl" frameBorder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowFullScreen></iframe>
          </div>
        </div>

      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'file',
  data () {
    return {
      file: null,
      showOnHome: 'On Home Page',
      showOrder: 1
    }
  },
  computed: {
    fileId () {
      return this.$route.params.id
    },
    changed () {
      return false
    },
    fullUrl () {
      if(this.file.url.startsWith('/')){
        return xHTTPx + '/cccl_files' + this.file.url
      }
      return this.file.url
    },
    iframeSource () {
      return "https://docs.google.com/gview?url=" + this.fullUrl + "&embedded=true"
    },
    info () {
      return this.showOnHome == 'On Home Page' ? this.showOrder : ''
    }
  },
  methods: {
    requestFile () {
      this.$http.get(xHTTPx + '/get_file/' + this.fileId).then(response => {
        this.file = response.body
        if(this.file.info){
          this.showOnHome = 'On Home Page'
          this.showOrder = this.file.info
        }else{
          this.showOnHome = 'Not on Home Page'
          this.showOrder = 1
        }
      }, response => {
        console.log('Failed to get file!')
      })
    },
    update () {
      var message = {info: this.info}
      this.$http.post(xHTTPx + '/update_file/' + this.fileId, message).then(response => {
        var resp = response.body
        this.requestFile()
      }, response => {
        console.log('Failed to update file!')
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Resource',
        message: 'Are you sure to delete the resource?',
        button: 'Yes, delete it.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed () {
      var message = {fileId: this.fileId}
      this.$http.post(xHTTPx + '/delete_file', message).then(response => {
        if(response.body.ok){
          this.$router.go(-1)
        }
      }, response => {
        console.log('Failed to delete file!')
      })
    },
  },
  mounted () {
    this.requestFile()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.file-container {
  margin-top: 20px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.page-title-row {
  margin-bottom: 15px;

  .back-button {
    float: left;
    margin-right: 10px;
  }

  .file-button {
    float: right;
    margin-left: 10px;
  }

  .page-title {
    padding-top: 7px;
  }
}

.preview {
  margin-top: 20px;
}

.picture {
  max-width: 100%;
}

.doc {
  width: 100%;
  height: 600px;
}

.video {
  width: 100%;
  height: auto;
}

.youtube-container {
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

</style>
