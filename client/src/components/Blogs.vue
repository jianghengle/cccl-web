<template>
  <div class="container my-page">
    <div class="all-blogs-block">
      <div class="columns">
        <div class="column">
          <h4 class="title is-4">All Blogs</h4>
        </div>
        <div class="column is-narrow" v-if="token">
          <router-link class="button" :to="'/new-blog'">New Blog</router-link>
        </div>
      </div>

      <div class="has-text-centered" v-if="waiting">
        <v-icon name="spinner" class="icon is-medium fa-spin"></v-icon>
      </div>

      <div>
        <div v-for="(blog, i) in allBlogs" class="blog-block" :key="blog.id" @click="openBlog(blog)">
          <h5 class="title is-5 blog-title">
            <span class="date-label">{{blog.dateLabel}}</span>
            <span>{{blog.name}}</span>
          </h5>
          <div class="blog-content" v-html="blog.content"></div>
          <hr v-if="i < allBlogs.length-1" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Block from './Block'
import DateFormat from 'dateformat'

export default {
  name: 'blogs',
  components: {
    Block
  },
  data () {
    return {
      allBlogs: [],
      waiting: false,
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
  },
  methods: {
    requestBlogs () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_blog_blocks').then(response => {
        this.allBlogs = response.body.map(function(b){
          var date = new Date(b.time * 1000)
          b.dateLabel = DateFormat(date, 'mmmm d, yyyy')
          return b
        })
        this.allBlogs.sort(function(a, b){
          return b.time - a.time
        })
        this.waiting = false
      }, response => {
        console.log('Failed to get blocks!')
        this.waiting = false
      })
    },
    openBlog (blog) {
      this.$router.push('/blog/' + blog.id)
    }
  },
  mounted () {
    this.requestBlogs()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.all-blogs-block {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

.blog-block {
  cursor: pointer;
  margin-top: 20px;
}

.date-label {
  font-size: 16px;
  color: hsl(0, 0%, 48%);
  float: right;
  margin-left: 10px;
}


.blog-title {
  margin-bottom: 10px;
}

.blog-content {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
