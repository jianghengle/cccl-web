<template>
  <div>
    <nav class="navbar my-navbar">
      <div class="container">
        <div class="navbar-brand">
          <router-link class="navbar-item is-size-4 has-text-weight-bold my-title" :to="'/'">
            林肯华人基督教会
            <img src="static/logo.png" />
          </router-link>
          <div class="navbar-burger burger app-burger my-menu" :class="{'is-active': menuActive}"
            @click="menuActive = !menuActive">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
        <div class="navbar-menu" :class="{'is-active': menuActive}">
          <div class="navbar-start">
            <router-link class="navbar-item my-menu" :to="'/about'">
              关于我们 About Us
            </router-link>
            <router-link class="navbar-item my-menu" :to="'/coworkers'">
              同工 Coworkers
            </router-link>
            <router-link  class="navbar-item my-menu" :to="'/files'">
              资源 Resources
            </router-link>
          </div>
          <div class="navbar-end">
            <div class="navbar-item">
              <div class="field is-grouped">
                <p class="control" v-if="!token">
                  <a class="button my-button" @click="login">
                    <v-icon name="sign-in-alt"/>&nbsp;Login
                  </a>
                </p>
                <p class="control" v-if="token">
                  <a class="button my-button" @click="logout">
                    <v-icon name="sign-out-alt"/>&nbsp;Logout
                  </a>
                </p>
              </div>
            </div>
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

.my-navbar {
  background-color: transparent;

  .navbar-menu {
    background-color: transparent;
  }
}

.my-title {
  color: white;
}

.my-title:hover {
  background-color: transparent;
  color: white;
}

.my-menu {
  color: hsla(0,0%,100%,.65);
}

.my-menu:hover {
  background-color: transparent;
  color: #dddddd;
}

.my-button {
  color: hsla(0,0%,100%,.65);
  background-color: transparent;
}

.my-button:hover {
  background-color: transparent;
  color: #dddddd;
}

</style>
