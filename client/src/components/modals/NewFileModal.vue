<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">New Resource</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div class="my-form" v-if="opened">
          <div class="field">
            <label class="label">Upload File?</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <label class="radio">
                    <input type="radio" value="Yes" v-model="uploadFile">
                    Yes
                  </label>
                  <label class="radio">
                    <input type="radio" value="No" v-model="uploadFile">
                    No
                  </label>
                </div>
              </div>
            </div>
          </div>

          <div class="field" v-show="uploadFile=='Yes'">
            <label class="label">File</label>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <label class="file-label">
                    <input class="file-input" type="file" multiple @change="onFileChange">
                    <span class="file-cta">
                      <span class="file-icon">
                        <v-icon name="upload"></v-icon>
                      </span>
                      <span class="file-label">
                        {{files.length ? files.length + ' Selected' : 'Choose File(s)'}}
                      </span>
                    </span>
                  </label>
                </div>
              </div>
            </div>
          </div>

          <div class="field" v-show="uploadFile=='No'">
            <label class="label">Name</label>
            <div class="control">
              <input class="input" type="text" v-model="name">
            </div>
          </div>

          <div class="field">
            <label class="label">File Type</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <div class="select is-fullwidth">
                    <select v-model="fileType">
                      <option>Picture</option>
                      <option>Document</option>
                      <option>Video</option>
                      <option>Audio</option>
                      <option>YouTube</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="field" v-show="uploadFile=='No'">
            <label class="label">Url</label>
            <div class="control">
              <input class="input" type="text" v-model="url">
            </div>
          </div>

          <div class="field">
            <label class="label">Shown in Home Page Slides?</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <label class="radio">
                    <input type="radio" value="Yes" v-model="showOnHome">
                    Yes
                  </label>
                  <label class="radio">
                    <input type="radio" value="No" v-model="showOnHome">
                    No
                  </label>
                </div>
              </div>
            </div>
          </div>

          <div class="field" v-show="showOnHome=='Yes'">
            <label class="label">Slide Order</label>
            <div class="control">
              <input class="input" type="number" step="1" v-model.number="showOrder">
            </div>
          </div>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-link" :disabled="!canCreate" @click="create" :class="{'is-loading': waiting}">Create</a>
        <a class="button" @click="close">Close</a>
      </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'new-file-modal',
  data () {
    return {
      waiting: false,
      error: '',
      uploadFile: 'Yes',
      files: [],
      name: '',
      fileType: '',
      url: '',
      showOnHome: 'No',
      showOrder: 1
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.newFileModal.opened
    },
    canCreate () {
      return this.uploadFile == 'Yes' ? this.files.length : (this.url && this.name)
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
        this.files = []
        this.name = ''
        this.fileType = ''
        this.url = ''
        this.showOnHome = 'No'
        this.showOrder = 1
      }
    },
  },
  methods: {
    close (){
      this.$store.commit('modals/closeNewFileModal')
    },
    doneUpload () {
      var callback = this.$store.state.modals.newFileModal.callback
      var method = callback.method
      var context = callback.context
      var args = [this.fileType]
      method.apply(context, args)
      this.close()
    },
    create(){
      if(!this.canCreate || this.waiting)
        return
      this.waiting = true

      var promises = []
      if(this.uploadFile == 'Yes'){
        for(var i=0;i<this.files.length;i++){
          var file = this.files[i]
          var formData = new FormData()
          formData.append('uploadFile', this.uploadFile)
          formData.append('name', this.name)
          formData.append('path', this.path)
          formData.append('fileType', this.fileType)
          formData.append('url', this.url)
          formData.append('info', this.showOnHome == 'Yes' ? this.showOrder : '')
          formData.append('file', file)
          var promise = this.$http.post(xHTTPx + '/create_file', formData).then(response => {
            this.error = ''
          }, response => {
            this.error = 'Failed to create!'
          })
          promises.push(promise)
        }
      }else{
        var formData = new FormData()
        formData.append('uploadFile', this.uploadFile)
        formData.append('name', this.name.trim())
        formData.append('path', this.path)
        formData.append('fileType', this.fileType)
        formData.append('url', this.url.trim())
        formData.append('info', this.showOnHome == 'Yes' ? this.showOrder : '')
        var promise = this.$http.post(xHTTPx + '/create_file', formData).then(response => {
          this.error = ''
        }, response => {
          this.error = 'Failed to create!'
        })
        promises.push(promise)
      }

      var vm = this
      Promise.all(promises).then((response) => {
        vm.waiting = false
        vm.doneUpload()
      }, (response) => {
        vm.waiting = false
        vm.error = 'Some uploads failed...'
      })
    },
    onFileChange(e) {
      var files = e.target.files || e.dataTransfer.files
      if (!files.length)
        return
      this.files = files
    }
  },
}
</script>

<style lang="scss" scoped>
.my-form {
  margin-bottom: 10px;
}
</style>