<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Add Menu</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        
        <div class="field">
          <label class="label">Name</label>
          <div class="control">
            <input class="input" type="text" v-model="name">
          </div>
        </div>

        <div class="field">
          <label class="label">Index</label>
          <div class="control">
            <input class="input" type="number" step="1" v-model="index">
          </div>
          <p class="help is-info">This just affects its order shown in the menu.</p>
        </div>

        <div class="field">
          <label class="label">Link</label>
          <div class="control">
            <input class="input" type="text" v-model="url">
          </div>
          <p class="help is-info">The url to another website/page or leave it blank to make a new page.</p>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-link" :class="{'is-loading': waiting}" @click="addMenu" :disabled="!canAddMenu">Add</a>
        <a class="button" @click="close">Cancel</a>
      </footer>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'add-menu-modal',
  data () {
    return {
      waiting: false,
      error: '',
      name: '',
      index: 0,
      url: ''
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.addMenuModal.opened
    },
    parentId () {
      return this.$store.state.modals.addMenuModal.parentId
    },
    canAddMenu () {
      return this.name
    }
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.name = ''
        this.index = 0
        this.url = ''
      }
    },
  },
  methods: {
    close(){
      this.$store.commit('modals/closeAddMenuModal')
    },
    addMenu(){
      if(!this.canAddMenu || this.waiting)
        return
      this.waiting = true
      var message = {
        parentId: this.parentId,
        name: this.name,
        menuIndex: this.index,
        url: this.url
      }
      this.$http.post(xHTTPx + '/create_menu', message).then(response => {
        var callback = this.$store.state.modals.addMenuModal.callback
        if(callback){
          var method = callback.method
          var context = callback.context
          var args = callback.args
          method.apply(context, args)
        }
        this.error = ''
        this.waiting = false
        this.close()
      }, response => {
        this.error = 'Failed to add!'
        this.waiting = false
      })
    }
  },
}
</script>

<style lang="scss" scoped>

</style>