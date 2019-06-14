<template>
  <div>
    <h4 class="title is-4" v-if="!inTable">
      <span>{{title}}</span>
      <a class="button is-white is-small" v-if="editable && token" @click="startEditing">
        <v-icon class="icon has-text-grey-light" name="edit"/>
      </a>
    </h4>

    <div class="content" v-if="!editing">
      <vue-markdown :source="content"></vue-markdown>
    </div>
    <div v-else>
      <div class="field">
        <div class="control">
          <textarea :id="'textarea-'+blockObj.id" class="textarea" v-model="content"></textarea>
        </div>
      </div>
      <div class="field is-grouped">
        <div class="control">
          <button class="button is-link" :class="{'is-loading': waiting}" :disabled="!changed" @click="update">Update</button>
        </div>
        <div class="control">
          <button class="button is-text" @click="cancelEditing">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateFormat from 'dateformat'
import VueMarkdown from 'vue-markdown'

export default {
  name: 'block',
  components: {
    VueMarkdown
  },
  props: ['blockObj', 'editable', 'inTable'],
  data () {
    return {
      waiting: false,
      editing: false,
      content: '',
      date: null,
      name: null,
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    normal () {
      return this.blockObj.category == 'Normal'
    },
    title () {
      if(this.normal)
        return this.name
      return DateFormat(date, 'yyyy-m-d ddd') + ': ' +  this.name
    },
    changed () {
      return this.content != this.blockObj.content
        || this.date.getTime() != this.blockObj.time * 1000
        || this.name != this.blockObj.name
    }
  },
  methods: {
    startEditing () {
      this.editing = true
      this.$nextTick(function(){
        var el = document.getElementById('textarea-' + this.blockObj.id)
        el.style.height = "1px"
        el.style.height = (25+el.scrollHeight)+"px"
      })
    },
    cancelEditing () {
      this.content = this.blockObj.content
      this.date = new Date(this.blockObj.time * 1000)
      this.name = this.blockObj.name
      this.editing = false
    },
    update () {
      var message = {
        id: this.blockObj.id,
        name: this.name,
        content: this.content,
        time: this.date.getTime() / 1000
      }
      this.waiting = true
      this.$http.post(xHTTPx + '/update_block', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.editing = false
        if(resp.ok){
          this.$emit('blockChanged', message)
        }else{
          this.cancelEditing()
        }
      }, response => {
        this.error = 'Failed to update!'
        this.waiting = false
        this.cancelEditing()
      })
    }
  },
  mounted () {
    this.content = this.blockObj.content
    this.date = new Date(this.blockObj.time * 1000)
    this.name = this.blockObj.name
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>



</style>
