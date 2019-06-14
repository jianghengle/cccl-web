<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Login</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        
        <div class="field">
          <label class="label">Username</label>
          <div class="control">
            <input class="input" type="text" v-model="username">
          </div>
        </div>

        <div class="field">
          <label class="label">Password</label>
          <div class="control">
            <input class="input" type="password" v-model="password">
          </div>
        </div>

        <div class="field">
          <p class="control">
            <label class="checkbox">
              <input type="checkbox" v-model="rememberMe">
              Remember me
            </label>
          </p>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-link" :class="{'is-loading': waiting}" @click="login" :disabled="!canLogin">Login</a>
        <a class="button" @click="close">Cancel</a>
      </footer>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'login-modal',
  data () {
    return {
      waiting: false,
      error: '',
      username: '',
      password: '',
      rememberMe: false
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.loginModal.opened
    },
    canLogin () {
      return this.username && this.password
    }
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.username = ''
        this.password = ''
        this.rememberMe = ''
      }
    },
  },
  methods: {
    close(){
      this.$store.commit('modals/closeLoginModal')
    },
    login(){
      if(!this.canLogin || this.waiting)
        return
      this.waiting = true
      var message = {
        username: this.username,
        password: this.password
      }
      this.$http.post(xHTTPx + '/get_auth_token', message).then(response => {
        var resp = response.body
        var token = resp.token
        Vue.http.headers.common['Authorization'] = token
        this.$store.commit('user/setToken', token)
        if (this.rememberMe) {
          localStorage.setItem('token', token)
        }
        this.error = ''
        this.waiting = false
        this.close()
      }, response => {
        this.error = 'Failed to login!'
        this.waiting = false
      })
    }
  },
}
</script>

<style lang="scss" scoped>

</style>