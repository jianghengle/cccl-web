<template>
  <div class="container my-page">
    <div class="page-block" v-if="page">
      <block :blockObj="page" :editable="true" :inTable="false" @blockChanged="pageChanged"></block>
    </div>
  </div>
</template>

<script>
import Block from './Block'
import DateFormat from 'dateformat'

export default {
  name: 'page',
  components: {
    Block
  },
  data () {
    return {
      page: null,
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
  watch: {
    blockId: function (val) {
      this.requestPage()
    },
  },
  methods: {
    requestPage () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_block/' + this.blockId).then(response => {
        this.page = response.body
        this.waiting = false
      }, response => {
        console.log('Failed to get block!')
        this.waiting = false
      })
    },
    pageChanged (obj) {
      this.page.name = obj.name
      this.page.time = obj.time
      this.page.content = obj.content
      this.page.color = obj.color
    },
  },
  mounted () {
    this.requestPage()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.page-block {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
