<template>
  <div>
    <div class="container files-container">
      <div class="page-title-row">
        <a class="button is-link new-button" @click="openNewFileModal">New Resource</a>
        <h5 class="title is-5 page-title"><a :href="listUrl" target="_blank">Resources</a></h5>
      </div>
      <div class="tabs">
        <ul>
          <li :class="{'is-active': activeCategory=='All'}"><router-link :to="'/files/All'">All</router-link></li>
          <li v-for="c in categories" :class="{'is-active': activeCategory==c}"><router-link :to="'/files/'+c">{{c}}s</router-link></li>
        </ul>
      </div>
      <div class="has-text-centered" v-if="waiting">
        <v-icon name="spinner" class="icon is-medium fa-spin"></v-icon>
      </div>

      <div>
        <table class="table is-fullwidth is-hoverable">
          <thead>
            <tr>
              <th>Id</th>
              <th>Name</th>
              <th>Type</th>
              <th>Order</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="f in files" v-if="activeCategory=='All' || activeCategory==f.fileType" class="clickable" :class="{'slide-show': f.info}" @click="openFile(f)">
              <td>{{f.id}}</td>
              <td>{{f.name}}</td>
              <td>{{f.fileType}}</td>
              <td>{{f.info}}</td>
            </tr>
          </tbody>
        </table>
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
      listUrl: xHTTPx + '/cccl_files'
    }
  },
  computed: {
    activeCategory () {
      return this.$route.params.category
    },
  },
  methods: {
    openNewFileModal () {
      this.$store.commit('modals/openNewFileModal', {
        callback: { context: this, method: this.requestFiles}
      })
    },
    requestFiles (category) {
      if(category && this.activeCategory != 'All' && this.activeCategory != category){
        this.activeCategory = category
      }
      this.waiting = true
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.files = response.body
        this.waiting = false
      }, response => {
        console.log('Failed to get files!')
        this.waiting = false
      })
    },
    openFile(f){
      this.$router.push('/file/' + f.id)
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

.page-title-row {
  margin-bottom: 15px;

  .new-button {
    float: right;
  }

  .page-title {
    padding-top: 7px;
  }
}

.clickable {
  cursor: pointer;
}

.slide-show {
  background-color: hsl(0, 0%, 96%);
}

</style>
