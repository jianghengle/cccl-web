<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">New Directory</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div class="my-form">
          <div class="field">
            <label class="label">Name</label>
            <div class="control">
              <input class="input" type="text" v-model="name">
            </div>
          </div>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-link" :disabled="!name.trim()" @click="create" :class="{'is-loading': waiting}">Create</a>
        <a class="button" @click="close">Close</a>
      </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'new-folder-modal',
  data () {
    return {
      waiting: false,
      error: '',
      name: '',
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.newFolderModal.opened
    },
    path () {
      var path = this.$route.params.path
      return path ? decodeURIComponent(path) : ''
    },
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.name = ''
      }
    },
  },
  methods: {
    close (){
      this.$store.commit('modals/closeNewFolderModal')
    },
    doneCreate () {
      var callback = this.$store.state.modals.newFolderModal.callback
      var method = callback.method
      var context = callback.context
      method.apply(context, [])
      this.close()
    },
    create(){
      if(!this.name || this.waiting)
        return
      this.waiting = true
      this.$http.post(xHTTPx + '/create_directory', {name: this.name.trim(), path: this.path}).then(response => {
        this.error = ''
        this.waiting = false
        this.doneCreate()
      }, response => {
        this.error = 'Failed to create!'
        this.waiting = false
      })
    }
  },
}
</script>

<style lang="scss" scoped>
.my-form {
  margin-bottom: 10px;
}
</style>