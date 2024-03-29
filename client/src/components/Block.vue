<template>
  <div>
    <h4 class="title is-4" v-if="category != 'Schedule'" :style="{'color': textColor}">
      <span v-if="category == 'Blog'">
        <a class="button back-button" @click="$router.go(-1)">
          <v-icon name="angle-left"/>
        </a>&nbsp;
      </span>
      <span>{{title}}</span>
      <span class="date-label" v-if="category == 'Blog'">{{dateLabel}}</span>
      <a class="button is-text is-small" v-if="editable && token" @click="startEditing">
        <v-icon class="icon has-text-grey-light" name="edit"/>
      </a>
    </h4>
    <div class="table-header" v-if="category == 'Schedule'">
      <span :style="{'color': textColor}"><strong>{{title}}</strong></span>
      &nbsp;
      <a class="button is-white is-small" v-if="editable && token && blockObj.open" @click="startEditing">
        <v-icon class="icon has-text-grey-light" name="edit"/>
      </a>
    </div>

    <div v-if="!inTable || blockObj.open">
      <div class="content" v-if="!editing" :style="{'color': textColor}">
        <vue-markdown :source="content"></vue-markdown>
      </div>
      <div v-else>
        <div class="field datepicker-field" v-if="category == 'Schedule'">
          <div class="control">
            <datepicker
              wrapper-class="date-picker-wrapper"
              input-class="date-picker-input"
              format="MMM dd yyyy"
              :value="date"
              v-on:selected="newDateSelected">
            </datepicker>
          </div>
        </div>

        <div class="field" v-if="category != 'Normal'">
          <div class="control">
            <input class="input" type="text" placeholder="Name" v-model="name">
          </div>
        </div>

        <div class="field">
          <div class="control">
            <span class="select">
              <select v-model="color">
                <option v-for="option in colorOptions" v-bind:value="option.value">
                  {{ option.label }}
                </option>
              </select>
            </span>
          </div>
        </div>

        <div class="field">
          <div class="control">
            <textarea :id="'textarea-'+blockObj.id" class="textarea" v-model="content"></textarea>
          </div>
          <p class="help is-info">
            <a class="button is-small is-white" href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet" target="_blank">
              <span class="icon"><v-icon name="brands/markdown"/></span>
              <span>Markdown Help</span>
            </a>
          </p>
        </div>

        <div class="field is-grouped button-field">
          <div class="control">
            <button class="button is-link" :class="{'is-loading': waiting}" :disabled="!changed" @click="update">Update</button>
          </div>
          <div class="control" v-if="category != 'Normal' && category != 'Page'">
            <button class="button is-danger" :class="{'is-loading': waiting}" @click="deleteBlock">Delete</button>
          </div>
          <div class="control">
            <button class="button is-light" @click="cancelEditing">Cancel</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import DateFormat from 'dateformat'
import VueMarkdown from 'vue-markdown'
import Datepicker from 'vuejs-datepicker'

DateFormat.i18n = {
    dayNames: [
        '周日', '周一', '周二', '周三', '周四', '周五', '周六',
        'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ],
    monthNames: [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ],
    timeNames: [
        'a', 'p', 'am', 'pm', 'A', 'P', 'AM', 'PM'
    ]
};

export default {
  name: 'block',
  components: {
    VueMarkdown,
    Datepicker
  },
  props: ['blockObj', 'editable', 'inTable', 'maxTextareaHeight'],
  data () {
    return {
      waiting: false,
      editing: false,
      content: '',
      date: null,
      name: null,
      color: '',
      colorOptions: [
        {label: 'Black', value: 'black'},
        {label: 'White', value: 'white'},
        {label: 'Purple', value: '#250d3c'},
        {label: 'Blue', value: '#055C9D'},
        {label: 'Green', value: '#116530'},
        {label: 'Gold', value: '#ebb22f'},
        {label: 'Red', value: '#DB1F48'},
      ]
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    category () {
      return this.blockObj.category
    },
    title () {
      if(this.category != 'Schedule')
        return this.name
      return DateFormat(this.date, 'yyyy-mm-dd ddd') + ': ' +  this.name
    },
    dateLabel () {
      return DateFormat(this.date, 'mmmm d, yyyy')
    },
    changed () {
      return this.content != this.blockObj.content
        || this.date.getTime() != this.blockObj.time * 1000
        || this.name != this.blockObj.name
        || this.color != this.blockObj.color
    },
    textColor () {
      if(this.blockObj.color)
        return this.blockObj.color
      return 'black'
    }
  },
  watch: {
    blockObj: function (val) {
      this.content = this.blockObj.content
      this.date = new Date(this.blockObj.time * 1000)
      this.name = this.blockObj.name
      this.color = this.blockObj.color
    },
  },
  methods: {
    startEditing () {
      this.editing = true
      var vm = this
      this.$nextTick(function(){
        var el = document.getElementById('textarea-' + this.blockObj.id)
        el.style.height = "1px"
        if (vm.maxTextareaHeight) {
          if ((25+el.scrollHeight) > vm.maxTextareaHeight) {
            el.style.height = vm.maxTextareaHeight + 'px'
          } else {
            el.style.height = (25+el.scrollHeight)+"px"
          }
        } else {
          el.style.height = (25+el.scrollHeight)+"px"
        }
      })
    },
    cancelEditing () {
      this.content = this.blockObj.content
      this.date = new Date(this.blockObj.time * 1000)
      this.name = this.blockObj.name
      this.color = this.blockObj.color
      this.editing = false
    },
    update () {
      var message = {
        id: this.blockObj.id,
        name: this.name,
        content: this.content,
        time: Math.round((this.category == 'Blog' ? Date.now() : this.date.getTime()) / 1000),
        color: this.color,
      }
      this.waiting = true
      this.$http.post(xHTTPx + '/update_block', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.editing = false
        if(resp.ok){
          this.$emit('blockChanged', message)
          this.date = new Date(message.time * 1000)
        }else{
          this.cancelEditing()
        }
      }, response => {
        this.waiting = false
        this.cancelEditing()
      })
    },
    newDateSelected (date) {
      this.date = date
    },
    deleteBlock () {
      var confirm = {
        title: 'Delete',
        message: 'Are you sure to delete it?',
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed () {
      var message = {id: this.blockObj.id}
      this.$http.post(xHTTPx + '/delete_block', message).then(response => {
        var resp = response.body
        this.waiting = false
        if(resp.ok){
          this.$emit('blockDeleted', message)
        }
      }, response => {
        this.waiting = false
      })
    }
  },
  mounted () {
    this.content = this.blockObj.content
    this.date = new Date(this.blockObj.time * 1000)
    this.name = this.blockObj.name
    this.color = this.blockObj.color
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.table-header {
  margin-top: 2px;
}

.datepicker-field {
  margin-top: 20px;
}

.button-field {
  margin-bottom: 10px;
}

.date-label {
  font-size: 16px;
  color: hsl(0, 0%, 48%);
}

.back-button {
  position: relative;
  top: -5px;
}

</style>
