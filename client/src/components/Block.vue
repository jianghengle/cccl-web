<template>
  <div>
    <h4 class="title is-4" v-if="normal" :style="{'color': textColor}">
      <span>{{title}}</span>
      <a class="button is-white is-small" :class="{'no-background': textColor}" v-if="editable && token" @click="startEditing">
        <v-icon class="icon has-text-grey-light" :style="{'color': textColor}" name="edit"/>
      </a>
    </h4>
    <div class="table-header" v-if="!normal">
      <span :style="{'color': textColor}"><strong>{{title}}</strong></span>
      &nbsp;
      <a class="button is-white is-small" v-if="editable && token && blockObj.open" @click="startEditing">
        <v-icon class="icon has-text-grey-light" name="edit"/>
      </a>
    </div>

    <div v-if="!inTable || blockObj.open">
      <div class="content" v-if="!editing" :style="{'color': textColor ? textColor : 'black'}">
        <vue-markdown :source="content"></vue-markdown>
      </div>
      <div v-else>
        <div class="field datepicker-field" v-if="!normal">
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

        <div class="field" v-if="!normal">
          <div class="control">
            <input class="input" type="text" placeholder="Event name" v-model="name">
          </div>
        </div>

        <div class="field">
          <div class="control">
            <textarea :id="'textarea-'+blockObj.id" class="textarea" v-model="content"></textarea>
          </div>
        </div>

        <div class="field is-grouped button-field">
          <div class="control">
            <button class="button is-link" :class="{'is-loading': waiting}" :disabled="!changed" @click="update">Update</button>
          </div>
          <div class="control" v-if="!normal">
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
  props: ['blockObj', 'editable', 'inTable', 'textColor'],
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
      return DateFormat(this.date, 'yyyy-mm-dd ddd') + ': ' +  this.name
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
        time: Math.round(this.date.getTime() / 1000)
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
        this.waiting = false
        this.cancelEditing()
      })
    },
    newDateSelected (date) {
      this.date = date
    },
    deleteBlock () {
      var confirm = {
        title: 'Delete Event',
        message: 'Are you sure to delete this event?',
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

.no-background {
  background-color: transparent;
}

.no-background:hover{
  background-color: transparent;
}


</style>
