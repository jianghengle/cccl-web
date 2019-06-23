<template>
  <div>
    <div class="container file-container" v-if="file">
      <div class="columns file-title">
        <div class="column address-column">
          <nav class="breadcrumb" aria-label="breadcrumbs">
            <ul class="address-bar">
              <li v-for="(r, i) in routers">
                <router-link :to="r[1]"><strong>{{r[0]}}</strong></router-link>
              </li>
              <li class="is-active"><a>{{file.name}}</a></li>
            </ul>
          </nav>
        </div>
        <div class="column is-narrow" v-if="token">
          <div class="dropdown is-hoverable" :class="{'is-right': windowWidth > 768}">
            <div class="dropdown-trigger">
              <button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
                <span>Delete</span>
                <span class="icon is-small">
                  <v-icon name="angle-down" aria-hidden="true"></v-icon>
                </span>
              </button>
            </div>
            <div class="dropdown-menu" id="dropdown-menu" role="menu">
              <div class="dropdown-content">
                <a class="dropdown-item has-text-danger" @click="deleteSelf">
                  Delete
                </a>
                <hr class="dropdown-divider">
                <a class="dropdown-item" v-for="d in directories" v-if="d.path != file.path" @click="moveSelf(d)">
                  Move To {{d.name}}
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div>
        <div class="field">
          <div class="control">
            <a :href="fullUrl" target="_blank">{{fullUrl}}</a>
          </div>
        </div>

        <div class="field" :class="{'is-grouped': windowWidth > 640}">
          <p class="control file-info">
            <span class="select">
              <select v-model="fileType" :disabled="!token">
                <option>Document</option>
                <option>Picture</option>
                <option>Audio</option>
                <option>Video</option>
                <option>YouTube</option>
              </select>
            </span>
          </p>
          <p class="control file-info">
            <span class="select">
              <select v-model="showOnHome" :disabled="!token">
                <option>On Home Page</option>
                <option>Not on Home Page</option>
              </select>
            </span>
          </p>
          <p class="control file-info" v-if="showOnHome == 'On Home Page'">
            <input class="input" type="number" placeholder="Order" v-model.number="showOrder" :disabled="!token">
          </p>
          <p class="control file-info" v-if="changed">
            <a class="button is-link" @click="update">
              Update
            </a>
          </p>
        </div>

        <div v-if="files.length">
          <nav class="pagination" role="navigation" aria-label="pagination">
            <a class="pagination-previous" :disabled="fileIndex == 0" @click="openFile(fileIndex - 1)">Previous</a>
            <a class="pagination-next":disabled="fileIndex == files.length - 1" @click="openFile(fileIndex + 1)">Next File</a>
            <ul class="pagination-list">
              <li v-if="fileIndex > 1">
                <a class="pagination-link" @click="openFile(0)">1</a>
              </li>
              <li v-if="fileIndex > 2">
                <span class="pagination-ellipsis">&hellip;</span>
              </li>
              <li v-if="fileIndex - 1 >= 0">
                <a class="pagination-link" @click="openFile(fileIndex - 1)">{{fileIndex}}</a>
              </li>
              <li>
                <a class="pagination-link is-current">{{fileIndex + 1}}</a>
              </li>
              <li v-if="fileIndex + 1 < files.length">
                <a class="pagination-link" @click="openFile(fileIndex + 1)">{{fileIndex + 2}}</a>
              </li>
              <li v-if="fileIndex + 3 < files.length">
                <span class="pagination-ellipsis">&hellip;</span>
              </li>
              <li v-if="fileIndex + 2 < files.length">
                <a class="pagination-link" @click="openFile(files.length - 1)">{{files.length}}</a>
              </li>
            </ul>
          </nav>
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
      showOrder: 1,
      fileType: '',
      files: [],
      directories: []
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    fileId () {
      return this.$route.params.id
    },
    changed () {
      return (this.info !== this.file.info) || (this.fileType != this.file.fileType)
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
    },
    path () {
      return this.file ? this.file.path : ''
    },
    routers() {
      var routers = [['Resources', '/files']]
      if(!this.path)
        return routers
      var ps = this.path.split('/')
      var p = ''
      for(var i=0;i<ps.length;i++){
        p = i==0 ? ps[i] : (p + '/'+ ps[i])
        routers.push([ps[i], '/files/' + encodeURIComponent(p)])
      }
      return routers
    },
    windowWidth () {
      return this.$store.state.ui.windowWidth
    },
    fileIndex () {
      for(var i=0;i<this.files.length;i++){
        if(this.file.id == this.files[i].id){
          return i
        }
      }
      return -1
    }
  },
  watch: {
    fileId: function (val) {
      this.requestFile()
    },
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
        this.fileType = this.file.fileType
        this.requestFiles()
      }, response => {
        console.log('Failed to get file!')
      })
    },
    requestFiles () {
      var message = {path: this.file.path}
      this.$http.post(xHTTPx + '/get_files', message).then(response => {
        this.files = response.body.filter(function(f){
          return f.fileType != 'Directory'
        })
        this.files.sort(function(a, b){
          return a.name.localeCompare(b.name)
        })
      }, response => {
        console.log('Failed to get files!')
      })
    },
    openFile(idx){
      if(idx < 0 || idx >= this.files.length){
        return
      }
      this.$router.push('/file/' + this.files[idx].id)
    },
    requestDirectories () {
      this.$http.get(xHTTPx + '/get_directories').then(response => {
        this.directories = response.body.map(function(f){
          var path = f.path ? (f.path + '/' + f.name) : f.name
          return {name: '/' + path, path: path}
        })
        this.directories.push({name: '/', path: null})
        this.directories.sort(function(a, b){
          return a.name.localeCompare(b.name)
        })
      }, response => {
        console.log('Failed to get directories!')
      })
    },
    update () {
      var message = {info: this.info, fileType: this.fileType}
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
        message: 'Are you sure to delete this resource?',
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
          this.$router.replace(this.routers[this.routers.length-1][1])
        }
      }, response => {
        console.log('Failed to delete file!')
      })
    },
    moveSelf (d) {
      var confirm = {
        title: 'Move Resource',
        message: 'Are you sure to move the resource to ' + d.name + '?',
        button: 'Yes, move it.',
        callback: {
          context: this,
          method: this.moveConfirmed,
          args: [d]
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    moveConfirmed (d) {
      var message = {fileId: this.fileId, moveTo: d.name}
      this.$http.post(xHTTPx + '/move_file', message).then(response => {
        if(response.body.ok){
          this.requestFile()
        }
      }, response => {
        console.log('Failed to move file!')
      })
    },
  },
  mounted () {
    this.requestFile()
    this.requestDirectories()
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

.file-title {
  margin-bottom: 0px;
}

.address-column {
  padding-top: 0px;
  padding-bottom: 0px;
}

.address-bar {
  flex-shrink: unset;
  flex-wrap: wrap;
  font-size: 1.25rem;
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

.file-info {
  margin-bottom: 10px;

  input {
    max-width: 200px;
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
