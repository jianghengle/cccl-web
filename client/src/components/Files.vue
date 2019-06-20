<template>
  <div>
    <div class="container files-container">
      <div class="columns files-title">
        <div class="column address-column">
          <nav class="breadcrumb" aria-label="breadcrumbs">
            <ul class="address-bar">
              <li v-for="(r, i) in routers">
                <router-link v-if="i != routers.length - 1" :to="r[1]"><strong>{{r[0]}}</strong></router-link>
                <a v-if="i == routers.length - 1" :href="staticPath" target="_blank"><strong>{{r[0]}}</strong></a>
              </li>
            </ul>
          </nav>
        </div>
        <div class="column is-narrow" v-if="token">
          <div class="dropdown is-hoverable" :class="{'is-right': windowWidth > 768}">
            <div class="dropdown-trigger">
              <button class="button" aria-haspopup="true" aria-controls="dropdown-menu">
                <span>New</span>
                <span class="icon is-small">
                  <v-icon name="angle-down" aria-hidden="true"></v-icon>
                </span>
              </button>
            </div>
            <div class="dropdown-menu" id="dropdown-menu" role="menu">
              <div class="dropdown-content">
                <a href="#" class="dropdown-item" @click="openNewFileModal">
                  New Resource
                </a>
                <a class="dropdown-item" @click="openNewFileModal">
                  New Directory
                </a>
                <hr class="dropdown-divider">
                <a href="#" class="dropdown-item has-text-danger">
                  Delete this Directory
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div>
        <table class="table is-fullwidth is-hoverable">
          <thead>
            <tr>
              <th>#</th>
              <th class="has-text-centered">Type</th>
              <th>Name</th>
              <th>Slide</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(f, i) in files" class="clickable" :class="{'slide-show': f.info}" @click="openFile(f)">
              <td>{{i+1}}</td>
              <td class="icon-cell">
                <v-icon class="v-icon" name="folder" scale="1.2" v-if="f.fileType == 'Directory'" />
                <v-icon class="v-icon" name="file-alt" scale="1.2" v-if="f.fileType == 'Document'" />
                <v-icon class="v-icon" name="file-image" scale="1.2" v-if="f.fileType == 'Picture'" />
                <v-icon class="v-icon" name="file-audio" scale="1.2" v-if="f.fileType == 'Audio'" />
                <v-icon class="v-icon" name="file-video" scale="1.2" v-if="f.fileType == 'Video'" />
                <v-icon class="v-icon" name="brands/youtube" scale="1.2" v-if="f.fileType == 'YouTube'" />
              </td>
              <td class="filename-cell" :class="{'has-text-weight-bold': f.fileType=='Directory'}">{{f.name}}</td>
              <td>{{f.info}}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="has-text-centered" v-if="waiting">
        <v-icon name="spinner" class="icon is-medium fa-spin"></v-icon>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'files',
  data () {
    return {
      waiting: false,
      categories: ['Picture', 'Document', 'Audio', 'Video', 'YouTube'],
      files: [],
      listUrl: xHTTPx + '/cccl_files',
    }
  },
  computed: {
    path () {
      var path = this.$route.params.path
      return path ? decodeURIComponent(path) : ''
    },
    staticPath () {
      return this.listUrl + '/' + this.path
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
    token () {
      return this.$store.state.user.token
    },
    windowWidth () {
      return this.$store.state.ui.windowWidth
    },
  },
  watch: {
    path: function (val) {
      this.requestFiles()
    },
  },
  methods: {
    openNewFileModal () {
      this.$store.commit('modals/openNewFileModal', {
        callback: { context: this, method: this.requestFiles}
      })
    },
    requestFiles () {
      this.waiting = true
      var message = {path: this.path}
      this.$http.post(xHTTPx + '/get_files', message).then(response => {
        this.files = response.body
        this.files.sort(function(a, b){
          if(a.fileType == 'Directory' && b.fileType != 'Directory')
            return -1
          if(a.fileType != 'Directory' && b.fileType == 'Directory')
            return 1
          return a.name.localeCompare(b.name)
        })
        this.waiting = false
      }, response => {
        console.log('Failed to get files!')
        this.waiting = false
      })
    },
    openFile(f){
      if(f.fileType == 'Directory'){
        var path = f.path ? (f.path + '/' + f.name) : f.name
        this.$router.push('/files/' + encodeURIComponent(path))
      }else{
        this.$router.push('/file/' + f.id)
      }
    }
  },
  mounted () {
    this.requestFiles()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.files-container {
  margin-top: 20px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.files-title {
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

.clickable {
  cursor: pointer;
}

.slide-show {
  background-color: hsl(0, 0%, 96%);
}

.icon-cell {
  text-align: center;

  .v-icon {
    position: relative;
    top: 3px;
  }
}

.filename-cell {
  word-break: break-word;
}

</style>
