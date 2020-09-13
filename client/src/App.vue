<template>
  <div id="app">
    <my-header></my-header>
    <div class="my-body">
      <router-view></router-view>
    </div>
    <my-footer></my-footer>

    <login-modal></login-modal>
    <new-file-modal></new-file-modal>
    <new-folder-modal></new-folder-modal>
    <add-menu-modal></add-menu-modal>
    <edit-menu-modal></edit-menu-modal>
    <confirm-modal></confirm-modal>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader'
import MyFooter from './components/MyFooter'
import ConfirmModal from './components/modals/ConfirmModal'
import LoginModal from './components/modals/LoginModal'
import NewFileModal from './components/modals/NewFileModal'
import NewFolderModal from './components/modals/NewFolderModal'
import AddMenuModal from './components/modals/AddMenuModal'
import EditMenuModal from './components/modals/EditMenuModal'

export default {
  name: 'App',
  components: {
    MyHeader,
    MyFooter,
    ConfirmModal,
    LoginModal,
    NewFileModal,
    NewFolderModal,
    AddMenuModal,
    EditMenuModal
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
$blue: #24292e;
$text-strong: inherit;
@import "~bulma";

.background {
  position: absolute;
  top: 0px;
  left: 0px;
  width: 100%;
  height: 300px;
}

.my-body {
  min-height: 640px;
  padding-bottom: 20px;
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

.schedule-blocks ul{
  margin-left: 1em;
}
</style>
