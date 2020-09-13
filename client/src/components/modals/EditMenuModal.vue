<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Edit Menu</p>
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
        <a class="button is-link" :class="{'is-loading': waiting}" @click="editMenu" :disabled="!canEditMenu">Update</a>
        <a class="button is-danger" :class="{'is-loading': waiting}" @click="deleteMenu">Delete</a>
        <a class="button" @click="close">Cancel</a>
      </footer>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'edit-menu-modal',
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
      return this.$store.state.modals.editMenuModal.opened
    },
    isParent () {
      return this.$store.state.modals.editMenuModal.isParent
    },
    canEditMenu () {
      return this.name
    },
    menuId () {
      return this.$store.state.modals.editMenuModal.id
    }
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.id = this.$store.state.modals.editMenuModal.id
        this.name = this.$store.state.modals.editMenuModal.name
        this.index = this.$store.state.modals.editMenuModal.index
        this.url = this.$store.state.modals.editMenuModal.url
      }
    },
  },
  methods: {
    close(){
      this.$store.commit('modals/closeEditMenuModal')
    },
    editMenu(){
      if(!this.canEditMenu || this.waiting)
        return
      this.waiting = true
      var message = {
        id: this.menuId,
        name: this.name,
        menuIndex: this.index,
        url: this.url
      }
      this.$http.post(xHTTPx + '/update_menu', message).then(response => {
        var callback = this.$store.state.modals.editMenuModal.callback
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
        this.error = 'Failed to update!'
        this.waiting = false
      })
    },
    deleteMenu(){
      if(this.waiting)
        return
      var message = 'Are you sure to delete this menu? The related page will also be deleted.'
      if(this.isParent){
         var message = 'Are you sure to delete this parent menu? All its sub menus and related pages will also be deleted' 
      }
      var confirm = {
        title: 'Delete Menu',
        message: message,
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.deleteMenuConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteMenuConfirmed(){
      this.waiting = true
      var message = {id: this.menuId}
      this.$http.post(xHTTPx + '/delete_menu', message).then(response => {
        var callback = this.$store.state.modals.editMenuModal.callback
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
        this.error = 'Failed to delete!'
        this.waiting = false
      }) 
    }
  },
}
</script>

<style lang="scss" scoped>

</style>