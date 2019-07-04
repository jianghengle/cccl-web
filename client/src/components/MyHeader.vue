<template>
  <div>
    <nav class="navbar has-shadow is-link">
      <div class="container">
        <div class="navbar-brand">
          <router-link class="navbar-item has-text-weight-bold" :to="'/'">
            林肯华人基督教会 CCCL
          </router-link>
          <div class="navbar-burger burger app-burger" :class="{'is-active': menuActive}"
            @click="menuActive = !menuActive">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
        <div class="navbar-menu" :class="{'is-active': menuActive}">
          <div class="navbar-start">
            <router-link class="navbar-item" :to="'/about'">
              关于我们 About Us
            </router-link>
            <router-link class="navbar-item" :to="'/coworkers'">
              同工 Coworkers
            </router-link>
            <router-link  class="navbar-item" :to="'/files'">
              资源 Resources
            </router-link>
          </div>
          <div class="navbar-end">
            <a class="navbar-item" v-if="!token" @click="login">
              <v-icon name="sign-in-alt"/>&nbsp;Login
            </a>
            <a class="navbar-item" v-if="token" @click="logout">
              <v-icon name="sign-out-alt"/>&nbsp;Logout
            </a>
          </div>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'my-header',
  data () {
    return {
      menuActive: false
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    }
  },
  methods: {
    login () {
      this.$store.commit('modals/openLoginModal')
    },
    logout () {
      var confirm = {
        title: 'Logout',
        message: 'Are you sure to logout?',
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.logoutConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    logoutConfirmed () {
      delete Vue.http.headers.common['Authorization']
      this.$store.commit('user/reset')
    }
  },
  mounted () {
    if(this.token) {
      Vue.http.headers.common['Authorization'] = this.token
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

</style>
