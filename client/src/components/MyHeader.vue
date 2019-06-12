<template>
  <div>
    <nav class="navbar has-shadow">
      <div class="container">
        <div class="navbar-brand">
          <router-link class="navbar-item is-size-4 has-text-weight-bold has-text-black" :to="'/'">
            林肯华人基督教会
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
            <a class="navbar-item">
              关于我们 About Us
            </a>
            <a class="navbar-item">
              同工 Coworkers
            </a>
            <a class="navbar-item">
              文件 Files
            </a>
          </div>
          <div class="navbar-end">
            <div class="navbar-item">
              <div class="field is-grouped">
                <p class="control">
                  <a class="button">
                    <v-icon name="sign-in-alt"/>&nbsp;Sign In
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
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="scss" scoped>

</style>
