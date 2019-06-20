<template>
  <div id="app">
    <my-header></my-header>
    <div class="my-body">
      <router-view></router-view>
    </div>
    <my-footer></my-footer>

    <confirm-modal></confirm-modal>
    <login-modal></login-modal>
    <new-file-modal></new-file-modal>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader'
import MyFooter from './components/MyFooter'
import ConfirmModal from './components/modals/ConfirmModal'
import LoginModal from './components/modals/LoginModal'
import NewFileModal from './components/modals/NewFileModal'

export default {
  name: 'App',
  components: {
    MyHeader,
    MyFooter,
    ConfirmModal,
    LoginModal,
    NewFileModal
  },
  methods: {
    handleResize () {
      this.$store.commit('ui/setWindowWidth', window.innerWidth)
    },
  },
  mounted () {
    this.handleResize()
    window.addEventListener('resize', this.handleResize)
  },
  beforeDestroy () {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>

<style lang="scss">
@import "~bulma/sass/utilities/initial-variables";
$navbar-height: 84px;
@import "~bulma";

.my-body {
  min-height: 500px;
}

.date-picker-wrapper {
  display: inline-block;
}

.date-picker-input{
  cursor: pointer;
  height: 35px;
  width: 120px;
  text-align: center;
  font-size: 1rem;
}
</style>
