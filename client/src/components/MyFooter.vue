<template>
  <div>
    <footer class="footer my-footer">
      <div class="container">
        <div class="content has-text-centered footer-text">
          <p class="my-links">
            <router-link class="my-link" :to="'/'">
              首页 Home
            </router-link>
            &nbsp;| &nbsp;
            <router-link class="my-link" :to="'/about'">
              关于我们 About Us
            </router-link>
            &nbsp;| &nbsp;
            <router-link class="my-link" :to="'/coworkers'">
              同工 Coworkers
            </router-link>
            &nbsp;| &nbsp;
            <router-link class="my-link" :to="'/files'">
              资源 Resources
            </router-link>
            &nbsp;| &nbsp;
            <a class="my-link" v-if="!token" @click="login">
              登录 Login
            </a>
            <a class="my-link" v-if="token" @click="logout">
              退出 Logout
            </a>
          </p>
          <p class="my-links">
            <a class="my-link" href="http://omahaccc.org/" target="_blank">
              奥马哈华人基督教会 Omaha Chinese Christian Church
            </a>
            &nbsp;| &nbsp;
            <a class="my-link" href="http://cwcnet.org" target="_blank">
              基督工人中心 Christian Witness Center
            </a>
          </p>
          <p>
            <span class="has-text-weight-bold">地址: </span> 在13街和K街十字路口西北角, 聚会地点在地下一层，请由建筑北门进入。<br />
            <span class="has-text-weight-bold">Address: </span> First Baptist Church, 1340 K St. Lincoln, NE 68508
          </p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'my-footer',
  data () {
    return {
      msg: 'Welcome to Your Vue.js App'
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
  }
}
</script>

<style lang="scss" scoped>

.my-footer {
  background-color: #250d3c;

  .my-links {
    color: #ebb22f;

    .my-link {
      color: #ebb22f;
    }

    .my-link:hover {
      color: white;
    }
  }

  .footer-text {
    color: white;
  }
}


</style>
