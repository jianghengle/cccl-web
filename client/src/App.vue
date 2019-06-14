<template>
  <div id="app">
    <my-header></my-header>
    <div>
      <router-view></router-view>
    </div>
    <my-footer></my-footer>

    <confirm-modal></confirm-modal>
    <login-modal></login-modal>
  </div>
</template>

<script>
import MyHeader from './components/MyHeader'
import MyFooter from './components/MyFooter'
import ConfirmModal from './components/modals/ConfirmModal'
import LoginModal from './components/modals/LoginModal'

export default {
  name: 'App',
  components: {
    MyHeader,
    MyFooter,
    ConfirmModal,
    LoginModal,
  }
}
</script>

<style lang="scss">
@import "~bulma/sass/utilities/initial-variables";
$navbar-height: 84px;
@import "~bulma";

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
