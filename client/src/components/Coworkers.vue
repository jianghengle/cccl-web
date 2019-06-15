<template>
  <div>
    <div class="container schedule-block">
      <h4 class="title is-4">Schedule</h4>
      <div class="schedule-table">
        <table class="table is-fullwidth">
          <tbody>
            <tr v-for="s in schedule" :key="s.id">
              <td>
                <a class="button is-white is-small up-down-button" @click="s.open = !s.open">
                  <v-icon v-if="s.open" class="icon has-text-grey-light" name="chevron-up"/>
                  <v-icon v-if="!s.open" class="icon has-text-grey-light" name="chevron-down"/>
                </a>
                <block :blockObj="s" :editable="true" :inTable="true" @blockChanged="scheduleBlockChanged" @blockDeleted="scheduleBlockDeleted"></block>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="new-schedule-block" v-if="token">
        <div v-if="newSchedule">
          <div class="field">
            <label class="label">New Event</label>
          </div>

          <div class="field">
            <div class="control">
              <datepicker
                wrapper-class="date-picker-wrapper"
                input-class="date-picker-input"
                format="MMM dd yyyy"
                :value="newDate"
                v-on:selected="newDateSelected">
              </datepicker>
            </div>
          </div>
          
          <div class="field">
            <div class="control">
              <input class="input" type="text" placeholder="Event name" v-model="newName">
            </div>
          </div>

          <div class="field">
            <div class="control">
              <textarea class="textarea" placeholder="Coworker arrangement" v-model="newContent"></textarea>
            </div>
          </div>

          <div v-if="error" class="notification is-danger">
            <button class="delete" @click="error=''"></button>
            {{error}}
          </div>

          <div class="field is-grouped">
            <div class="control">
              <button class="button is-link" :class="{'is-loading': waiting}" @click="addSchedule">Add</button>
            </div>
            <div class="control">
              <button class="button is-text" @click="newSchedule = false">Cancel</button>
            </div>
          </div>

        </div>
        <div v-else>
          <a class="button is-link" @click="newSchedule = true">New Event</a>
        </div>
      </div>
    </div>
    <div class="container coworkders-block" v-if="coworkersBlock">
      <block :blockObj="coworkersBlock" :editable="true" :inTable="false" @blockChanged="coworkersBlockChanged"></block>
    </div>
  </div>
</template>

<script>
import Block from './Block'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'coworkers',
  components: {
    Block,
    Datepicker
  },
  data () {
    return {
      coworkersBlock: null,
      schedule: [],
      newDate: new Date(),
      newName: '',
      newContent: '',
      newSchedule: false,
      waiting: false,
      error: ''
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
  },
  methods: {
    coworkersBlockChanged (obj) {
      this.coworkersBlock.content = obj.content
    },
    requestCoworkers () {
      this.$http.post(xHTTPx + '/get_block_by_name', {name: 'Coworkers'}).then(response => {
        this.coworkersBlock = response.body
      }, response => {
        this.error = 'Failed to get block!'
      })
    },
    newDateSelected (date) {
      this.newDate = date
    },
    addSchedule () {
      if(this.waiting)
        return
      var message = {
        name: this.newName,
        time: Math.round(this.newDate.getTime() / 1000),
        content: this.newContent
      }
      this.waiting = true
      this.$http.post(xHTTPx + '/add_schedule_block', message).then(response => {
        var resp = response.body
        this.waiting = false
        if(resp && resp.id){
          resp.open = false
          this.schedule.push(resp)
          this.sortSchedule()
          this.error = ''
          this.newSchedule = false
        }else{
          this.error = 'Failed to add schedule!'
        }
      }, response => {
        this.waiting = false
        this.error = 'Failed to add schedule!'
      })
    },
    requestSchedule () {
      this.$http.get(xHTTPx + '/get_schedule_blocks').then(response => {
        this.schedule = response.body.map(function(s){
          s.open = false
          return s
        })
        this.sortSchedule()
      })
    },
    sortSchedule () {
      this.schedule.sort(function(a, b){
        return a.time - b.time
      })
    },
    scheduleBlockChanged (obj) {
      for(var i=0;i<this.schedule.length;i++){
        var s = this.schedule[i]
        if(s.id == obj.id){
          s.name = obj.name
          s.time = obj.time
          s.content = obj.content
        }
      }
      this.sortSchedule()
    },
    scheduleBlockDeleted (obj) {
      var index = -1
      for(var i=0;i<this.schedule.length;i++){
        var s = this.schedule[i]
        if(s.id == obj.id){
          index = i
        }
      }
      this.schedule.splice(index, 1)
    }
  },
  mounted () {
    this.requestCoworkers()
    this.requestSchedule()
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

.schedule-block {
  margin-top: 20px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.coworkders-block {
  margin-top: 50px;
  margin-bottom: 20px;
  padding-left: 10px;
  padding-right: 10px;
}

.new-schedule-title {
  padding-left: 0px;
  cursor: auto;
}

.up-down-button {
  float: right;
}

</style>
