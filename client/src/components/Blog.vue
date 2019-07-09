<template>
  <div class="container my-page">
    <div class="blog-block" v-if="blog">
      <block :blockObj="blog" :editable="true" :inTable="false" @blockChanged="blogChanged" @blockDeleted="blogDeleted"></block>
    </div>
  </div>
</template>

<script>
import Block from './Block'
import DateFormat from 'dateformat'

export default {
  name: 'blog',
  components: {
    Block
  },
  data () {
    return {
      blog: null,
      waiting: false,
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    blockId () {
      return this.$route.params.id
    },
  },
  methods: {
    requestBlog () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_block/' + this.blockId).then(response => {
        this.blog = response.body
        this.waiting = false
      }, response => {
        console.log('Failed to get block!')
        this.waiting = false
      })
    },
    blogChanged (obj) {
      this.blog.name = obj.name
      this.blog.time = obj.time
      this.blog.content = obj.content
      this.blog.color = obj.color
    },
    blogDeleted (obj) {
      this.$router.replace('/blogs')
    }
  },
  mounted () {
    this.requestBlog()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.blog-block {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
