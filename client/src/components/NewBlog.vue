<template>
  <div class="container my-page">
    <div class="new-blog-block">
      <div class="columns">
        <div class="column">
          <h4 class="title is-4">New Blog</h4>
        </div>
      </div>

      <div class="field">
        <label class="label">Name</label>
        <div class="control">
          <input class="input" type="text" placeholder="Blog name" v-model="newName">
        </div>
      </div>

      <div class="field">
        <label class="label">Text Color</label>
        <div class="control">
          <span class="select">
            <select v-model="newColor">
              <option v-for="option in colorOptions" v-bind:value="option.value">
                {{ option.label }}
              </option>
            </select>
          </span>
        </div>
      </div>

      <div class="field">
        <label class="label">Content</label>
        <div class="control">
          <textarea id="new-blog-content" class="textarea" placeholder="Blog content" v-model="newContent" @change="newBlogContentChanged"></textarea>
        </div>
      </div>

      <div v-if="error" class="notification is-danger">
        <button class="delete" @click="error=''"></button>
        {{error}}
      </div>

      <div class="field is-grouped">
        <div class="control">
          <a class="button is-link" :disabled="!canCreate" :class="{'is-loading': waiting}" @click="createBlog">Create</a>
        </div>
        <div class="control">
          <router-link class="button is-text" :to="'/blogs'">Cancel</router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'new-blog',
  data () {
    return {
      newName: '',
      newContent: '',
      newColor: 'black',
      colorOptions: [
        {label: 'Black', value: 'black'},
        {label: 'White', value: 'white'},
        {label: 'Purple', value: '#250d3c'},
        {label: 'Blue', value: '#055C9D'},
        {label: 'Green', value: '#116530'},
        {label: 'Gold', value: '#ebb22f'},
        {label: 'Red', value: '#DB1F48'},
      ],
      waiting: false,
      error: ''
    }
  },
  computed: {
    canCreate () {
      return this.newName.trim() && this.newContent.trim()
    }
  },
  methods: {
    createBlog () {
      if(this.waiting || !this.canCreate)
        return

      this.waiting = true
      var message = {
        name: this.newName,
        time: Math.round(Date.now() / 1000),
        content: this.newContent,
        color: this.newColor
      }
      this.$http.post(xHTTPx + '/add_blog_block', message).then(response => {
        var resp = response.body
        this.waiting = false
        if(resp && resp.id){
          this.$router.push('/blog/' + resp.id)
          this.error = ''
        }else{
          this.error = 'Failed to add blog!'
        }
      }, response => {
        this.waiting = false
        this.error = 'Failed to add blog!'
      })
    },
    newBlogContentChanged () {
      setTimeout(function(){
        var el = document.getElementById('new-blog-content');
        if(el){
          el.style.height = "1px";
          el.style.height = (25+el.scrollHeight)+"px";
        }
      }, 500)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.new-blog-block {
  margin-top: 50px;
  margin-bottom: 50px;
  padding-left: 10px;
  padding-right: 10px;
}

</style>
