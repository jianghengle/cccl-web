<template>
  <div>
    <div class="container schedule-block">
      <h4 class="title is-4">Schedule</h4>
      <div class="schedule-table">
      </div>
      <div class="new-schedule-block" v-if="token">
        <div v-if="newSchedule">
          <div class="field">
            <label class="label">New Schedule</label>
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
              <input class="input" type="text" placeholder="Event name">
            </div>
          </div>

          <div class="field">
            <div class="control">
              <textarea class="textarea" placeholder="Coworker arrangement"></textarea>
            </div>
          </div>

          <div class="field is-grouped">
            <div class="control">
              <button class="button is-link">Add</button>
            </div>
            <div class="control">
              <button class="button is-text" @click="newSchedule = false">Cancel</button>
            </div>
          </div>

        </div>
        <div v-else>
          <a class="button" @click="newSchedule = true">New Schedule</a>
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
  },
  mounted () {
    this.requestCoworkers()
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

</style>
